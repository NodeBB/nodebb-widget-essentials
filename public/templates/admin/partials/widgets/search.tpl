<div class="form-check mb-3">
	<input type="checkbox" class="form-check-input" id="enableQuickSearch" name="enableQuickSearch" />
	<label class="form-check-label" for="enableQuickSearch">Enable Quick Search</label>
</div>

<div class="form-check mb-3">
	<input type="checkbox" class="form-check-input" id="showInControl" name="showInControl" />
	<label class="form-check-label" for="showInControl">Show In Control</label>
</div>

<div class="mb-3">
	<label class=form-label" for="defaultIn">Default In</label>
	<select class="form-select" id="defaultIn" name="defaultIn">
		<option value="titles">{{tx("search:in-titles")}}</option>
		<option value="titlesposts">{{tx("search:in-titles-posts")}}</option>
		<option value="posts">{{tx("global:posts")}}</option>
		<option value="categories">{{tx("global:header.categories")}}</option>
		<option value="users">{{tx("global:users")}}</option>
		<option value="tags">{{tx("tags:tags")}}</option>
	</select>
</div>
