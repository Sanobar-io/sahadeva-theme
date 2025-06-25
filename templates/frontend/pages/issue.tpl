{**
 * sahadeva/frontend/pages/issue.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display a landing page for a single issue. It will show the table of contents
 *  (toc) or a cover image, with a click through to the toc.
 *
 * @uses $issue Issue The issue
 * @uses $issueIdentification string Label for this issue, consisting of one or
 *       more of the volume, number, year and title, depending on settings
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $primaryGenreIds array List of file genre IDs for primary types
 *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification}

<div class="page">

    {include file="frontend/components/breadcrumbs_issue.tpl" currentTitle=$issueIdentification}
    

    <section class="issue-wrapper">
        {if $issue}

        {assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
        {if $issueCover}
        
        <img class="cover" src="{$issueCover|escape}" />

        <section class="overview text-wrapper">
            <h2>{$currentJournal->getLocalizedName()}</h2>
            <div class="meta">
                <div class="issue-meta">
                    Volume {$currentIssue->getVolume()} | Number {$currentIssue->getNumber()} | {$currentIssue->getDatePublished()|date_format:"%B %e, %Y"}
                </div>
                <ul class="issue-nav">
                {if $previousIssue}
                    <li><a class="issue-nav-btn" href="{url router=ROUTE_PAGE page="issue" op="view" path=$previousIssue->getBestIssueId()}">← Previous Issue</a></li>
                {/if}
                    <li><a class="issue-nav-btn" href="{url page="issue" op="archive"}">All Issues</a></li>
                {if $nextIssue}
                    <li><a class="issue-nav-btn" href="{url router=ROUTE_PAGE page="issue" op="view" path=$nextIssue->getBestIssueId()}">Next Issue →</a></li>
                {/if}
                </ul>
            </div>
            <div class="description">
                {if $issue->getLocalizedDescription()}
                    {$issue->getLocalizedDescription()}
                {/if}
            </div>
        </section>

        {/if}

        {else}
            <h1>No articles have been published</h1>

        {/if}
    </section>

    {capture assign=leftCol}
        {foreach name=sections from=$publishedSubmissions item=section}
            <div class="section">
            {if $section.articles}
                <h2>{$section.title|escape}</h2>
                {include file="frontend/components/article_list.tpl" articles=$section.articles}
            {/if}


            </div>
        {/foreach}

            <div class="issue-nav">
            {if $previousIssue}
                <a class="cta-rounded" href="{url router=ROUTE_PAGE page="issue" op="view" path=$previousIssue->getBestIssueId()}">← Previous Issue</a><
            {/if}
            {if $nextIssue}
                <a class="cta-rounded" href="{url router=ROUTE_PAGE page="issue" op="view" path=$nextIssue->getBestIssueId()}">Next Issue →</a>
            {/if}
            </div>
    {/capture}

    {include file="frontend/objects/content.tpl"}
</div>

{include file="frontend/components/footer.tpl"}
