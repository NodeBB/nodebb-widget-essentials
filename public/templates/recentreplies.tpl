<div class="recent-replies">
	<ul id="category_recent_replies">
		<!-- BEGIN posts -->
		<li data-pid="{posts.pid}" class="clearfix">
			<a href="{relative_path}/user/{posts.user.userslug}">
				<img title="{posts.user.username}" class="img-rounded user-img" src="{posts.user.picture}" />
			</a>
			<strong><span>{posts.user.username}</span></strong>
			<div>
				{posts.content}
			</div>
			<span class="pull-right">
				[[global:posted_ago, {posts.relativeTime}]] &bull;
				<a href="{relative_path}/topic/{posts.topic.slug}#{posts.pid}">[[global:read_more]] <i class="fa fa-chevron-circle-right"></i></a>
			</span>
		</li>
		<!-- END posts -->
	</ul>
</div>

<script>
(function() {
	var cid = {cid} || ajaxify.variables.get('category_id') || 1;

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
		ajaxify.loadTemplate('recentreplies', function(recentrepliesTemplate) {
			var html = templates.parse(templates.getBlock(recentrepliesTemplate, 'posts'), {
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