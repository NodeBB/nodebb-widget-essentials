<div class="row footer-stats">
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span id="stats_online"></span><br /><small>[[footer:stats.online]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span id="stats_users"></span><br /><small>[[footer:stats.users]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span id="stats_topics"></span><br /><small>[[footer:stats.topics]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span id="stats_posts"></span><br /><small>[[footer:stats.posts]]</small></h2>
		</div>
	</div>
</div>

<script type="text/javascript">
ajaxify.register_events([
	'user.count',
	'meta.getUsageStats',
	'user.getActiveUsers'
]);

socket.emit('user.count', updateUserCount);
socket.on('user.count', updateUserCount);

function updateUserCount(err, data) {
	$('#stats_users').html(utils.makeNumberHumanReadable(data.count)).attr('title', data.count);
}

socket.emit('meta.getUsageStats', updateUsageStats);
socket.on('meta.getUsageStats', updateUsageStats);

function updateUsageStats(err, data) {
	$('#stats_topics').html(utils.makeNumberHumanReadable(data.topics)).attr('title', data.topics);
	$('#stats_posts').html(utils.makeNumberHumanReadable(data.posts)).attr('title', data.posts);
}

socket.emit('user.getActiveUsers', updateActiveUsers);
socket.on('user.getActiveUsers', updateActiveUsers);

function updateActiveUsers(err, data) {
	$('#stats_online').html(data.users);
}	
</script>