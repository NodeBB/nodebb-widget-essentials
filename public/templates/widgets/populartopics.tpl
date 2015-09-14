<div class="recent-replies">
	<ul class="popular_topics">
	<!-- IMPORT partials/topics.tpl -->
	</ul>
</div>

<script>
'use strict';
/* globals app*/

$(document).ready(function() {
	app.createUserTooltips();
	$('.popular_topics').find('span.timeago').timeago();
});
</script>
