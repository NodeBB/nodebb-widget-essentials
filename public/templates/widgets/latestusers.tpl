<div class="d-flex flex-wrap gap-1 mb-2">
	{{{ each users }}}
	<a class="text-decoration-none" data-uid="{./uid}" href="{relative_path}/user/{./userslug}">{buildAvatar(users, "24px", true, "avatar-tooltip not-responsive")}</a>
	{{{ end }}}
</div>