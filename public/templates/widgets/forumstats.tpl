<div class="row forum-stats">
	<div class="col-md-3 col-xs-6">
		<div class="stats-card text-center {statsClass}">
			<h2><span class="stats" id="onlineUsers" title="{online}">{online}</span><br /><small>[[global:online]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card text-center {statsClass}">
			<h2><span class="stats" id="registeredUsers" title="{users}">{users}</span><br /><small>[[global:users]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card text-center {statsClass}">
			<h2><span class="stats" id="topicsNumber" title="{topics}">{topics}</span><br /><small>[[global:topics]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card text-center {statsClass}">
			<h2><span class="stats" id="postsNumber" title="{posts}">{posts}</span><br /><small>[[global:posts]]</small></h2>
		</div>
	</div>
</div>

<script>
$(document).ready(function() {
	utils.makeNumbersHumanReadable($('.forum-stats .stats'));

	// If something occured, updateStats!
	socket.on('event:new_post', updateStats);
	socket.on('event:new_topic', updateStats);
	socket.on('event:widgets.requestStatsUpdate', updateStats);
	
	function updateStats(data)
	{
		socket.emit("plugins.updateStats", function(err, data){
			if(!err)
			{
				$("#onlineUsers").html(data.online);
				$("#registeredUsers").html(data.users);
				$("#topicsNumber").html(data.topics);
				$("#postsNumber").html(data.posts);
			}
		});
	}
	

});
</script>