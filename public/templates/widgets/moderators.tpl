<div class="moderators">
	<!-- BEGIN moderators -->
	<a data-uid="{moderators.uid}" href="{relative_path}/user/{moderators.userslug}">
		<!-- IF moderators.picture -->
		<img title="{moderators.username}" src="{moderators.picture}" class="avatar avatar-sm not-responsive" />
		<!-- ELSE -->
		<div title="{moderators.username}" class="avatar avatar-sm not-responsive" style="background-color: {moderators.icon:bgColor};">{moderators.icon:text}</div>
		<!-- ENDIF moderators.picture -->
	</a>
	<!-- END moderators -->
</div>