<div class="d-flex flex-wrap gap-1 mb-2">
	{{{ each users }}}
	<a href="{config.relative_path}/user/{./userslug}" class="btn-ghost ff-secondary align-items-start justify-content-start p-2 ff-base flex-grow-1">
		{buildAvatar(@value, "48px", true, "flex-shrink-0")}
		<div class="d-flex flex-column text-truncate">
			<div class="fw-semibold text-truncate" title="{./displayname}">{./displayname}</div>
			<div class="text-xs text-muted text-truncate">
				<span class="timeago" title="{./joindateISO}"></span>
			</div>
		</div>
	</a>
	{{{ end }}}
</div>