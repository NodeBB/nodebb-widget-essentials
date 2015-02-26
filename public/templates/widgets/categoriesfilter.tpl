<div class="row home" itemscope itemtype="http://www.schema.org/ItemList">
	<div id="pad" class="col-lg-7 col-md-7 col-sm-12 col-xs-12" no-widget-class="col-lg-12 col-sm-12" no-widget-target="sidebar" style="width: 100%;">
		<!-- BEGIN categories -->
		<div class="category {categories.class} padding15" data-cid="{categories.cid}" data-numRecentReplies="{categories.numRecentReplies}">

			<meta itemprop="name" content="{categories.name}">

			<!-- IF categories.link -->
			<div id="category-{categories.cid}" title="{categories.description}">
				<h4 class="category-title">
					<i class="fa {categories.icon}"></i>
						{categories.name}
				</h4>
			</div>
			<!-- ELSE -->
			<div class="category-box">
				<a id="category-{categories.cid}"  href="{relative_path}/category/{categories.slug}" class="category-header category-header-image-{categories.imageClass}" style="background-image: linear-gradient(rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.8)), url({categories.backgroundImage});
											<!-- IF categories.bgColor -->background-color: {categories.bgColor};<!-- ENDIF categories.bgColor -->">
					<h3 class="category-title">
						<i class="fa {categories.icon}"></i>
						<p>{categories.name}</p>
					</h3>
					
				</a>
				<div class="category-info hidden-xs">
					<div class="category-stats" style="text-align: center;">
						<i class="fa fa-comments-o" title="Temas"> {categories.topic_count} </i>  | <i class="fa fa-pencil" title="Mensajes"> {categories.post_count} </i>
					</div>
					<div class="category-last-topic">
						<!-- BEGIN posts -->
						<!-- IF @first -->
						<a class="italic last-topic-title" href="topic/{categories.posts.topic.slug}/{categories.posts.index}">{categories.posts.topic.title}</a>
						<span class="last-topic-date">{function.humanReadableDate}</span>
						<!-- ENDIF @first -->
						<!-- END posts -->
					</div>
				</div>
			</div>
			<!-- ENDIF categories.link -->
		</div>
		<!-- END categories -->

	</div>
</div>