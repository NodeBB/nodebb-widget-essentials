<div class="moderators">
	{{{ each moderators }}}
	<a data-uid="{moderators.uid}" href="{relative_path}/user/{moderators.userslug}">
		{buildAvatar(moderators, "24px", true, "not-responsive")}
	</a>
	{{{ end }}}
</div>