{{{ each categories}}}
<ul class="categories-list list-unstyled">
	<li component="categories/category" data-cid="{./cid}" data-parent-cid="{../parentCid}" class="category-{./cid}">
		<div class="content d-flex gap-2">
			<div>
				{buildCategoryIcon(@value, "24px", "rounded-1")}
			</div>
			<div class="flex-grow-1 align-items-start d-flex flex-column gap-2">
				<div class="d-grid gap-0">
					<div class="title fw-semibold">
						<!-- IMPORT partials/categories/link.tpl -->
					</div>
					{{{ if ./descriptionParsed }}}
					<div class="description text-muted text-xs w-100">{./descriptionParsed}</div>
					{{{ end }}}
				</div>
				{{{ if !config.hideSubCategories }}}
				{{{ if ./children.length }}}
				<div class="category-children row row-cols-1 g-2 w-100">
					{{{ each ./children }}}
					{{{ if !./isSection }}}
					<span class="category-children-item small">
						<div class="d-flex align-items-center gap-1">
							<i class="fa fa-fw fa-caret-right text-primary"></i>
							<a href="{{{ if ./link }}}{./link}{{{ else }}}{config.relative_path}/category/{./slug}{{{ end }}}" class="text-reset fw-semibold">{./name}</a>
						</div>
					</span>
					{{{ end }}}
					{{{ end }}}
				</div>
				{{{ end }}}
				{{{ end }}}
			</div>
		</div>
		<hr />
	</li>
</ul>
{{{ end }}}



