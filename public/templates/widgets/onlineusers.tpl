<div class="active-users">
	{{{ each online_users }}}
	<a data-uid="{online_users.uid}" href="{relative_path}/user/{online_users.userslug}">
		{buildAvatar(online_users, "24px", true, "not-responsive")}
	</a>
	{{{ end }}}
</div>
