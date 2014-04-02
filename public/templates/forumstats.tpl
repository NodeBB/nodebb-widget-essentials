<div class="row forum-stats">
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span class="stats_online"></span><br /><small>[[footer:stats.online]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span class="stats_users"></span><br /><small>[[footer:stats.users]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span class="stats_topics"></span><br /><small>[[footer:stats.topics]]</small></h2>
		</div>
	</div>
	<div class="col-md-3 col-xs-6">
		<div class="stats-card {statsClass}">
			<h2><span class="stats_posts"></span><br /><small>[[footer:stats.posts]]</small></h2>
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

function updateUserCount(err, count) {
	$('.forum-stats .stats_users').html(utils.makeNumberHumanReadable(count)).attr('title', count);
}

socket.emit('meta.getUsageStats', updateUsageStats);
socket.on('meta.getUsageStats', updateUsageStats);

function updateUsageStats(err, data) {
	$('.forum-stats .stats_topics').html(utils.makeNumberHumanReadable(data.topics)).attr('title', data.topics);
	$('.forum-stats .stats_posts').html(utils.makeNumberHumanReadable(data.posts)).attr('title', data.posts);
}

socket.emit('user.getActiveUsers', updateActiveUsers);
socket.on('user.getActiveUsers', updateActiveUsers);

function updateActiveUsers(err, data) {
	$('.forum-stats .stats_online').html(data.users);
}
</script>