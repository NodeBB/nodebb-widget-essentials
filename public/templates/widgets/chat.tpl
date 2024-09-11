<div component="chat/widget" id="chat-modal-{roomId}" data-roomid="{roomId}">
	<div component="chat/message/window">
		<div class="d-flex gap-4 justify-content-between mb-1">
			<div class="dropdown">
				<button class="btn btn-ghost btn-sm dropdown-toggle d-flex gap-2 align-items-center" type="button" data-bs-toggle="dropdown" aria-expanded="false">
					{{{ if ./roomName }}}<i class="fa {icon} text-muted"></i> {roomName}{{{ end}}}
				</button>
				<ul class="dropdown-menu p-1">
					{{{ each publicRooms }}}
					<li>
						<a class="dropdown-item rounded-1 d-flex align-items-center gap-2" href="#" role="menuitem" data-roomid="{./roomId}">
							<span class="flex-grow-1"><i class="fa {./icon} text-muted"></i> {./roomName}</span>
							<i class="flex-shrink-0 fa fa-fw text-secondary {{{ if ./selected }}} fa-check{{{ end }}}"></i>
						</a>
					</li>
					{{{ end }}}
				</ul>
			</div>

			<div class="d-flex gap-1 align-items-center">
				<a href="{config.relative_path}/chats/{roomId}" class="btn btn-ghost btn-sm d-none d-md-flex p-1" title="[[modules:chat.maximize]]" data-bs-toggle="tooltip" data-bs-placement="bottom">
					<i class="fa fa-fw fa-expand text-muted"></i>
				</a>
			</div>
		</div>
		<!-- IMPORT partials/chats/scroll-up-alert.tpl -->
		<div class="d-flex flex-column" style="height: 500px;">
			<div class="d-flex flex-grow-1 gap-1 overflow-auto" style="min-width: 0px;">
				<div component="chat/messages" class="expanded-chat d-flex flex-column flex-grow-1" data-roomid="{roomId}" style="min-width: 0px;">

					<ul component="chat/message/content" class="chat-content p-0 m-0 list-unstyled overflow-auto flex-grow-1">
						<!-- IMPORT partials/chats/messages.tpl -->
					</ul>
					<ul component="chat/message/search/results" class="chat-content p-0 m-0 list-unstyled overflow-auto flex-grow-1 hidden">
						<div component="chat/message/search/no-results" class="text-center p-4 d-flex flex-column">
							<div class="p-4"><i class="fa-solid fa-wind fs-2 text-muted"></i></div>
							<div class="text-xs fw-semibold text-muted">[[search:no-matches]]</div>
						</div>
					</ul>
					<!-- IMPORT partials/chats/composer.tpl -->
				</div>
			</div>
		</div>
		<div class="imagedrop"><div>[[topic:composer.drag-and-drop-images]]</div></div>
	</div>
</div>
<script type="text/javascript">
	(function() {
		function loadChatWidget() {
			async function switchToChat(roomId, roomWidget) {
				const api = await app.require('api');
				const roomData = await api.get('/api/user/' + app.user.userslug + '/chats/' + roomId);
				roomData.publicRooms.forEach((room) => {
					if (room && parseInt(room.roomId, 10) === parseInt(roomId, 10)) {
						room.selected = true;
					}
				});
				const html = await app.parseAndTranslate('widgets/chat', roomData);
				roomWidget.replaceWith(html);
				const newWidget = $('[component="chat/widget"][data-roomid="' + roomId + '"]');
				initChatWidget(roomId, newWidget);
			}

			async function onAjaxifyEnd() {
				const roomWidgets = $(`[component="chat/widget"]`);
				if (!roomWidgets.length) {
					$(window).off('action:ajaxify.end', onAjaxifyEnd);
				}
				roomWidgets.each((index, roomWidget) => {
					const $roomWidget = $(roomWidget);
					const roomId = $roomWidget.attr('data-roomid');
					initChatWidget(roomId, $roomWidget);
				});
			}

			async function initChatWidget(roomId, roomWidget) {
				if (roomWidget.length) {
					const chat = await app.require('chat');
					chat.initWidget(roomId, roomWidget);

					roomWidget.on('click', '.dropdown-item[data-roomid]', function () {
						const newRoomId = $(this).attr('data-roomid');
						if (parseInt(newRoomId, 10) !== parseInt(roomId, 10)) {
							socket.emit('modules.chats.leave', roomId);
							switchToChat(newRoomId, roomWidget);
						}
					});
					$(window).one('action:ajaxify.end', function () {
						socket.emit('modules.chats.leave', roomId);
					});
				}
			}

			$(window).on('action:ajaxify.end', onAjaxifyEnd);
		}

		if (document.readyState === 'loading') {
			document.addEventListener('DOMContentLoaded', loadChatWidget);
		} else {
			loadChatWidget();
		}
	})();
</script>