{{{ each posts }}}
<li data-pid="{./pid}" class="widget-posts d-flex flex-column gap-1">
	<div class="d-flex gap-1">
		<a class="text-decoration-none" href="{{{ if ./user.userslug }}}{relative_path}/user/{./user.userslug}{{{ else }}}#{{{ end }}}">
			{buildAvatar(./user, "24px", true, "avatar-tooltip not-responsive")}
		</a>
		<div class="line-clamp-6">
			{posts.content}
		</div>
	</div>
	<div class="text-end text-xs post-preview-footer fs-6">
		<span class="timeago" title="{posts.timestampISO}"></span> &bull;
		<a href="{relative_path}/post/{posts.pid}">[[global:read_more]]</a>
	</div>
	<hr/>
</li>

{{{ end }}}