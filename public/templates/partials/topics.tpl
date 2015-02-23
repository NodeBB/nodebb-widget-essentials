<!-- BEGIN topics -->
<li class="clearfix">
	
	
	<i id="catid" class="fa fa-lg {topics.category.icon} pull-left"></i>
		
		<span id="big"><a href="{config.relative_path}/topic/{topics.slug}">{topics.title}</a> </span>
	
	
	
		
		
		<p id="sub"><a href="<!-- IF topics.user.userslug -->{relative_path}/user/{topics.user.userslug}<!-- ELSE -->#<!-- ENDIF topics.user.userslug -->">{topics.user.username}</a> |  <a href="{relative_path}/category/{topics.category.slug}">{topics.category.name}</a> 
		
		
		<span id="pull"><span title=" Respuestas: {topics.postcount} - Visitas: {topics.viewcount}"><i class="fa fa-signal"></i> &nbsp; {topics.postcount} / {topics.viewcount}</span>&nbsp;
		<!-- IF topics.unreplied -->
		| &nbsp;
		<a href="{relative_path}/topic/{topics.slug}/" title="Ir al hilo"><span>{function.humanReadableDateLast}</span>&nbsp;<i class="fa fa-lg fa-long-arrow-right"></i> </a>
		<!-- ELSE -->
		 | &nbsp; <a href="{relative_path}/topic/{topics.slug}/{topics.teaser.index}" title="Ir al último mensaje"><span>{function.humanReadableDateLast}</span>  &nbsp;<i class="fa fa-lg fa-long-arrow-right"></i></a>
		<!-- ENDIF topics.unreplied -->
		</span>
		</p> 
		
		
</li>	
<hr style="margin-top:2px; margin-bottom:2px">
<!-- END topics -->
