<!-- BEGIN topics -->
<li class="clearfix widget-topics">
	<a href="<!-- IF topics.user.userslug -->{relative_path}/user/{topics.user.userslug}<!-- ELSE -->#<!-- ENDIF topics.user.userslug -->">
		<!-- IF topics.user.picture -->
		<img title="{topics.user.username}" class="avatar avatar-sm not-responsive" src="{topics.user.picture}" />
		<!-- ELSE -->
		<div class="avatar avatar-sm not-responsive" style="background-color: {topics.user.icon:bgColor};">{topics.user.icon:text}</div>
		<!-- ENDIF topics.user.picture -->
	</a>

	<p>
		<a href="{relative_path}/topic/{topics.slug}">{topics.title}</a>
	</p>
	<span class="pull-right post-preview-footer">
		<span class="timeago" title="{topics.lastposttimeISO}"></span>
	</span>
</li>
<!-- END topics -->