<div id="chat-modal-{roomId}" data-roomid="{roomId}">
	<div class="" component="chat/message/window">
		<div class="d-flex gap-4 justify-content-between mb-1">
			<div class="fs-6 flex-grow-1 fw-semibold tracking-tight text-truncate text-nowrap" component="chat/room/name" data-icon="{icon}">{{{ if ./roomName }}}<i class="fa {icon} text-muted"></i> {roomName}{{{ else }}}{./chatWithMessage}{{{ end}}}</div>
			<div class="d-flex gap-1 align-items-center">
				<a href="{config.relative_path}/chats/{roomId}" class="btn-ghost-sm d-none d-md-flex" title="[[modules:chat.maximize]]" data-bs-toggle="tooltip" data-bs-placement="bottom">
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
		const roomId = {roomId};
		function loadChatWidget() {
			async function onAjaxifyEnd() {
				const roomWidget = $(`#chat-modal-{roomId}`);

				if (roomWidget.length) {
					const chat = await app.require('chat');
					chat.initWidget(roomId, roomWidget);
				} else {
					$(window).off('action:ajaxify.end', onAjaxifyEnd);
					socket.emit('modules.chats.leave', roomId);
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