{{{ each topics }}}
<li class="clearfix widget-topics">
	<a class="float-start me-2" href="{{{ if topics.user.userslug }}}{relative_path}/user/{topics.user.userslug}{{{ else }}}#{{{ end }}}">
		{buildAvatar(topics.teaser.user, "24px", true, "not-responsive")}
	</a>
	<div class="px-1">
		<a href="{relative_path}/topic/{topics.slug}">{topics.title}</a>
	</div>
	<span class="float-end post-preview-footer fs-6">
		<span class="timeago" title="{topics.lastposttimeISO}"></span>
	</span>
</li>
{{{ end }}}
