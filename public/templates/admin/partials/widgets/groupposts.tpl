<div class="mb-3">
	<label class="form-label">Amount of Posts to display:</label>
	<input type="text" class="form-control" name="numPosts" placeholder="4" />
</div>
<div class="mb-3">
	<label class="form-label">Select Group</label>
	<select name="groupName" class="form-select">
		<!-- BEGIN groups -->
		<option value="{groups.name}">{groups.name}</option>
		<!-- END groups -->
	</select>
</div>
