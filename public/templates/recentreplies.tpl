<div class="recent-replies">
	<ul id="category_recent_replies">
		<!-- BEGIN posts -->
		<li data-pid="{posts.pid}" class="clearfix">
			<a href="{relative_path}/user/{posts.userslug}">
				<img title="{posts.username}" class="img-rounded user-img" src="{posts.picture}" />
			</a>
			<strong><span>{posts.username}</span></strong>
			<p>{posts.content}</p>
			<span class="pull-right">
				<a href="{relative_path}/topic/{posts.topicSlug}#{posts.pid}">[[category:posted]]</a>
				<span class="timeago" title="{posts.relativeTime}"></span>
			</span>
		</li>
		<!-- END posts -->
	</ul>
</div>

<script>
var cid = templates.get('category_id');

function renderRecentReplies(err, posts) {
	if (err || !posts || posts.length === 0) {
		return;
	}

	var recentReplies = $('#category_recent_replies');

	templates.preload_template('recentreplies', function() {

		templates['recentreplies'].parse({posts:[]});

		var html = templates.prepare(templates['recentreplies'].blocks['posts']).parse({
			posts: posts
		});

		translator.translate(html, function(translatedHTML) {
			translatedHTML = $(translatedHTML);
			translatedHTML.find('img').addClass('img-responsive');

			recentReplies.html(translatedHTML);

			$('#category_recent_replies span.timeago').timeago();
			app.createUserTooltips();
		});
	});
}
socket.emit('categories.getRecentReplies', cid, renderRecentReplies);
socket.on('event:new_topic', cid, renderRecentReplies);
</script>