<!-- BEGIN topics -->
<li class="clearfix">

    <i class="cat-icon fa fa-2x {topics.category.icon} pull-left"></i>

    <span id="big"><a href="{config.relative_path}/topic/{topics.slug}">{topics.title}</a> </span>

    <p id="sub"><a href="<!-- IF topics.user.userslug -->{relative_path}/user/{topics.user.userslug}<!-- ELSE -->#<!-- ENDIF topics.user.userslug -->">{topics.user.username}</a> | <a href="{relative_path}/category/{topics.category.slug}">{topics.category.name}</a>
        <span class="pull-right">
			<!-- IF topics.unreplied -->
			<a href="{relative_path}/topic/{topics.slug}/" title="Ir al hilo"><span>{function.humanReadableDateLast}</span>&nbsp;<i class="fa fa-long-arrow-right"></i> </a>
        <!-- ELSE -->
        {topics.postcount} respuestas |
        <a href="{relative_path}/topic/{topics.slug}/{topics.teaser.index}" title="Ir al último mensaje"><span>{function.humanReadableDateLast}</span>  &nbsp;<i class="fa fa-long-arrow-right"></i></a>
        <!-- ENDIF topics.unreplied -->
        </span>
    </p>

    <hr style="margin-top:4px !important; margin-bottom:4px !important">
</li>
<!-- END topics -->