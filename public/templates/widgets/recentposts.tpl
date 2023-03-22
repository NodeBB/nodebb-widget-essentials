<div class="overflow-hidden">
	<ul id="recent_posts" class="list-unstyled d-flex flex-column" data-numposts="{numPosts}" data-cid="{cid}">
	<!-- IMPORT widgets/partials/posts.tpl -->
	</ul>
</div>

<script>
'use strict';
/* globals app, socket*/
(function() {
	function onLoad() {
		var replies = $('#recent_posts');

		var recentPostsWidget = app.widgets.recentPosts;
		var numPosts = parseInt(replies.attr('data-numposts'), 10) || 4;

		if (!recentPostsWidget) {
			recentPostsWidget = {};
			recentPostsWidget.onNewPost = function(data) {
				var cid = replies.attr('data-cid');
				var recentPosts = $('#recent_posts');
				if (!recentPosts.length) {
					return;
				}

				if (cid && parseInt(cid, 10) !== parseInt(data.posts[0].topic.cid, 10)) {
					return;
				}

				app.parseAndTranslate('widgets/partials/posts', {
					relative_path: config.relative_path,
					posts: data.posts
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
