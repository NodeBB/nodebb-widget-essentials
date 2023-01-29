<div data-component="widget/active-users" class="d-flex flex-wrap gap-1 mb-3">
	{{{ each active_users }}}
	<a class="text-decoration-none" data-uid="{./uid}" href="{relative_path}/user/{./userslug}">{buildAvatar(active_users, "24px", true, "avatar-tooltip not-responsive")}</a>
	{{{ end }}}
</div>

<script type="text/javascript">
	(function() {
		function handleActiveUsers() {
			function onNewTopic(topic) {
				const activeUsersEl = $('[data-component="widget/active-users"]');
				const activeUser = activeUsersEl.find('a[data-uid="' + topic.uid + '"]');

				if (activeUser.length) {
					return activeUser.prependTo(activeUsersEl);
				}

				app.parseAndTranslate('widgets/activeusers', 'active_users', {
					relative_path: config.relative_path,
					active_users: [topic.user],
				}, function (html) {
					html.prependTo(activeUsersEl);
				});
			}

			function onAjaxifyEnd() {
				const activeUsersEl = $('[data-component="widget/active-users"]');
				socket.removeListener('event:new_topic', onNewTopic);
				if (activeUsersEl.length) {
					socket.on('event:new_topic', onNewTopic);
				} else {
					$(window).off('action:ajaxify.end', onAjaxifyEnd);
				}
			}

			$(window).on('action:ajaxify.end', onAjaxifyEnd);
		}

		if (document.readyState === 'loading') {
			document.addEventListener('DOMContentLoaded', handleActiveUsers);
		} else {
			handleActiveUsers();
		}
	})();
</script>