<div class="search-widget">
	<form action="{relative_path}/search" method="GET">
		<div class="row">
			<div class="col-xs-6 {{{ if showInControl }}}col-md-10{{{ else }}} col-md-12 {{{ end }}}">
				<div class="input-group">
					<input type="text" class="form-control" name="term" placeholder="Search"/>
					<div class="input-group-btn">
						<button class="btn btn-primary" type="submit">
							<i class="fa fa-search"></i>
						</button>
					</div>
				</div>
				<div class="quick-search-container hidden" style="right: auto; z-index: 1001;">
					<div class="text-center loading-indicator"><i class="fa fa-spinner fa-spin"></i></div>
					<div class="quick-search-results-container"></div>
				</div>
			</div>

			<div class="{{{ if showInControl}}}col-xs-2 col-md-2 {{{ else }}} hidden {{{ end }}}">
				<select name="in" class="form-control">
					{{{ each inOptions }}}
					<option value="{./value}" {{{ if ./selected }}} selected {{{ end }}}>{./label}</option>
					{{{ end }}}
				</select>
			</div>
		</div>
	</form>
</div>
<script>
(function() {
	async function prepareSearch() {
		const isQuickSearchEnabled = {enableQuickSearch};
		if (isQuickSearchEnabled) {
			const search = await app.require('search');
			const searchWidget =  $('.search-widget');
			function enableQuickSearch () {
				search.enableQuickSearch({
					searchElements: {
						inputEl: searchWidget.find('input[name="term"]'),
						resultEl: searchWidget.find('.quick-search-container'),
					},
					searchOptions: {
						in: searchWidget.find('select[name="in"]').val(),
					},
				});
			}
			enableQuickSearch();
			searchWidget.find('select[name="in"]').on('change', function () {
				enableQuickSearch();
				searchWidget.find('input[name="term"]').trigger('refresh');
			});
		}
	}
	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', prepareSearch);
	} else {
		prepareSearch();
	}
})();
</script>
