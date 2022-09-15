
<div class="groups-list">
{{{ each groups }}}
<div class="groups-list-item clearfix">
	<img src="{groups.cover:url}" class="float-start" />
	<a href="{relative_path}/groups/{groups.slug}"><strong>{groups.displayName}</strong></a>
</div>
{{{ end }}}
</div>
