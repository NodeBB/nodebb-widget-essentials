<div class="recent-replies">
	<ul id="category_recent_replies">
		<!-- BEGIN posts -->
		<li data-pid="{posts.pid}" class="clearfix">
			<a href="{relative_path}/user/{posts.userslug}">
				<img title="{posts.username}" class="img-rounded user-img" src="{posts.picture}" />
			</a>
			<strong><span>{posts.username}</span></strong>
			<div>
				{posts.content}
			</div>
			<span class="pull-right">
				<a href="{relative_path}/topic/{posts.topic.slug}#{posts.pid}">[[category:posted]]</a>
				<span class="timeago" title="{posts.relativeTime}"></span>
			</span>
		</li>
		<!-- END posts -->
	</ul>
</div>

<script>
(function() {
	var cid = {cid} || templates.get('category_id') || 1;

	function renderRecentReplies(err, posts) {
		if (err || !posts || posts.length === 0) {
			return;
		}

		parseAndTranslate(posts, function(html) {
			$('#category_recent_replies').html(html);
			app.createUserTooltips();
		});
	}

	function parseAndTranslate(posts, callback) {
		templates.preload_template('recentreplies', function() {

			templates['recentreplies'].parse({posts:[]});

			var html = templates.prepare(templates['recentreplies'].blocks['posts']).parse({
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

	socket.emit('categories.getRecentReplies', cid, renderRecentReplies);
}());
</script>