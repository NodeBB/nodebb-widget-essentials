<div class="latest-users">
	{{{ each users }}}
	<a data-uid="{users.uid}" href="{relative_path}/user/{users.userslug}">
		{buildAvatar(users, "24px", true, "not-responsive")}
	</a>
	{{{ end }}}
</div>