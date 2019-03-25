<div class="active-users">
	<!-- BEGIN online_users -->
	<a data-uid="{online_users.uid}" href="{relative_path}/user/{online_users.userslug}">
		<!-- IF online_users.picture -->
		<img title="{online_users.username}" src="{online_users.picture}" class="avatar avatar-sm avatar-rounded not-responsive" />
		<!-- ELSE -->
		<div title="{online_users.username}" class="avatar avatar-sm avatar-rounded not-responsive" style="background-color: {online_users.icon:bgColor};">{online_users.icon:text}</div>
		<!-- ENDIF online_users.picture -->
	</a>
	<!-- END online_users -->
</div>
