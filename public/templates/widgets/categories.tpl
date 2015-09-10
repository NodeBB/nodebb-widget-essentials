<!-- BEGIN categories -->
<ul class="categories-list">
	<li>
		<!-- IF !categories.link -->
		<h4><a href="{relative_path}/category/{categories.slug}">{categories.name}</a></h4>
		<!-- ELSE -->
		<h4><a href="{categories.link}">{categories.name}</a></h4>
		<!-- ENDIF !categories.link -->
		<p>{categories.descriptionParsed}</p>
	</li>
</ul>
<!-- END categories -->