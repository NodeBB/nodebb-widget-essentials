(function(module) {
	"use strict";

	var async = module.parent.require('async');
	var nconf = module.parent.require('nconf');
	var fs = require('fs');
	var path = require('path');
	var db = module.parent.require('./database');
	var categories = module.parent.require('./categories');
	var user = module.parent.require('./user');
	var plugins = module.parent.require('./plugins');
	var topics = module.parent.require('./topics');
	var posts = module.parent.require('./posts');
	var groups = module.parent.require('./groups');
	var translator = module.parent.require('../public/src/modules/translator');
	var templates = module.parent.require('templates.js');
	var websockets = module.parent.require('./socket.io');
	var app;


	var Widget = {
		templates: {}
	};

	Widget.init = function(params, callback) {
		app = params.app;

		var templatesToLoad = [
			"widgets/activeusers.tpl", "widgets/moderators.tpl",
			"widgets/categories.tpl", "widgets/populartags.tpl",
			"widgets/populartopics.tpl", "widgets/groups.tpl",

			"admin/categorywidget.tpl", "admin/forumstats.tpl",
			"admin/html.tpl", "admin/text.tpl", "admin/recentposts.tpl",
			"admin/recenttopics.tpl", "admin/defaultwidget.tpl",
			"admin/categorieswidget.tpl", "admin/populartags.tpl",
			"admin/populartopics.tpl", "admin/mygroups.tpl",
			"admin/activeusers.tpl", "admin/latestusers.tpl",
			"admin/groupposts.tpl"
		];

		function loadTemplate(template, next) {
			fs.readFile(path.resolve(__dirname, './public/templates/' + template), function (err, data) {
				if (err) {
					console.log(err.message);
					return next(err);
				}
				Widget.templates[template] = data.toString();
				next(null);
			});
		}

		async.each(templatesToLoad, loadTemplate);

		callback();
	};

	Widget.renderHTMLWidget = function(widget, callback) {
		callback(null, widget.data ? widget.data.html : '');
	};

	Widget.renderTextWidget = function(widget, callback) {
		var parseAsPost = !!widget.data.parseAsPost,
			text = widget.data.text;

		if (parseAsPost) {
			plugins.fireHook('filter:parse.raw', text, callback);
		} else {
			callback(null, text.replace(/\r\n/g, "<br />"));
		}
	};

	Widget.renderRecentViewWidget = function(widget, callback) {
		topics.getLatestTopics(widget.uid, 0, 19, 'month', function (err, data) {
			if(err) {
				return callback(err);
			}

			data.relative_path = nconf.get('relative_path');

			app.render('recent', data, function(err, html) {
				html = html.replace(/<ol[\s\S]*?<br \/>/, '').replace('<br>', '');

				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderActiveUsersWidget = function(widget, callback) {
		function getUserData(err, uids) {
			if (err) {
				return callback(err);
			}

			uids = uids.slice(0, count);

			user.getUsersFields(uids, ['uid', 'username', 'userslug', 'picture'], function(err, users) {
				if (err) {
					return callback(err);
				}

				html = templates.parse(html, {
					active_users: users,
					relative_path: nconf.get('relative_path')
				});

				callback(err, html);
			});
		}
		var count = Math.max(1, widget.data.numUsers || 24);
		var html = Widget.templates['widgets/activeusers.tpl'], cidOrtid;
		var match;
		if (widget.data.cid) {
			cidOrtid = widget.data.cid;
			categories.getActiveUsers(cidOrtid, getUserData);
		} else if (widget.area.url.startsWith('topic')) {
			match = widget.area.url.match('topic/([0-9]+)');
			cidOrtid = (match && match.length > 1) ? match[1] : 1;
			topics.getUids(cidOrtid, getUserData);
		} else if (widget.area.url === '') {
			posts.getRecentPosterUids(0, count - 1, getUserData);
		} else {
			match = widget.area.url.match('[0-9]+');
			cidOrtid = match ? match[0] : 1;
			categories.getActiveUsers(cidOrtid, getUserData);
		}
	};

	Widget.renderLatestUsersWidget = function(widget, callback) {
		var count = Math.max(1, widget.data.numUsers || 24);
		user.getUsersFromSet('users:joindate', widget.uid, 0, count - 1, function(err, users) {
			if (err) {
				return callback(err);
			}
			var data = {
				users: users,
				relative_path: nconf.get('relative_path')
			};
			app.render('widgets/latestusers', data, callback);
		});
	};


	Widget.renderModeratorsWidget = function(widget, callback) {
		var html = Widget.templates['widgets/moderators.tpl'], cid;

		if (widget.data.cid) {
			cid = widget.data.cid;
		} else {
			var match = widget.area.url.match('[0-9]+');
			cid = match ? match[0] : 1;
		}

		categories.getModerators(cid, function(err, moderators) {
			if (err) {
				return callback(err);

			}

			html = templates.parse(html, {
				moderators: moderators,
				relative_path: nconf.get('relative_path')
			});

			callback(null, html);
		});
	};

	Widget.renderForumStatsWidget = function(widget, callback) {
		async.parallel({
			global: function(next) {
				db.getObjectFields('global', ['topicCount', 'postCount', 'userCount'], next);
			},
			onlineCount: function(next) {
				var now = Date.now();
				db.sortedSetCount('users:online', now - 300000, '+inf', next);
			},
			guestCount: function(next) {
				module.parent.require('./socket.io/admin/rooms').getTotalGuestCount(next);
			}
		}, function(err, results) {
			if (err) {
				return callback(err);
			}

			var stats = {
				topics: results.global.topicCount ? results.global.topicCount : 0,
				posts: results.global.postCount ? results.global.postCount : 0,
				users: results.global.userCount ? results.global.userCount : 0,
				online: results.onlineCount + results.guestCount,
				statsClass: widget.data.statsClass
			};
			app.render('widgets/forumstats', stats, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderRecentPostsWidget = function(widget, callback) {
		function done(err, posts) {
			if (err) {
				return callback(err);
			}
			var data = {
				posts: posts,
				numPosts: numPosts,
				cid: cid,
				relative_path: nconf.get('relative_path')
			};
			app.render('widgets/recentposts', data, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		}
		var cid = widget.data.cid;
		if (!parseInt(cid, 10)) {
			var match = widget.area.url.match('category/([0-9]+)');
			cid = (match && match.length > 1) ? match[1] : null;
		}
		var numPosts = widget.data.numPosts || 4;
		if (cid) {
			categories.getRecentReplies(cid, widget.uid, numPosts, done);
		} else {
			posts.getRecentPosts(widget.uid, 0, Math.max(0, numPosts - 1), 'alltime', done);
		}
	};

	Widget.renderRecentTopicsWidget = function(widget, callback) {
		var numTopics = (widget.data.numTopics || 8) - 1;

		topics.getTopicsFromSet('topics:recent', widget.uid, 0, Math.max(0, numTopics), function(err, data) {
			if (err) {
				return callback(err);
			}

			app.render('widgets/recenttopics', {
				topics: data.topics,
				numTopics: numTopics,
				relative_path: nconf.get('relative_path')
			}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderCategories = function(widget, callback) {
		var html = Widget.templates['widgets/categories.tpl'];

		categories.getCategoriesByPrivilege('cid:0:children', widget.uid, 'find', function(err, data) {
			html = templates.parse(html, {
				categories: data,
				relative_path: nconf.get('relative_path')
			});

			callback(err, html);
		});
	};

	Widget.renderPopularTags = function(widget, callback) {
		var html = Widget.templates['widgets/populartags.tpl'];
		var numTags = widget.data.numTags || 8;
		topics.getTags(0, numTags - 1, function(err, tags) {
			if (err) {
				return callback(err);
			}

			html = templates.parse(html, {
				tags: tags,
				relative_path: nconf.get('relative_path')
			});

			callback(err, html);
		});
	};

	Widget.renderPopularTopics = function(widget, callback) {
		var numTopics = widget.data.numTopics || 8;
		topics.getPopular(widget.data.duration || 'alltime', widget.uid, numTopics, function(err, topics) {
			if (err) {
				return callback(err);
			}

			app.render('widgets/populartopics', {
				topics: topics,
				numTopics: numTopics,
				relative_path: nconf.get('relative_path')
			}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderMyGroups = function(widget, callback) {
		var uid = widget.uid;
		var numGroups = parseInt(widget.data.numGroups, 10) || 9;
		groups.getUserGroups([uid], function(err, groupsData) {
			if (err) {
				return callback(err);
			}
			var userGroupData = groupsData.length ? groupsData[0] : [];
			userGroupData = userGroupData.slice(0, numGroups);
			app.render('widgets/groups', {
				groups: userGroupData,
				relative_path: nconf.get('relative_path')
			}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderGroupPosts = function(widget, callback) {
		var numPosts = parseInt(widget.data.numPosts, 10) || 4;
		async.waterfall([
			function (next) {
				groups.getLatestMemberPosts(widget.data.groupName, numPosts, widget.uid, next);
			},
			function (posts, next) {
				app.render('widgets/groupposts', {posts: posts}, next);
			},
			function(html, next) {
				translator.translate(html, function(translatedHTML) {
					next(null, translatedHTML);
				});
			}
		], callback);
	};

	Widget.renderNewGroups = function(widget, callback) {
		var numGroups = parseInt(widget.data.numGroups, 10) || 8;
		async.waterfall([
			function(next) {
				db.getSortedSetRevRange('groups:visible:createtime', 0, numGroups - 1, next);
			},
			function(groupNames, next) {
				groups.getGroupsData(groupNames, next);
			},
			function(groupsData, next) {
				groupsData = groupsData.filter(Boolean);

				app.render('widgets/groups', {groups: groupsData, relative_path: nconf.get('relative_path')}, function(err, html) {
					translator.translate(html, function(translatedHTML) {
						next(err, translatedHTML);
					});
				});
			}
		], callback);
	};

	Widget.renderSuggestedTopics = function(widget, callback) {

		var numTopics = (widget.data.numTopics || 8) - 1;
		var tidMatch = widget.area.url.match('topic/([0-9]+)');
		var cidMatch = widget.area.url.match('category/([0-9]+)');

		if (tidMatch) {
			var tid = tidMatch.length > 1 ? tidMatch[1] : 1;
			topics.getSuggestedTopics(tid, widget.uid, 0, numTopics, function(err, topics) {
				if (err) {
					return callback(err);
				}
				app.render('widgets/suggestedtopics', {
					topics: topics,
					relative_path: nconf.get('relative_path')
				}, callback);
			});
		} else if (cidMatch) {
			var cid = cidMatch.length > 1 ? cidMatch[1] : 1;
			categories.getCategoryTopics({
				cid: cid,
				uid: widget.uid,
				set: 'cid:' + cid + ':tids',
				reverse: false,
				start: 0,
				stop: numTopics
			}, function(err, data) {
				if (err) {
					return callback(err);
				}
				data.topics = data.topics.filter(function(topic) {
					return topic && !topic.deleted;
				});
				app.render('widgets/suggestedtopics', {
					topics: data.topics,
					relative_path: nconf.get('relative_path')
				}, callback);
			});
		} else {
			Widget.renderRecentTopicsWidget(widget, callback);
		}
	};

	Widget.defineWidgets = function(widgets, callback) {
		widgets = widgets.concat([
			{
				widget: "html",
				name: "HTML",
				description: "Any text, html, or embedded script.",
				content: Widget.templates['admin/html.tpl']
			},
			{
				widget: "text",
				name: "Text",
				description: "Text, optionally parsed as a post.",
				content: Widget.templates['admin/text.tpl']
			},
			{
				widget: "recentreplies",
				name: "Recent Replies[deprecated]",
				description: "List of recent replies in a category.",
				content: Widget.templates['admin/categorywidget.tpl']
			},
			{
				widget: "activeusers",
				name: "Active Users",
				description: "List of active users in a category.",
				content: Widget.templates['admin/activeusers.tpl']
			},
			{
				widget: "latestusers",
				name: "Latest Users",
				description: "List of latest registered users.",
				content: Widget.templates['admin/latestusers.tpl']
			},
			{
				widget: "moderators",
				name: "Moderators",
				description: "List of moderators in a category.",
				content: Widget.templates['admin/categorywidget.tpl']
			},
			{
				widget: "forumstats",
				name: "Forum Stats",
				description: "Lists user, topics, and post count.",
				content: Widget.templates['admin/forumstats.tpl']
			},
			{
				widget: "recentposts",
				name: "Recent Posts",
				description: "Lists the latest posts on your forum.",
				content: Widget.templates['admin/recentposts.tpl']
			},
			{
				widget: "recenttopics",
				name: "Recent Topics",
				description: "Lists the latest topics on your forum.",
				content: Widget.templates['admin/recenttopics.tpl']
			},
			{
				widget: "recentview",
				name: "Recent View",
				description: "Renders the /recent page",
				content: Widget.templates['admin/defaultwidget.tpl']
			},
			{
				widget: "categories",
				name: "Categories",
				description: "Lists the categories on your forum",
				content: Widget.templates['admin/categorieswidget.tpl']
			},
			{
				widget:"populartags",
				name:"Popular Tags",
				description:"Lists popular tags on your forum",
				content: Widget.templates['admin/populartags.tpl']
			},
			{
				widget:"populartopics",
				name:"Popular Topics",
				description:"Lists popular topics on your forum",
				content: Widget.templates['admin/populartopics.tpl']
			},
			{
				widget:"mygroups",
				name:"My Groups",
				description: "List of groups that you are in",
				content: Widget.templates['admin/mygroups.tpl']
			},
			{
				widget: "newgroups",
				name:"New Groups",
				description: "List of newest groups",
				content: Widget.templates['admin/mygroups.tpl']
			},
			{
				widget: "suggestedtopics",
				name: "Suggested Topics",
				description: "Lists of suggested topics.",
				content: Widget.templates['admin/recenttopics.tpl']
			}
		]);

		async.waterfall([
			function(next) {
				db.getSortedSetRevRange('groups:visible:createtime', 0, - 1, next);
			},
			function(groupNames, next) {
				groups.getGroupsData(groupNames, next);
			},
			function(groupsData, next) {
				groupsData = groupsData.filter(Boolean);

				templates.parse(Widget.templates['admin/groupposts.tpl'], {groups: groupsData}, function(html) {
					widgets.push({
						widget: "groupposts",
						name: "Group Posts",
						description: "Posts made my members of a group",
						content: html
					});
					next(null, widgets);
				});
			}
		], callback);
	};


	module.exports = Widget;
}(module));
