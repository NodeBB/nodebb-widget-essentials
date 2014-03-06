(function(module) {
	"use strict";

	var marked = require('marked'),
		async = require('async'),
		fs = require('fs'),
		path = require('path'),
		categories = require('../../src/categories'),
		user = require('../../src/user'),
		translator = require('../../public/src/translator'),
		templates = require('../../public/src/templates');


	var Widget = {
		templates: {}
	};

	Widget.renderHTMLWidget = function(widget, callback) {
		var html = widget.data.html;

		callback(null, html);
	};

	Widget.renderTextWidget = function(widget, callback) {
		var markdown = !!widget.data.markdown,
			text = widget.data.text;

		if (markdown) {
			text = marked(text);
		} else {
			text = text.replace(/\r\n/g, "<br />");
		}

		callback(null, text);
	};

	Widget.renderRecentRepliesWidget = function(widget, callback) {
		var html = Widget.templates['recentreplies.tpl'];

		html = templates.prepare(html).parse({cid: widget.data.cid || false});

		callback(null, html);
	};

	Widget.renderActiveUsersWidget = function(widget, callback) {
		var html = Widget.templates['activeusers.tpl'], cid;

		if (widget.data.cid) {
			cid = widget.data.cid;
		} else {
			var match = widget.area.url.match('[0-9]+');
			cid = match ? match[0] : 1;
		}

		categories.getActiveUsers(cid, function(err, uids) {
			user.getMultipleUserFields(uids, ['uid', 'username', 'userslug', 'picture'], function(err, users) {
				html = templates.prepare(html).parse({active_users: users});

				callback(err, html);
			});
		});
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
			html = templates.prepare(html).parse({moderators: moderators});

			callback(err, html);
		});
	};

	Widget.renderForumStatsWidget = function(widget, callback) {
		var html = Widget.templates['forumstats.tpl'];

		html = templates.prepare(html).parse({statsClass: widget.data.statsClass});

		translator.translate(html, function(translatedHTML) {
			callback(null, translatedHTML);
		});
	};

	Widget.renderRecentPostsWidget = function(widget, callback) {
		var html = Widget.templates['recentposts.tpl'];

		html = templates.prepare(html).parse({
			numPosts: widget.data.numPosts || 8,
			duration: widget.data.duration || 'day'
		});

		callback(null, html);
	};

	Widget.renderRecentTopicsWidget = function(widget, callback) {
		var html = Widget.templates['recenttopics.tpl'];

		html = templates.prepare(html).parse({
			numTopics: widget.data.numTopics || 8,
			duration: widget.data.duration || 'day'
		});

		callback(null, html);
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
				description: "Markdown formatted text.",
				content: Widget.templates['admin/text.tpl']
			},
			{
				widget: "recentreplies",
				name: "Recent Replies",
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
			}
		]);

		callback(null, widgets);
	};

	Widget.init = function() {
		var templatesToLoad = [
			"recentreplies.tpl", "activeusers.tpl", "moderators.tpl", "forumstats.tpl", "recentposts.tpl", "recenttopics.tpl",
			"admin/categorywidget.tpl", "admin/forumstats.tpl", "admin/html.tpl", "admin/text.tpl", "admin/recentposts.tpl", "admin/recenttopics.tpl"
		];

		function loadTemplate(template, next) {
			fs.readFile(path.resolve(__dirname, './public/templates/' + template), function (err, data) {
				Widget.templates[template] = data.toString();
				next(err);
			});
		}

		async.each(templatesToLoad, loadTemplate);
	};

	module.exports = Widget;
}(module));