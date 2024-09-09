<div class="d-flex flex-column gap-1 mb-2">
	{{{ each moderators }}}
	<a href="{config.relative_path}/user/{./userslug}" class="btn-ghost ff-secondary align-items-start justify-content-start p-2 ff-base flex-grow-1">
		{buildAvatar(@value, "48px", true, "flex-shrink-0")}
		<div class="d-flex flex-column text-truncate">
			<div class="fw-semibold text-truncate" title="{./displayname}">{./displayname}</div>
			<div class="text-xs text-muted text-truncate">@{./username}</div>
		</div>
	</a>
	{{{ end }}}
</div>
