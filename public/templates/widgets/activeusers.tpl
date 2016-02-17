<div class="active-users">
	<!-- BEGIN active_users -->
	<a data-uid="{active_users.uid}" href="{relative_path}/user/{active_users.userslug}">
		<!-- IF active_users.picture -->
		<img title="{active_users.username}" src="{active_users.picture}" class="avatar avatar-sm not-responsive" />
		<!-- ELSE -->
		<div class="avatar avatar-sm not-responsive" style="background-color: {active_users.icon:bgColor};">{active_users.icon:text}</div>
		<!-- ENDIF active_users.picture -->
	</a>
	<!-- END active_users -->
</div>

<script type="text/javascript">

$(window).on('action:ajaxify.start', function(ev) {
	socket.removeListener('event:new_topic', addActiveUser);
});

function addActiveUser(topic) {
	var activeUser = $('.active-users').find('a[data-uid="' + topic.uid + '"]');

	if(!activeUser.length) {
		ajaxify.loadTemplate('activeusers', function(template) {

			var newUser = templates.parse(templates.getBlock(template, 'active_users'), {
				active_users: [{
					uid: topic.uid,
					username: topic.user.username,
					userslug: topic.user.userslug,
					picture: topic.user.picture
				}]
			});
			$(newUser).prependTo($('.active-users'));
		});
	} else {
		activeUser.prependTo($('.active-users'));
	}
}

socket.on('event:new_topic', addActiveUser);
</script>