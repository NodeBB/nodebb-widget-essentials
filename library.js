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

		callback(null, {
			title: "HTML",
			html: html
		});
	};

	Widget.renderTextWidget = function(widget, callback) {
		var markdown = !!widget.data.markdown,
			text = widget.data.text;

		if (markdown) {
			text = marked(text);
		} else {
			text = text.replace(/\r\n/g, "<br />");
		}

		callback(null, {
			title: "Text",
			html: text
		});
	};

	Widget.renderForumStatsWidget = function(widget, callback) {
		var html = Widget.templates['forumstats.tpl'];

		translator.translate(html, function(translatedHTML) {
			callback(null, {
				title: widget.data.title || "Forum Stats",
				html: translatedHTML
			});
		});
	};

	Widget.renderRecentRepliesWidget = function(widget, callback) {
		var html = Widget.templates['recentreplies.tpl'];

		html = templates.prepare(html).parse({cid: widget.data.cid || false});

		callback(null, {
			title: widget.data.title || "Recent Replies",
			html: html
		});
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

				callback(err, {
					title: widget.data.title || "Active Participants",
					html: html
				});
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

			callback(err, {
				title: widget.data.title || "Moderators",
				html: html
			});
		});
	};

	Widget.defineWidgets = function(widgets, callback) {
		// todo: move content into template files

		widgets = widgets.concat([
			{
				widget: "html",
				name: "HTML",
				description: "Any text, html, or embedded script.",
				content: "<textarea class=\"form-control\" rows=\"6\" name=\"html\" placeholder=\"Enter HTML\"></textarea>"
			},
			{
				widget: "text",
				name: "Text",
				description: "Markdown formatted text.",
				content: "<textarea class=\"form-control\" rows=\"6\" name=\"text\" placeholder=\"Enter Text / Markdown\"></textarea>"
							+ "<hr />"
							+ "<div class=\"checkbox\">"
							+ 	"<label><input type=\"checkbox\" name=\"markdown\" checked /> Parse as Markdown?</label>"
							+ "</div>"
			},
			{
				widget: "recentreplies",
				name: "Recent Replies",
				description: "List of recent replies in a category.",
				content: "<label>Custom Category:<br /><small>Leave blank to to dynamically pull from current category</small></label><input type=\"text\" class=\"form-control\" name=\"cid\" placeholder=\"0\" /><br /><label>Custom Title:</label><input type=\"text\" class=\"form-control\" name=\"title\" placeholder=\"Recent Replies\" />"
			},
			{
				widget: "activeusers",
				name: "Active Users",
				description: "List of active users in a category.",
				content: "<label>Custom Category:<br /><small>Leave blank to to dynamically pull from current category</small></label><input type=\"text\" class=\"form-control\" name=\"cid\" placeholder=\"0\" /><br /><label>Custom Title:</label><input type=\"text\" class=\"form-control\" name=\"title\" placeholder=\"Active Users\" />"
			},
			{
				widget: "moderators",
				name: "Moderators",
				description: "List of moderators in a category.",
				content: "<label>Custom Category:<br /><small>Leave blank to to dynamically pull from current category</small></label><input type=\"text\" class=\"form-control\" name=\"cid\" placeholder=\"0\" /><br /><label>Custom Title:</label><input type=\"text\" class=\"form-control\" name=\"title\" placeholder=\"Moderators\" />"
			},
			{
				widget: "forumstats",
				name: "Forum Stats",
				description: "Lists user, topics, and post count information.",
				content: "<label>Custom Title:</label><input type=\"text\" class=\"form-control\" name=\"title\" placeholder=\"Forum Stats\" />"
			}
		]);

		callback(null, widgets);
	};


	Widget.addRoutes = function(custom_routes, callback) {
		var templatesToLoad = ["recentreplies.tpl", "activeusers.tpl", "moderators.tpl", "forumstats.tpl"];

		function loadTemplate(template, next) {
			fs.readFile(path.resolve(__dirname, './public/templates/' + template), function (err, data) {
				Widget.templates[template] = data.toString();
				next(err);
			});
		}

		async.each(templatesToLoad, loadTemplate, function(err) {
			if (err) {
				throw new Error("Error loading templates: "  + err);
			}

			custom_routes.templates = custom_routes.templates.concat(
				[
					{
						"template": "recentreplies.tpl",
						"content": Widget.templates['recentreplies.tpl']
					}
				]
			);

			callback(err, custom_routes);
		});
	};

	module.exports = Widget;
}(module));