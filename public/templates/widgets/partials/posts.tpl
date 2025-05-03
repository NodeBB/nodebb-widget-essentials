{{{ each posts }}}
<li data-pid="{./pid}" class="widget-posts d-flex flex-column gap-1">
	<div class="d-flex gap-2 align-items-center text-sm">
		<a class="text-decoration-none avatar-tooltip" title="{./user.displayname}" href="{{{ if ./user.userslug }}}{relative_path}/user/{./user.userslug}{{{ else }}}#{{{ end }}}">
			{buildAvatar(./user, "24px", true)}
		</a>

		<div class="post-author d-flex align-items-center gap-1">
			<a class="lh-1 fw-semibold" href="{config.relative_path}/user/{./user.userslug}">{../user.displayname}</a>
		</div>
		<span class="timeago text-muted lh-1" title="{./timestampISO}"></span>
	</div>
	<div class="line-clamp-6 text-sm text-break">
		{./content}
	</div>

	<div class="text-end text-xs post-preview-footer">
		<a href="{relative_path}/post/{encodeURIComponent(./pid)}">[[global:read-more]]</a>
	</div>
	{{{ if !@last}}}
	<hr/>
	{{{ end }}}
</li>
{{{ end }}}