{**
 * templates/frontend/pages/issueArchive.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display a list of recent issues.
 *
 * @uses $issues Array Collection of issues to display
 * @uses $prevPage int The previous page number
 * @uses $nextPage int The next page number
 * @uses $showingStart int The number of the first item on this page
 * @uses $showingEnd int The number of the last item on this page
 * @uses $total int Count of all published monographs
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

<div class="archive-wrapper page">

	{include file="frontend/components/breadcrumbs.tpl" currentTitle=$pageTitle}

	<h1>
		{$pageTitle|escape}
	</h1>

	{* No issues have been published *}
	{if empty($issues)}
		<p>{translate key="current.noCurrentIssueDesc"}</p>

	{* List issues *}
	{else}
		<ul class="issues-wrapper">
			{foreach from=$issues item="issue"}
				<li class="text-center">
                    <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
                        <img src="{$issue->getLocalizedCoverImageUrl()}" />
                        <div class="issue-info">
                            <div class="date">
                                {$issue->getData('datePublished')|date_format:"%Y"}
                            </div>
                            <div class="issue">
                                Volume {$issue->getVolume()} • No. {$issue->getNumber()}
                            </div>
                        </div>
                    </a>
				</li>
			{/foreach}
		</ul>

		{* Pagination *}
		{if $prevPage > 1}
			{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive" path=$prevPage}{/capture}
		{elseif $prevPage === 1}
			{capture assign=prevUrl}{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}{/capture}
		{/if}
		{if $nextPage}
			{capture assign=nextUrl}{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive" path=$nextPage}{/capture}
		{/if}
		{include
			file="frontend/components/pagination.tpl"
			prevUrl=$prevUrl
			nextUrl=$nextUrl
			showingStart=$showingStart
			showingEnd=$showingEnd
			total=$total
		}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
