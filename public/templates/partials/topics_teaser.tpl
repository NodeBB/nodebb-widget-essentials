<!-- BEGIN topics -->
<li class="clearfix widget-topics">
	<a href="<!-- IF topics.teaser.user.userslug -->{relative_path}/user/{topics.teaser.user.userslug}<!-- ELSE -->#<!-- ENDIF topics.teaser.user.userslug -->">
		<!-- IF topics.teaser.user.picture -->
		<img title="{topics.teaser.user.username}" class="avatar avatar-sm not-responsive" src="{topics.teaser.user.picture}" />
		<!-- ELSE -->
		<div class="avatar avatar-sm not-responsive" style="background-color: {topics.teaser.user.icon:bgColor};">{topics.teaser.user.icon:text}</div>
		<!-- ENDIF topics.teaser.user.picture -->
	</a>

	<p>
		<a href="{relative_path}/topic/{topics.slug}">{topics.title}</a>
	</p>
	<span class="pull-right post-preview-footer">
		<span class="timeago" title="{topics.lastposttimeISO}"></span>
	</span>
</li>
<!-- END topics -->
