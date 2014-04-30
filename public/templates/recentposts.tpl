<div class="recent-replies">
	<ul id="recent_posts">

	</ul>
</div>

<script>
(function() {

	var recentPostsWidget = app.widgets.recentPosts;
	var numPosts = parseInt('{numPosts}', 10);
		numPosts = numPosts || 8;

	if (!recentPostsWidget) {
		recentPostsWidget = {};
		recentPostsWidget.onNewPost = function(data) {

			var recentPosts = $('#recent_posts');
			if (!recentPosts.length) {
				return;
			}

			parseAndTranslate(data.posts, function(html) {
				html.hide()
					.prependTo(recentPosts)
					.fadeIn();

				app.createUserTooltips();
				if (recentPosts.children().length > numPosts) {
					recentPosts.children().last().remove();
				}
			});
		}

		app.widgets.recentPosts = recentPostsWidget;
		socket.on('event:new_post', app.widgets.recentPosts.onNewPost);
	}

	var data = {
		term: '{duration}',
		count: numPosts
	};

	socket.emit('posts.getRecentPosts', data, function(err, posts) {
		var recentPosts = $('#recent_posts');

		if (!posts || !posts.length) {
			recentPosts.html('No posts have been posted in the past {duration}.');
			return;
		}

		posts = posts.slice(0, numPosts);
		parseAndTranslate(posts, function(html) {
			recentPosts.html(html);

			app.createUserTooltips();
			app.replaceSelfLinks(html.find('a'));
		});
	});

	function parseAndTranslate(posts, callback) {
		ajaxify.loadTemplate('partials/posts', function(postsTemplate) {
			var html = templates.parse(templates.getBlock(postsTemplate, 'posts'), {
				posts: posts
			});

			translator.translate(html, function(translatedHTML) {
				translatedHTML = $(translatedHTML);
				translatedHTML.find('img').addClass('img-responsive');
				translatedHTML.find('span.timeago').timeago();
				callback(translatedHTML);
			});
		});
	}
}());
</script>
