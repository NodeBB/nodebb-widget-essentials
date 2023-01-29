
<div class="groups-list d-flex flex-wrap gap-2 mb-3">
{{{ each groups }}}
	<div class="card group-hover-bg border-0 " style="flex-basis: 356px;">
		<a href="{config.relative_path}/groups/{./slug}" class="card-header border-bottom-0 pointer d-block list-cover" style="{{{ if ./cover:thumb:url }}}background-image: url({./cover:thumb:url});background-size: cover; min-height: 125px; background-position: {./cover:position}{{{ end }}}"></a>
		<a href="{config.relative_path}/groups/{./slug}" class="d-block h-100 text-reset text-decoration-none">
			<div class="card-body d-flex flex-column gap-1 border border-top-0 rounded-bottom h-100">
				<div class="d-flex">
					<div class="flex-1 fs-6 fw-semibold">{./displayName}</div>
					<div class="text-sm"><i class="text-muted fa-solid fa-user"></i> {./memberCount}</div>
				</div>
				<div class="text-sm">{./description}</div>
			</div>
		</a>
	</div>
{{{ end }}}
</div>
