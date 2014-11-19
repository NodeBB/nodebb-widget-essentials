(function(module) {
	"use strict";

	var async = require('async'),
		fs = require('fs'),
		path = require('path'),
		categories = module.parent.require('./categories'),
		user = module.parent.require('./user'),
		plugins = module.parent.require('./plugins'),
		topics = module.parent.require('./topics'),
		posts = module.parent.require('./posts'),
		translator = module.parent.require('../public/src/translator'),
		templates = module.parent.require('templates.js'),
		app;


	var Widget = {
		templates: {}
	};

	Widget.init = function(params, callback) {
		app = params.app;

		var templatesToLoad = [
			"activeusers.tpl", "moderators.tpl", "forumstats.tpl",
			"categories.tpl", "populartags.tpl",
			"admin/categorywidget.tpl", "admin/forumstats.tpl", "admin/html.tpl", "admin/text.tpl", "admin/recentposts.tpl",
			"admin/recenttopics.tpl", "admin/defaultwidget.tpl", "admin/categorieswidget.tpl", "admin/populartags.tpl"
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
		callback(null, widget.data.html);
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

			user.getMultipleUserFields(uids, ['uid', 'username', 'userslug', 'picture'], function(err, users) {
				if (err) {
					return callback(err);
				}

				html = templates.parse(html, {active_users: users});

				callback(err, html);
			});
		}

		var html = Widget.templates['activeusers.tpl'], cidOrtid;
		var match;
		if (widget.data.cid) {
			cidOrtid = widget.data.cid;
			categories.getActiveUsers(cidOrtid, getUserData);
		} else if (widget.area.url.indexOf('topic') === 0) {
			match = widget.area.url.match('topic/([0-9]+)');
			cidOrtid = (match && match.length > 1) ? match[1] : 1;
			topics.getUids(cidOrtid, getUserData);
		} else if (widget.area.url === '') {
			posts.getRecentPosterUids(0, 24, getUserData);
		} else {
			match = widget.area.url.match('[0-9]+');
			cidOrtid = match ? match[0] : 1;
			categories.getActiveUsers(cidOrtid, getUserData);
		}
	};

	Widget.renderModeratorsWidget = function(widget, callback) {
		var html = Widget.templates['moderators.tpl'], cid;

		if (widget.data.cid) {
			cid = widget.data.cid;
		} else {
			var match = widget.area.url.match('[0-9]+');
			cid = match ? match[0] : 1;
		}

		categories.getModerators(cid, function(err, moderators) {
			html = templates.parse(html, {moderators: moderators});

			callback(err, html);
		});
	};

	Widget.renderForumStatsWidget = function(widget, callback) {
		var html = Widget.templates['forumstats.tpl'];

		html = templates.parse(html, {statsClass: widget.data.statsClass});

		translator.translate(html, function(translatedHTML) {
			callback(null, translatedHTML);
		});
	};

	Widget.renderRecentPostsWidget = function(widget, callback) {
		function done(err, posts) {
			if (err) {
				return callback(err);
			}
			app.render('recentposts', {posts: posts, numPosts: numPosts, cid: cid}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		}
		var cid = widget.data.cid;
		if (!cid) {
			var match = widget.area.url.match('category/([0-9]+)');
			cid = (match && match.length > 1) ? match[1] : null;
		}
		var numPosts = widget.data.numPosts || 4;
		if (cid) {
			categories.getRecentReplies(cid, widget.uid, numPosts, done);
		} else {
			posts.getRecentPosts(widget.uid, 0, numPosts, widget.data.duration || 'day', done);
		}
	};

	Widget.renderRecentTopicsWidget = function(widget, callback) {
		var numTopics = widget.data.numTopics || 8;

		topics.getTopicsFromSet('topics:recent', widget.uid, 0, numTopics, function(err, data) {
			if (err) {
				return callback(err);
			}

			app.render('recenttopics', {topics: data.topics, numTopics: numTopics}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderCategories = function(widget, callback) {
		var html = Widget.templates['categories.tpl'];

		categories.getCategoriesByPrivilege(widget.uid, 'find', function(err, data) {
			html = templates.parse(html, {categories: data});

			callback(err, html);
		});
	};

	Widget.renderPopularTags = function(widget, callback) {
		var html = Widget.templates['populartags.tpl'];
		var numTags = widget.data.numTags || 8;
		topics.getTags(0, numTags - 1, function(err, tags) {
			if (err) {
				return callback(err);
			}

			html = templates.parse(html, {tags: tags});

			callback(err, html);
		});
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
				widget: "activeusers",
				name: "Active Users",
				description: "List of active users in a category.",
				content: Widget.templates['admin/categorywidget.tpl']
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
			}
		]);

		callback(null, widgets);
	};


	module.exports = Widget;
}(module));