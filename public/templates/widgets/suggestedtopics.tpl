<div class="category">
	<!-- IMPORT partials/topics_list.tpl -->
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
