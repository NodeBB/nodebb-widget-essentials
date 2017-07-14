<div class="latest-users">
	<!-- BEGIN users -->
	<a data-uid="{users.uid}" href="{relative_path}/user/{users.userslug}">
		<!-- IF users.picture -->
		<img title="{users.username}" src="{users.picture}" class="avatar avatar-sm avatar-rounded not-responsive" />
		<!-- ELSE -->
		<div title="{users.username}" data-uid="{users.uid}" class="avatar avatar-sm avatar-rounded not-responsive" style="background-color: {users.icon:bgColor};">{users.icon:text}</div>
		<!-- ENDIF users.picture -->
	</a>
	<!-- END users -->
</div>