<div class="recent-replies">
	<ul id="category_recent_replies">

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
			app.replaceSelfLinks(html.find('a'));
		});
	}

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

	socket.emit('categories.getRecentReplies', cid, renderRecentReplies);
}());
</script>