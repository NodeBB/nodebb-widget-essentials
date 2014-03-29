<div class="active-users">
	<!-- BEGIN active_users -->
	<a data-uid="{active_users.uid}" href="../../user/{active_users.userslug}"><img title="{active_users.username}" src="{active_users.picture}" class="img-rounded user-img" /></a>
	<!-- END active_users -->
</div>

<script type="text/javascript">
function addActiveUser(data) {
	var activeUser = $('.active-users').find('a[data-uid="' + data.uid + '"]');
	if(!activeUser.length && templates.cache['category']) {
		var newUser = templates.parse(templates.getBlock(templates.cache['category'], 'active_users'), {
			active_users: [{
				uid: data.uid,
				username: data.username,
				userslug: data.userslug,
				picture: data.teaser_userpicture
			}]
		});
		$(newUser).appendTo($('.active-users'));
	}
}

socket.on('event:new_topic', addActiveUser);
</script>