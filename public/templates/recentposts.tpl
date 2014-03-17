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
		});
	});

	function parseAndTranslate(posts, callback) {
		var html = '';

		for (var i = 0, numPosts = posts.length; i < numPosts; ++i) {

			html += '<li data-pid="'+ posts[i].pid +'" class="clearfix">' +
						'<a href="' + RELATIVE_PATH + '/user/' + posts[i].user.userslug + '"><img title="' + posts[i].user.username + '" class="img-rounded user-img" src="' + posts[i].user.picture + '"/></a>' +
						'<strong><span>'+ posts[i].user.username + '</span></strong>' +
						'<div>' + posts[i].content + '</div>' +
						'<span class="pull-right">'+
							'<a href="' + RELATIVE_PATH + '/topic/' + posts[i].tid + '#' + posts[i].pid +'">[[category:posted]]</a> ' +
							'<span class="timeago" title="' + posts[i].relativeTime+'"></span>'+
						'</span>'+
						'</li>';
		}

		translator.translate(html, function(translatedHTML) {
			translatedHTML = $(translatedHTML);
			translatedHTML.find('img').addClass('img-responsive');
			translatedHTML.find('span.timeago').timeago();
			callback(translatedHTML);
		});
	}
}());
</script>
