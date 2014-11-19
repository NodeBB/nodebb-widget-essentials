<label>Amount of Posts to display:</label>
<input type="text" class="form-control" name="numPosts" placeholder="4" />
<label>Select Duration:</label>
<select name="duration" class="form-control">
	<option value="day">Day</option>
	<option value="week">Week</option>
	<option value="month">Month</option>
</select>
<label>
	Custom Category:<br />
	<small>Leave blank to to dynamically pull from current category. If placed on a page other than a category will pull from all recent posts</small>
</label>
<input type="text" class="form-control" name="cid" placeholder="0" />