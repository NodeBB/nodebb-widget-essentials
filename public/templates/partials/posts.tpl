<!-- BEGIN posts -->
<li data-pid="{posts.pid}" class="clearfix widget-posts">
	<a href="<!-- IF posts.user.userslug -->{config.relative_path}/user/{posts.user.userslug}<!-- ELSE -->#<!-- ENDIF posts.user.userslug -->">

		<!-- IF posts.user.picture -->
		<img title="{posts.user.username}" class="avatar avatar-sm not-responsive" src="{posts.user.picture}" />
		<!-- ELSE -->
		<div class="avatar avatar-sm not-responsive" style="background-color: {posts.user.icon:bgColor};">{posts.user.icon:text}</div>
		<!-- ENDIF posts.user.picture -->
	</a>
	<div>
		{posts.content}
		<p class="fade-out"></p>
	</div>
	<span class="pull-right post-preview-footer">
		<span class="timeago" title="{posts.timestampISO}"></span> &bull;
		<a href="{config.relative_path}/topic/{posts.topic.slug}/{posts.index}">[[global:read_more]]</a>
	</span>
</li>
<!-- END posts -->