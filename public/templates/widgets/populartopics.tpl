<div class="recent-replies">
	<ul class="popular_topics">
	<!-- IMPORT partials/topics.tpl -->
	</ul>
</div>

<script>
	'use strict';
	/* globals app*/
	(function() {
		function onLoad() {
			app.createUserTooltips();
			$('.popular_topics').find('span.timeago').timeago();
		}

		if (window.jQuery) {
			onLoad();
		} else {
			window.addEventListener('load', onLoad);
		}
	})();
</script>
