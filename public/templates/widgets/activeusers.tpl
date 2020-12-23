<div class="active-users">
	<!-- BEGIN active_users -->
	<a data-uid="{active_users.uid}" href="{relative_path}/user/{active_users.userslug}">
		<!-- IF active_users.picture -->
		<img title="{active_users.username}" src="{active_users.picture}" class="avatar avatar-sm avatar-rounded not-responsive" />
		<!-- ELSE -->
		<div title="{active_users.username}" class="avatar avatar-sm avatar-rounded not-responsive" style="background-color: {active_users.icon:bgColor};">{active_users.icon:text}</div>
		<!-- ENDIF active_users.picture -->
	</a>
	<!-- END active_users -->
</div>

<script type="text/javascript">
	(function() {
		function handleActiveUsers() {
			function onNewTopic(topic) {
				var activeUser = $('.active-users').find('a[data-uid="' + topic.uid + '"]');

				if (activeUser.length) {
					return activeUser.prependTo($('.active-users'));
				}

				app.parseAndTranslate('widgets/activeusers', 'active_users', {
					relative_path: config.relative_path,
					active_users: [{
						uid: topic.uid,
						username: topic.user.username,
						userslug: topic.user.userslug,
						picture: topic.user.picture,
						'icon:bgColor': topic.user['icon:bgColor'],
						'icon:text': topic.user['icon:text']
					}]
				}, function (html) {
					html.prependTo($('.active-users'))
					app.createUserTooltips();
				});
			}

			function onAjaxifyEnd() {
				socket.removeListener('event:new_topic', onNewTopic);
				if ($('.active-users').length) {
					socket.on('event:new_topic', onNewTopic);
				} else {
					$(window).off('action:ajaxify.end', onAjaxifyEnd);
				}
			}

			$(window).on('action:ajaxify.end', onAjaxifyEnd);
		}

		if (window.jQuery) {
			handleActiveUsers();
		} else {
			window.addEventListener('DOMContentLoaded', handleActiveUsers);
		}
	})();
</script>