<div data-component="widget/active-users" class="d-flex flex-column gap-1 mb-2">
	{{{ each active_users }}}
	<a href="{config.relative_path}/user/{./userslug}" class="btn btn-ghost d-flex gap-2 ff-secondary align-items-start text-start p-2 ff-base flex-grow-1">
		{buildAvatar(@value, "48px", true, "flex-shrink-0")}
		<div class="d-flex flex-column gap-1 text-truncate">
			<div class="fw-semibold text-truncate" title="{./displayname}">{./displayname}</div>
			<div class="text-xs text-muted text-truncate">
				<span class="timeago" title="{./lastposttimeISO}"></span>
			</div>
		</div>
	</a>
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