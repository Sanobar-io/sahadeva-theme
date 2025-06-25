{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3. See the COPYING file in the OJS root.
*
* This template overrides the default announcements archive layout to
* to match the Sahadeva theme design.
*
* @template sahadeva:frontend/components/announcements.tpl
*}

<ul class="cmp_announcements">
	{foreach from=$announcements item=announcement}
		<li>
			{include file="frontend/objects/announcement_summary.tpl"}
		</li>
	{/foreach}
</ul>
