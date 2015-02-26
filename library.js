(function(module) {
	"use strict";

	var async = require('async'),
		fs = require('fs'),
		path = require('path'),
		db = module.parent.require('./database'),
		categories = module.parent.require('./categories'),
		user = module.parent.require('./user'),
		plugins = module.parent.require('./plugins'),
		topics = module.parent.require('./topics'),
		posts = module.parent.require('./posts'),
		groups = module.parent.require('./groups'),
		translator = module.parent.require('../public/src/translator'),
		templates = module.parent.require('templates.js'),
		websockets = module.parent.require('./socket.io'),
		app;

		var SocketPlugins = module.parent.require('./socket.io/plugins');


	var Widget = {
		templates: {}
	};

	Widget.categories = [];
	Widget.loadedCategories = [];

	Widget.init = function(params, callback) {
		app = params.app;

		var templatesToLoad = [
			"widgets/activeusers.tpl", "widgets/moderators.tpl",
			"widgets/categories.tpl", "widgets/populartags.tpl",
			"widgets/populartopics.tpl", "widgets/groups.tpl",
			"admin/categorywidget.tpl", "admin/forumstats.tpl", "admin/html.tpl", "admin/text.tpl", "admin/recentposts.tpl",
			"admin/recenttopics.tpl", "admin/defaultwidget.tpl", "admin/categorieswidget.tpl", "admin/populartags.tpl",
			"admin/populartopics.tpl", "admin/mygroups.tpl",
			"admin/recenttagstopics.tpl",
			"admin/recentcategorytopics.tpl",
			"widgets/categoriesfilter.tpl",
			"admin/categoriesfilter.tpl"
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

		// Create Helpers!
		templates.registerHelper('specialTags', function(data) {
			//var tag = data.value.toLowerCase();
			//console.log(data.topics.length);
			for(var i=0;data.topics && i<data.topics.length;i++)
			{	//console.log(data.topics[i].category);
				if( JSON.stringify(data.topics[i].tags).toLowerCase().indexOf("temaserio") < 0 )
				{	// Si no esta la etiqueta que quiero lo elimino del array, y ya no lo muestra
					data.topics.splice(i, 1); i--; // Luego sumare, asi cuando el siguiente se vaya hacia atras, no lo salto
				}
			}
			return true;
		});

		templates.registerHelper('specialCategory', function(data) {
			// Para mostrar solo topics en una categoria concreta
			//console.log(data.topics);
			for(var i=0;data.topics && i<data.topics.length;i++)
			{	console.log(data.topics[i].category);
				if( data.topics[i].category.cid != 1 )
				{	// Si no esta la categoria (id categoria) que quiero lo elimino del array, y ya no lo muestra
					data.topics.splice(i, 1); i--; // Luego sumare, asi cuando el siguiente se vaya hacia atras, no lo salto
				}
			}
			return true;
		});

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

		var html = Widget.templates['widgets/activeusers.tpl'], cidOrtid;
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
		var html = Widget.templates['widgets/moderators.tpl'], cid;

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
		async.parallel({
			global: function(next) {
				db.getObjectFields('global', ['topicCount', 'postCount', 'userCount'], next);
			},
			onlineCount: function(next) {
				var now = Date.now();
				db.sortedSetCount('users:online', now - 300000, now, next);
			}
		}, function(err, results) {
			if (err) {
				return callback(err);
			}

			var stats = {
				topics: results.global.topicCount ? results.global.topicCount : 0,
				posts: results.global.postCount ? results.global.postCount : 0,
				users: results.global.userCount ? results.global.userCount : 0,
				online: results.onlineCount + websockets.getOnlineAnonCount(),
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
			app.render('widgets/recentposts', {posts: posts, numPosts: numPosts, cid: cid}, function(err, html) {
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
			posts.getRecentPosts(widget.uid, 0, Math.max(0, numPosts - 1), widget.data.duration || 'day', done);
		}
	};
	
	Widget.renderRecentTopicsWidget = function(widget, callback) {
		var numTopics = (widget.data.numTopics || 8) - 1;
		console.log(widget);

		topics.getTopicsFromSet('topics:recent', widget.uid, 0, Math.max(0, numTopics), function(err, data) {
			if (err) {
				return callback(err);
			}

			app.render('widgets/recenttopics', {topics: data.topics, numTopics: numTopics}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};
	

	Widget.renderCategories = function(widget, callback) {
		var html = Widget.templates['widgets/categories.tpl'];

		categories.getCategoriesByPrivilege(widget.uid, 'find', function(err, data) {
			html = templates.parse(html, {categories: data});

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

			html = templates.parse(html, {tags: tags});

			callback(err, html);
		});
	};

	Widget.renderPopularTopics = function(widget, callback) {
		var numTopics = widget.data.numTopics || 8;
		topics.getPopular(widget.data.duration || 'alltime', widget.uid, numTopics, function(err, topics) {
			if (err) {
				return callback(err);
			}

			app.render('widgets/populartopics', {topics: topics, numTopics: numTopics}, function(err, html) {
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
			app.render('widgets/groups', {groups: userGroupData}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderNewGroups = function(widget, callback) {
		groups.getGroups(0, 19, function(err, groupNames) {
			if (err) {
				return callback(err);
			}

			async.map(groupNames, function (groupName, next) {
				groups.get(groupName, {}, next);
			}, function (err, groups) {
				if (err) {
					return callback(err);
				}

				var numGroups = parseInt(widget.data.numGroups, 10) || 8;
				groups = groups.filter(function(group) {
					return group && !group.hidden;
				}).slice(0, numGroups);

				app.render('widgets/groups', {groups: groups}, function(err, html) {
					translator.translate(html, function(translatedHTML) {
						callback(err, translatedHTML);
					});
				});
			});
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
				widget: "recentreplies",
				name: "Recent Replies[deprecated]",
				description: "List of recent replies in a category.",
				content: Widget.templates['admin/categorywidget.tpl']
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
			// Mis widgets
			{
				widget: "recenttagstopics",
				name:"Recent Tags Topics",
				description: "Muestra topics con la etiqueta indicada",
				content: Widget.templates['admin/recenttagstopics.tpl']
			},
			{
				widget: "recentcategorytopics",
				name:"Recent Category Topics",
				description: "Muestra topics con la categoria indicada",
				content: Widget.templates['admin/recentcategorytopics.tpl']
			},
			{
				widget: "categoriesfilter",
				name:"Categories Filter",
				description: "Muestra las categorias indicadas",
				content: Widget.templates['admin/categoriesfilter.tpl']
			}
		]);

		callback(null, widgets);
	};


	Widget.renderRecentTagsTopicsWidget = function(widget, callback) {
		var numTopics = widget.data.numTopics || 10;
		var tag = widget.data.tag || "temaserio";
		//console.log(widget);

		topics.getTopicsFromSet("tag:"+tag+":topics", widget.uid, 0, numTopics, function(err, tp) {
			if (err) {
				return callback(err);
			}

			app.render('widgets/recenttopics', {topics: tp.topics, numTopics: numTopics}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};

	Widget.renderRecentCategoryTopicsWidget = function(widget, callback) {
		var numTopics = widget.data.numTopics || 10;
		var cid = widget.data.cid || "1";
		//console.log(widget);

		topics.getTopicsFromSet("cid:"+cid+":tids", widget.uid, 0, numTopics, function(err, tp) {
			if (err) {
				return callback(err);
			}

			app.render('widgets/recenttopics', {topics: tp.topics, numTopics: numTopics}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		});
	};


	Widget.renderCategoriesFilter = function(widget, callback) {
		console.log(widget);
		var cids = widget.data.cid || "1,2";

		categories.getAllCategories(widget.uid, function(err, cat) {
			if (err) {
				return callback(err);
			}

			//console.log(cat);
			for(var i=0;i<cat.length;i++)
			{	// Eliminamos las categorias que no esten entre las seleccionadas
				if( cids.indexOf(cat[i].cid) < 0 )
				{
					cat.splice(i, 1); i--;
				}
			}

			Widget.categoriesPostsLoop(0, cat, [], widget, callback);
		});
	};

	
	Widget.categoriesPostsLoop = function(i, cats, loadedCategories, widget, callback)
	{	// Recorremos las categorias para ir cargando los posts recientes
		if( loadedCategories.length < cats.length )
		{	//console.log("Loading: "+cats[i].cid);
			categories.getRecentReplies(cats[i].cid, widget.uid, 1, function(err, dat){
				//console.log(dat);
				cats[i].posts = dat; // Meto el post reciente
				i++;
				loadedCategories.push(i);
				Widget.categoriesPostsLoop(i, cats, loadedCategories, widget, callback);
			});
		}
		else
		{	// Todas las categorias cargadas! Puedo renderizar
			app.render('widgets/categoriesfilter', {categories: cats}, function(err, html) {
				translator.translate(html, function(translatedHTML) {
					callback(err, translatedHTML);
				});
			});
		}
	}
	


	module.exports = Widget;
}(module));