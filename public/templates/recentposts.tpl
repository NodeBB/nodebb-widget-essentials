<div class="recent-replies">
	<ul id="recent_posts">

	</ul>
</div>

<script type="text/javascript">
$.get(RELATIVE_PATH + '/api/recent/{duration}', {}, function(posts) {
	var recentPosts = $('#recent_posts');

	if(!posts || !posts.topics || !posts.topics.length) {
		recentPosts.html('No topics have been posted in the past {duration}.');
		return;
	}

	posts = posts.topics.slice(0, 8);

	var replies = '';

	for (var i = 0, numPosts = posts.length; i < numPosts; ++i) {
		var lastPostIsoTime = utils.toISOString(posts[i].lastposttime);

		// this would be better as a template, I copied this from Lavender.
		replies += '<li data-pid="'+ posts[i].pid +'" class="clearfix">' +
					'<a href="' + RELATIVE_PATH + '/user/' + posts[i].teaser.userslug + '"><img title="' + posts[i].teaser.username + '" class="img-rounded user-img" src="' + posts[i].teaser.picture + '"/></a>' +
					'<p>' +
						'<strong><span>'+ posts[i].teaser.username + '</span></strong>' +
						'<span> [[global:posted]] [[global:in]] </span>' +
						'"<a href="' + RELATIVE_PATH + '/topic/' + posts[i].slug + '#' + posts[i].teaser.pid + '" >' + posts[i].title + '</a>"' +
					'</p>'+
					'<span class="pull-right">'+
						'<span class="timeago" title="' + lastPostIsoTime + '"></span>' +
					'</span>'+
					'</li>';
	}

	translator.translate(replies, function(translatedHtml) {
		recentPosts.html(translatedHtml);

		$('#recent_posts span.timeago').timeago();
		app.createUserTooltips();
	});
});
</script>
