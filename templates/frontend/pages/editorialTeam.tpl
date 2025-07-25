{**
 * templates/frontend/pages/editorialTeam.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the editorial team.
 *
 * @uses $currentContext Journal|Press The current journal or press
 *}
{include file="frontend/components/header.tpl" pageTitle="about.editorialTeam"}

<div class="page page_editorial_team">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.editorialTeam"}

    {capture assign=leftCol}

	<h1>
		{translate key="about.editorialTeam"}
	</h1>
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.editorialTeam"}
	{$currentContext->getLocalizedData('editorialTeam')}

    {/capture}

    {include file="frontend/objects/content.tpl"}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
