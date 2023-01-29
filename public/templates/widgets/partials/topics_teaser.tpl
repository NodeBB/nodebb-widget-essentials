{{{ each topics }}}
<li class="widget-topics">
	<div class="d-flex gap-1">
		<a class="text-decoration-none" href="{{{ if ./user.userslug }}}{relative_path}/user/{./user.userslug}{{{ else }}}#{{{ end }}}">
			{buildAvatar(./teaser.user, "24px", true, "avatar-tooltip not-responsive")}
		</a>
		<div class="px-1 text-truncate">
			<a href="{relative_path}/topic/{./slug}">{./title}</a>
		</div>
	</div>
	<div class="text-end text-xs post-preview-footer fs-6">
		<span class="timeago" title="{./lastposttimeISO}"></span>
	</div>
</li>
{{{ end }}}
