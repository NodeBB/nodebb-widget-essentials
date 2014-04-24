<div class="active-users">
	<!-- BEGIN active_users -->
	<a data-uid="{active_users.uid}" href="../../user/{active_users.userslug}"><img title="{active_users.username}" src="{active_users.picture}" class="img-rounded user-img" /></a>
	<!-- END active_users -->
</div>

<script type="text/javascript">
function addActiveUser(data) {
	var topic = data.topicData;
	console.log('test');
	var activeUser = $('.active-users').find('a[data-uid="' + topic.uid + '"]');
	console.log('test', activeUser.length);
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