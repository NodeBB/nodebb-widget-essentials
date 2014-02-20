(function() {
	"use strict";

	jQuery('document').ready(function() {
		
		// New post / post replies
		Mousetrap.bind('alt+n', function(e) {
			var cid = templates.get('category_id'),
				tid = templates.get('topic_id');

			require(['composer'], function (cmp) {
				if (cid) {
					cmp.push(0, cid);
				} else if (tid) {
					cmp.push(tid, null, null);
				}
			});
		});


	});
}());