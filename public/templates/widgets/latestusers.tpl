<div class="latest-users">
	<!-- BEGIN users -->
		<!-- IF users.picture -->
		<a data-uid="{users.uid}" href="{relative_path}/user/{users.userslug}"><img title="{users.username}" src="{users.picture}" class="user-icon profile-image user-img not-responsive" /></a>
		<!-- ELSE -->
		<div data-uid="{users.uid}" class="user-icon profile-image user-img not-responsive" style="background-color: {users.icon:bgColor};">{users.icon:text}</div>
		<!-- ENDIF users.picture -->

	
	<!-- END users -->
</div>