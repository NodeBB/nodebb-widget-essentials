<div class="popular-tags d-flex flex-column gap-2 mb-3">
{{{ if (display == "bars") }}}
	{{{ each tags }}}
	<div class="d-flex align-items-center gap-2">
		<div class="w-75 p-1 border position-relative" style="min-width: 0;">
			<div class="position-absolute bg-info opacity-25 start-0 top-0" style="width: 100%; height:100%; z-index: 0;"></div>

			<div data-width="{./widthPercent}" class="popular-tags-bar position-absolute bg-info opacity-50 start-0 top-0" style="transition: width 750ms ease-out; width: 0%; height:100%; z-index: 0;"></div>

			<a style="background-color: transparent!important; z-index: 1;" class="d-inline-block w-100 text-decoration-none text-bg-info position-relative text-truncate align-middle" href="{{{ if template.category }}}?tag={./valueEncoded}{{{ else }}}{relative_path}/tags/{./valueEncoded}{{{ end }}}"><span class="text-nowrap tag-class-{tags.class}">{./valueEscaped}</span></a>
		</div>

		<div class="text-center fw-bold p-1 text-end w-25 tag-topic-count border rounded">{./score}</div>
	</div>
	{{{ end }}}
{{{ end }}}
{{{ if (display == "buttons") }}}
<div class="tag-list row row-cols-2 gx-3 gy-2">
	{{{ each tags }}}
	<div>
		<a href="{config.relative_path}/tags/{./valueEncoded}" data-tag="{./valueEscaped}" class="btn btn-ghost ff-base d-flex flex-column gap-1 align-items-start justify-content-start text-truncate p-2">
			<div class="fw-semibold text-nowrap tag-item w-100 text-start text-truncate">{./valueEscaped}</div>
			<div class="text-xs text-muted text-nowrap tag-topic-count">[[global:x-topics, {txEscape(formattedNumber(./score))}]]</div>
		</a>
	</div>
	{{{ end }}}
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
