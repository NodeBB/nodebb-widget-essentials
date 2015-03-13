<div class="row forum-stats">
	<div class="col-md-3 col-xs-3">
		<div class="stats-card text-center {statsClass}">
			<h3><span class="stats" id="onlineUsers" title="{online}">{online}</span><br /><small>Online</small></h3>
		</div>
	</div>
	<div class="col-md-3 col-xs-3">
		<div class="stats-card text-center {statsClass}">
			<h3><span class="stats" id="registeredUsers" title="{users}">{users}</span><br /><small>[[global:users]]</small></h3>
		</div>
	</div>
	<div class="col-md-3 col-xs-3">
		<div class="stats-card text-center {statsClass}">
			<h3><span class="stats" id="topicsNumber" title="{topics}">{topics}</span><br /><small>[[global:topics]]</small></h3>
		</div>
	</div>
	<div class="col-md-3 col-xs-3">
		<div class="stats-card text-center {statsClass}">
			<h3><span class="stats" id="postsNumber" title="{posts}">{posts}</span><br /><small>[[global:posts]]</small></h3>
		</div>
	</div>
</div>

<script>
$(document).ready(function() {
	utils.makeNumbersHumanReadable($('.forum-stats .stats'));

	// When new post or topic, you update stats
	socket.on('event:new_post', updateStats);
	socket.on('event:new_topic', updateStats);
	// When someone load the widget, you update stats
	socket.on('event:widgets.requestStatsUpdate', autoUpdateStats);
	
	function updateStats(d)
	{
		socket.emit("plugins.updateStats", function(err, data){
			if(!err)
			{
				autoUpdateStats(data);
			}
		});
	}

	function autoUpdateStats(data)
	{
		updateAnimation($("#onlineUsers"), data.online);
		updateAnimation($("#registeredUsers"), data.users);
		updateAnimation($("#topicsNumber"), data.topics);
		updateAnimation($("#postsNumber"), data.posts);
	}

	function updateAnimation(element, newValue)
	{
		//var maxSize = 45, minSize = 30, opamin=0.25, opamax=1, colorin="#6BCC66", colorout="#cf246a";
		if(element.html() != newValue)
		{	// If has changed, i do the animation
			element.slideUp(500, function(){
				element.html(newValue);
				element.slideDown(500);
			});
		}
	}
	

});
</script>