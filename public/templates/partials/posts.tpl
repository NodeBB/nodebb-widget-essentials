<!-- BEGIN posts -->
<li data-pid="{posts.pid}" class="clearfix">
	<a href="<!-- IF posts.user.userslug -->{relative_path}/user/{posts.user.userslug}<!-- ELSE -->#<!-- ENDIF posts.user.userslug -->">
		<img title="{posts.user.username}" class="profile-image user-img" src="{posts.user.picture}" />
	</a>
	<div>
		{posts.content}
	</div>
	<span class="pull-right footer">
		<span class="timeago" title="{posts.relativeTime}"></span> &bull;
		<a href="{relative_path}/topic/{posts.topic.slug}#{posts.pid}">[[global:read_more]]</a>
	</span>
</li>
<!-- END posts -->