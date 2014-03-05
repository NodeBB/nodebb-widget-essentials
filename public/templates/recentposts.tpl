<div class="recent-replies">
	<ul id="recent_posts">

		<!-- BEGIN posts -->
		<li data-pid="{posts.pid}" class="clearfix">
			<a href="{relative_path}/user/{posts.userslug}">
				<img title="{posts.username}" class="img-rounded user-img" src="{posts.picture}" />
			</a>
			<strong><span>{posts.username}</span></strong>
			<p>{posts.content}</p>
			<span class="pull-right">
				<a href="{relative_path}/topic/{posts.topic.slug}#{posts.pid}">[[category:posted]]</a>
				<span class="timeago" title="{posts.relativeTime}"></span>
			</span>
		</li>
		<!-- END posts -->

	</ul>
</div>

<script>
$.get(RELATIVE_PATH + '/api/recent/posts/{duration}', {}, function(posts) {
	var recentPosts = $('#recent_posts');

	if (!posts || !posts.length) {
		recentPosts.html('No posts have been posted in the past {duration}.');
		return;
	}
	var numPosts = parseInt('{numPosts}', 10);
	numPosts = numPosts || 8;

	posts = posts.slice(0, numPosts);
	templates.preload_template('recentposts', function() {

		templates['recentposts'].parse({posts:[]});

		var html = templates.prepare(templates['recentposts'].blocks['posts']).parse({
			posts: posts
		});


		translator.translate(html, function(translatedHTML) {
			translatedHTML = $(translatedHTML);
			translatedHTML.find('img').addClass('img-responsive');

			recentPosts.html(translatedHTML);

			translatedHTML.find('span.timeago').timeago();
			app.createUserTooltips();
		});
	});
});
</script>
