<div class="popular-tags">
{{{ each tags}}}
	<span class="inline-block">
	<a href="{{{ if template.category }}}?tag={tags.value}{{{ else }}}{relative_path}/tags/{tags.value}{{{ end }}}"><span class="tag-item tag-{tags.value}">{tags.value}</span><span class="tag-topic-count">{tags.score}</span></a>
	</span>
{{{ end }}}
</div>
