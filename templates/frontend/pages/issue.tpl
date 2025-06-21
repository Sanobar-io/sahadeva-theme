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


<div class="breadcrumbs inner-wrapper">
    {include file="frontend/components/breadcrumbs_issue.tpl" currentTitle=$issueIdentification}
</div>

<section class="issue-wrapper inner-wrapper">
    {assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
    {if $issueCover}
    
    <img class="cover" src="{$issueCover|escape}" />

    <section class="overview">
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
</section>

<section class="issue-contents inner-wrapper">
    <div class="col-left">
    {foreach name=sections from=$publishedSubmissions item=section}
        <div class="section">
            {if $section.articles}
                <h2>{$section.title|escape}</h2>
            {/if}
            <ul class="articles-wrapper">
            {foreach from=$section.articles item=article}
                <li>
                    <div class="meta">
                        <h3><a href="{url page="article" op="view" path=$article->getBestId()}">{$article->getLocalizedTitle()|strip_unsafe_html}</a></h3>
                        <a class="cta-rounded" href="{url page="article" op="view" path=$article->getBestId()}">
                            Read More
                        </a>
                    </div>
                    <div class="author-date">
                        {$article->getAuthorString()|escape} •
                        <span class="date">{$article->getDatePublished()|escape|date_format:"%B %e, %Y"}</span>
                    </div>
                    <div class="description">
                        {$article->getLocalizedAbstract()}
                    </div>
                </li>
            {/foreach}
            </ul>
        </div>
    {/foreach}
    <div class="issue-nav">
    </div>
    {if $previousIssue}
        <a class="cta-rounded" href="{url router=ROUTE_PAGE page="issue" op="view" path=$previousIssue->getBestIssueId()}">← Previous Issue</a><
    {/if}
    {if $nextIssue}
        <a class="cta-rounded" href="{url router=ROUTE_PAGE page="issue" op="view" path=$nextIssue->getBestIssueId()}">Next Issue →</a>
    {/if}
    </div>
    <div class="col-right">
    {capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
    {if $sidebarCode}
        {$sidebarCode}
    {/if}
    </div>
</section>

{include file="frontend/components/footer.tpl"}
