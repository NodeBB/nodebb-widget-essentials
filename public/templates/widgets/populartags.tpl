<div class="popular-tags d-flex flex-column gap-2 mb-3">
{{{ each tags }}}
	<div class="d-flex align-items-center gap-2">
		<div class="w-75 p-1 border position-relative">
			<div class="position-absolute bg-info opacity-25 start-0 top-0" style="width: 100%; height:100%; z-index: 0;"></div>

			<div data-width="{./widthPercent}" class="popular-tags-bar position-absolute bg-info opacity-50 start-0 top-0" style="transition: width 750ms ease-out; width: 0%; height:100%; z-index: 0;"></div>

			<a style="background-color: transparent!important; z-index: 1;" class="d-inline-block w-100 text-decoration-none text-bg-info position-relative" href="{{{ if template.category }}}?tag={./valueEncoded}{{{ else }}}{relative_path}/tags/{./valueEncoded}{{{ end }}}"><span class="text-nowrap tag-class-{tags.class}">{./valueEscaped}</span></a>
		</div>

		<div class="text-center fw-bold p-1 text-end w-25 tag-topic-count border rounded">{./score}</div>
	</div>
{{{ end }}}
</div>
<script>
'use strict';
/* globals app, socket*/
(function() {
	function onLoad() {
		setTimeout(function () {
			$('.popular-tags-bar').each(function () {
				const bar = $(this);
				bar.css({ width: bar.attr('data-width') + '%' });
			});
		}, 100);
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', onLoad);
	} else {
		onLoad();
	}
})();
</script>
