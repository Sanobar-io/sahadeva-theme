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
        {assign var=doi value=$issue->getStoredPubId('doi')}

        {if $issueCover}
        
        <img class="cover" fetchpriority="high" loading="eager" decoding="async" src="{$issueCover|escape}" />

        {/if}

        <div class="overview">
            <div class="meta">
                <div class="issue-meta">
                    Volume {$issue->getVolume()} | Number {$issue->getNumber()} | {$issue->getDatePublished()|date_format:"%Y"}
                </div>
            </div>
            <h2>{$currentJournal->getLocalizedName()}</h2>
            {if $doi}
            <div class="issue-pubid tab">
                <icon data-type="doi"></icon>
                <a href="https://doi.or/{$doi}">{$doi}</a>
            </div>
            {/if}
            <div class="description">
                {if $issue->getLocalizedDescription()}
                    {$issue->getLocalizedDescription()}
                {/if}
            </div>
        </div>

        {else}
            <h2>No articles have been published</h2>

        {/if}
    </section>

    {capture assign=leftCol}
        {foreach name=sections from=$sectionsWithViews item=section}
            {* Prepare articles for article_list *}

            <div class="section">
            {if $section.articles}
                <h2>{$section.title|escape}</h2>
                {include file="frontend/components/article_list.tpl" articles=$section.articles}
            {/if}


            </div>
        {/foreach}
    {/capture}

    {include file="frontend/objects/content.tpl"}
</div>

{include file="frontend/components/footer.tpl"}
