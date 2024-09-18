<div class="{{{ if sidebar }}}row row-cols-1 px-3{{{ else }}}row row-cols-2 row-cols-md-3 row-cols-lg-4 row-cols-xl-5 g-4{{{ end }}} mb-2">s
	{{{ each users }}}
	<a href="{config.relative_path}/user/{./userslug}" class="btn btn-ghost d-flex gap-2 ff-secondary align-items-start text-start p-2 ff-base">
		{buildAvatar(@value, "48px", true, "flex-shrink-0")}
		<div class="d-flex flex-column gap-1 text-truncate">
			<div class="fw-semibold text-truncate" title="{./displayname}">{./displayname}</div>
			<div class="text-xs text-muted text-truncate">
				<span class="timeago" title="{./joindateISO}"></span>
			</div>
		</div>
	</a>
	{{{ end }}}
</div>