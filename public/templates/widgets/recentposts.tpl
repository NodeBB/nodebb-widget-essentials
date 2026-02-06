<div component="recent/posts/widget" data-uuid="{uuid}">
	<!-- IMPORT widgets/partials/posts.tpl -->
</div>

<script>
'use strict';
/* globals app, socket*/
(function() {
	function onLoad() {
		var recentPostsWidget = app.widgets.recentPosts;

		if (!recentPostsWidget) {
			recentPostsWidget = {};
			recentPostsWidget.onNewPost = function(data) {
				var recentPosts = $('[component="recent/posts/widget"][data-uuid="{uuid}"] ul.widget-posts-list');
				if (!recentPosts.length) {
					return;
				}
				var cid = recentPosts.attr('data-cid');
				var numPosts = parseInt(recentPosts.attr('data-numposts'), 10) || 4;

				if (cid && parseInt(cid, 10) !== parseInt(data.posts[0].topic.cid, 10)) {
					return;
				}

				app.parseAndTranslate('widgets/partials/posts', 'posts', {
					relative_path: config.relative_path,
					posts: data.posts,
				}, function(html) {
					processHtml(html);

					html.hide()
						.prependTo(recentPosts)
						.fadeIn();

					if (recentPosts.children().length > numPosts) {
						recentPosts.children().last().remove();
					}
				});
			};

			app.widgets.recentPosts = recentPostsWidget;
			socket.on('event:new_post', app.widgets.recentPosts.onNewPost);
		}

		function processHtml(html) {
			html.find('img:not(.not-responsive)').addClass('img-fluid');
			if ($.timeago) {
				html.find('span.timeago').timeago();
			}
		}
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', onLoad);
	} else {
		onLoad();
	}
})();
</script>
