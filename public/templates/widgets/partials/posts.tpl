{{{ each posts }}}
<li data-pid="{posts.pid}" class="clearfix widget-posts">
	<a class="float-start me-2" href="{{{ if posts.user.userslug }}}{relative_path}/user/{posts.user.userslug}{{{ else }}}#{{{ end }}}">
		{buildAvatar(posts.user, "24px", true, "not-responsive")}
	</a>
	<div class="p-1">
		{posts.content}
		<p class="fade-out"></p>
	</div>
	<span class="float-end post-preview-footer fs-6">
		<span class="timeago" title="{posts.timestampISO}"></span> &bull;
		<a href="{relative_path}/post/{posts.pid}">[[global:read_more]]</a>
	</span>
</li>
{{{ end }}}