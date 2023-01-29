{{{ each categories}}}
<ul class="categories-list list-unstyled">
	<li>
		<h4 class="mb-1">
		{{{ if !./link }}}
		<a href="{relative_path}/category/{categories.slug}">{./name}</a>
		{{{ else }}}
		<a href="{./link}">{./name}</a>
		{{{ end }}}
		</h4>
		{./descriptionParsed}
	</li>
</ul>
{{{ end }}}