{{{ each topics }}}
<li class="widget-topics">
	<div class="d-flex flex-column gap-1">
		<a class="topic-title fw-semibold fs-6 mb-2 text-reset text-break d-block" href="{relative_path}/topic/{./slug}">{./title}</a>

		<div class="d-flex gap-2 align-items-center text-sm">
			<a class="text-decoration-none" href="{{{ if ./teaser.user.userslug }}}{relative_path}/user/{./teaser.user.userslug}{{{ else }}}#{{{ end }}}">
				{buildAvatar(./teaser.user, "24px", true, "avatar-tooltip not-responsive")}
			</a>

			<div class="post-author d-flex align-items-center gap-1">
				<a class="lh-1 fw-semibold" href="{config.relative_path}/user/{./teaser.user.userslug}">{./teaser.user.displayname}</a>
			</div>
			<span class="timeago text-muted lh-1" title="{./teaser.timestampISO}"></span>
		</div>
	</div>
	{{{ if !@last}}}
	<hr/>
	{{{ end }}}
</li>
{{{ end }}}
