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
		for (var i = 0; i < topics.length; ++i) {
			topics[i].isoTimestamp = utils.toISOString(topics[i].timestamp);
		}

		ajaxify.loadTemplate('partials/topics', function(topicsTemplate) {
			var html = templates.parse(templates.getBlock(topicsTemplate, 'topics'), {
				topics: topics
			});


			translator.translate(html, function(translatedHtml) {
				translatedHtml = $(translatedHtml);
				translatedHtml.find('span.timeago').timeago();
				callback(translatedHtml);
			});
		});
	}

}());
</script>
