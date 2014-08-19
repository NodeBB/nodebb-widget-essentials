<!-- BEGIN categories -->
<ul class="categories-list">
	<li>
		<!-- IF !categories.link -->
		<h4><a href="{config.relative_path}/category/{categories.slug}">{categories.name}</a></h4>
		<p>{categories.description}</p>
		<!-- ELSE -->
		<h4><a href="{categories.link}">{categories.name}</a></h4>
		<!-- ENDIF !categories.link -->
	</li>
</ul>
<!-- END categories -->