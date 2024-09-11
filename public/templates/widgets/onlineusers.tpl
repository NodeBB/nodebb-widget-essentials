<div class="d-flex flex-wrap gap-1 mb-2">
	{{{ each online_users }}}
	<a href="{config.relative_path}/user/{./userslug}" class="btn btn-ghost d-flex gap-2 ff-secondary align-items-start text-start p-2 ff-base flex-grow-1">
		{buildAvatar(@value, "48px", true, "flex-shrink-0")}
		<div class="d-flex flex-column gap-1 text-truncate">
			<div class="fw-semibold text-truncate" title="{./displayname}">{./displayname}</div>
			<div class="text-xs text-muted text-truncate">
				<span class="timeago" title="{./lastonlineISO}"></span>
			</div>
		</div>
	</a>
	{{{ end }}}
</div>
