<div class="recent-replies">
	<ul class="suggested-topics">
	<!-- IMPORT partials/topics.tpl -->
	</ul>
</div>

<script>
'use strict';
/* globals app*/

if (window.jQuery) {
	app.createUserTooltips();
} else {
	window.addEventListener('load', app.createUserTooltips);
}
</script>
