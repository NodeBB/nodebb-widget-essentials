<!-- BEGIN posts -->
<li data-pid="{posts.pid}" class="clearfix">
	<a href="<!-- IF posts.user.userslug -->{relative_path}/user/{posts.user.userslug}<!-- ELSE -->#<!-- ENDIF posts.user.userslug -->">
		<img title="{posts.user.username}" class="img-rounded user-img" src="{posts.user.picture}" />
	</a>
	<strong><span>{posts.user.username}</span></strong>
	<div>
		{posts.content}
	</div>
	<span class="pull-right">
		[[global:posted_ago, {posts.relativeTime}]] &bull;
		<a href="{relative_path}/topic/{posts.topic.slug}#{posts.pid}">[[global:read_more]] <i class="fa fa-chevron-circle-right"></i></a>
	</span>
</li>
<!-- END posts -->