<div class="recent-replies">
	<ul id="recent_topics">

	</ul>
</div>

<script>
(function() {

	var recentTopicsWidget = app.widgets.recentTopics;

	var numTopics = parseInt('{numTopics}', 10);
		numTopics = numTopics || 8;


	if (!recentTopicsWidget) {
		recentTopicsWidget = {};
		recentTopicsWidget.onNewTopic = function(topic) {

			var recentTopics = $('#recent_topics');
			if (!recentTopics.length) {
				return;
			}

			parseAndTranslate([topic], function(html) {
				html.hide()
					.prependTo(recentTopics)
					.fadeIn();

				app.createUserTooltips();
				if (recentTopics.children().length > numTopics) {
					recentTopics.children().last().remove();
				}
			});
		}

		app.widgets.recentTopics = recentTopicsWidget;
		socket.on('event:new_topic', app.widgets.recentTopics.onNewTopic);
	}

	$.get(RELATIVE_PATH + '/api/recent/{duration}', {}, function(posts) {
		var recentTopics = $('#recent_topics');

		if(!posts || !posts.topics || !posts.topics.length) {
			recentTopics.html('No topics have been posted in the past {duration}.');
			return;
		}

		posts = posts.topics.slice(0, numTopics);

		parseAndTranslate(posts, function(html) {
			recentTopics.html(html);

			app.createUserTooltips();
		});
	});

	function parseAndTranslate(topics, callback) {
		var replies = '';

		for (var i = 0, numPosts = topics.length; i < numPosts; ++i) {
			var lastPostIsoTime = utils.toISOString(topics[i].lastposttime);

			// this would be better as a template, I copied this from Lavender.
			replies += '<li data-pid="'+ topics[i].teaser.pid +'" class="clearfix">' +
						'<a href="' + RELATIVE_PATH + '/user/' + topics[i].teaser.userslug + '"><img title="' + topics[i].teaser.username + '" class="img-rounded user-img" src="' + topics[i].teaser.picture + '"/></a>' +
						'<p>' +
							'<strong><span>'+ topics[i].teaser.username + '</span></strong>' +
							'<span> [[global:posted]] [[global:in]] </span>' +
							'"<a href="' + RELATIVE_PATH + '/topic/' + topics[i].slug + '#' + topics[i].teaser.pid + '" >' + topics[i].title + '</a>"' +
						'</p>'+
						'<span class="pull-right">'+
							'<span class="timeago" title="' + lastPostIsoTime + '"></span>' +
						'</span>'+
						'</li>';
		}

		translator.translate(replies, function(translatedHtml) {
			translatedHtml = $(translatedHtml);
			translatedHtml.find('span.timeago').timeago();
			callback(translatedHtml);
		});
	}

}());
</script>
