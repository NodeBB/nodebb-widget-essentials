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

	socket.emit('topics.loadTopics', {start:0, end: numTopics - 1, set:'topics:tid'}, function(err, data) {
		if (err) {
			return app.alertError(err.message);
		}

		var recentTopics = $('#recent_topics');

		if(!data || !data.topics || !data.topics.length) {
			translator.translate('[[topic:no_topics_found]]', function(translated) {
				recentTopics.html(translated);
			});
			return;
		}

		parseAndTranslate(data.topics, function(html) {
			recentTopics.html(html);

			app.createUserTooltips();
		});
	});

	function parseAndTranslate(topics, callback) {
		var replies = '';

		for (var i = 0, numPosts = topics.length; i < numPosts; ++i) {
			var lastPostIsoTime = utils.toISOString(topics[i].timestamp);

			// this would be better as a template, I copied this from Lavender.
			replies += '<li class="clearfix">' +
						'<a href="' + RELATIVE_PATH + '/user/' + topics[i].user.userslug + '"><img title="' + topics[i].user.username + '" class="img-rounded user-img" src="' + topics[i].user.picture + '"/></a>' +
						'<p>' +
							'"<a href="' + RELATIVE_PATH + '/topic/' + topics[i].slug  + '" >' + topics[i].title + '</a>"' +
						'</p>' +

						'<span class="pull-right">'+
							'[[global:posted_ago, ' + lastPostIsoTime + ']] '+
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
