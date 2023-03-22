<div class="overflow-hidden">
	<ul id="recent_topics" class="list-unstyled d-flex flex-column gap-3" data-numtopics="{numTopics}">
	<!-- IMPORT widgets/partials/topics_teaser.tpl -->
	</ul>
</div>

<script>
'use strict';
/* globals app, socket*/
(function() {
	function onLoad() {
		var	topics = $('#recent_topics');

		var recentTopicsWidget = app.widgets.recentTopics;

		var numTopics = parseInt(topics.attr('data-numtopics'), 10) || 8;

		if (!recentTopicsWidget) {
			recentTopicsWidget = {};
			recentTopicsWidget.onNewTopic = function(topic) {
				var recentTopics = $('#recent_topics');
				if (!recentTopics.length) {
					return;
				}

				app.parseAndTranslate('widgets/partials/topics', { topics: [topic] }, function(html) {
					processHtml(html);

					html.hide()
						.prependTo(recentTopics)
						.fadeIn();

					if (recentTopics.children().length > numTopics) {
						recentTopics.children().last().remove();
					}
				});
			};

			app.widgets.recentTopics = recentTopicsWidget;
			socket.on('event:new_topic', app.widgets.recentTopics.onNewTopic);
		}

		function processHtml(html) {
			if ($.timeago) {
				html.find('span.timeago').timeago();
			}
		}
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', onLoad);
	} else {
		onLoad();
	}
})();
</script>
