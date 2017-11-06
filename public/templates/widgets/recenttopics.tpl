<div class="recent-replies">
	<ul id="recent_topics" data-numtopics="{numTopics}">
	<!-- IMPORT partials/topics_teaser.tpl -->
	</ul>
</div>

<script>
'use strict';
/* globals app, socket, translator, templates, utils*/
(function() {
	function onLoad() {
		var	topics = $('#recent_topics');

		app.createUserTooltips();
		processHtml(topics);

		var recentTopicsWidget = app.widgets.recentTopics;

		var numTopics = parseInt(topics.attr('data-numtopics'), 10) || 8;

		if (!recentTopicsWidget) {
			recentTopicsWidget = {};
			recentTopicsWidget.onNewTopic = function(topic) {

				var recentTopics = $('#recent_topics');
				if (!recentTopics.length) {
					return;
				}

				app.parseAndTranslate('partials/topics', { topics: [topic] }, function(html) {
					processHtml(html);

					html.hide()
						.prependTo(recentTopics)
						.fadeIn();

					app.createUserTooltips();
					if (recentTopics.children().length > numTopics) {
						recentTopics.children().last().remove();
					}
				});
			};

			app.widgets.recentTopics = recentTopicsWidget;
			socket.on('event:new_topic', app.widgets.recentTopics.onNewTopic);
		}

		function processHtml(html) {
			html.find('span.timeago').timeago();
		}
	}

	if (window.hasOwnProperty('$')) {
		onLoad();
	} else {
		window.addEventListener('load', onLoad);
	}
})();
</script>
