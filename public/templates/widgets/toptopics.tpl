<div class="recent-replies">
	<ul class="top_topics">
	<!-- IMPORT partials/topics.tpl -->
	</ul>
</div>

<script>
	'use strict';
	/* globals app*/
	(function() {
		function onLoad() {
			app.createUserTooltips();
			$('.top_topics').find('span.timeago').timeago();
		}

		if (window.jQuery) {
			onLoad();
		} else {
			window.addEventListener('load', onLoad);
		}
	})();
</script>
