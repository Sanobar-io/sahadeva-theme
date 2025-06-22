{**
 * sahadeva/frontend/pages/article.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view an article with all of it's details.
 *
 * @uses $article Submission This article
 * @uses $publication Publication The publication being displayed
 * @uses $firstPublication Publication The first published version of this article
 * @uses $currentPublication Publication The most recently published version of this article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $journal Journal The journal currently being viewed.
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$article->getLocalizedFullTitle()|escape}

<div class="page">

    {if $section}
        {include file="frontend/components/breadcrumbs_article.tpl" currentTitle=$section->getLocalizedTitle()}
    {else}
        {include file="frontend/components/breadcrumbs_article.tpl" currentTitleKey="common.publication"}
    {/if}

    {capture assign=leftCol}
    <section class="article-meta">
        <h1>{$publication->getLocalizedTitle()|escape}</h1>
        <div class="meta">
            <div class="issue-meta">
                <span class="journal">{$currentContext->getLocalizedName()}</span> •
                <span class="issue">{$issue->getIssueIdentification()}</span>
            </div>
            <ul class="process-meta">
            {if $submissionDate}
                <li><b>Submitted:</b> {$submissionDate|date_format:$dateFormatShort}</li>
            {/if}
            {if $acceptanceDate}
                <li><b>Accepted:</b> {$acceptanceDate|date_format:$dateFormatShort}</li>
            {/if}
            {if $publishDate}
                <li><b>Published:</b> {$publishDate|date_format:$dateFormatShort}</li>
            {/if}
            </ul>
            {if $publication->getData('pub-data::doi')}

            <div class="doi">
                <b>DOI:</b> {$publication->getData('pub-data::doi')}
            </div>

            {/if}
        </div>
        <div class="extra-content">
            {call_hook name="Templates::Article::Details"}
        </div>
        <ul class="authors">
        {foreach from=$publication->getData('authors') item=author}
            <li>
                <div class="name">{$author->getFullName()|escape}</div>
                {if $author->getLocalizedData('affiliation')}
                
                <div class="affiliation">
                    {$author->getLocalizedData('affiliation')}
                </div>
                
                {/if}
            </li>
        {/foreach}
        </ul>
        <div class="toolbox">
        </div>
    </section>

    <hr />

    <article class="article inner-wrapper">
        <section class="abstract text-wrapper center">
            <h2>Abstract</h2>
            {$publication->getLocalizedData('abstract')}
        </section>
        {* Galley *}
        {assign var=galleys value=$publication->getData('galleys')}
        {if $galleys|@count}
            <section class="cta text-center">
            {foreach from=$galleys item=galley}
                {if $galley->getFileType() == 'application/pdf'}
                    <p>This text has been made available for reading.</p>
                    <a class="center" href="{url page='article' op='view' path=$article->getBestId()|to_array:$galley->getBestGalleyId()}">Read Full Text <img src="{$baseUrl}/plugins/themes/sahadeva/images/pdf.png" /></a>
                    {break}
                {/if}
            {/foreach}
            </section>
        {/if}

        <section class="references"></section>
    </article>
    {/capture}


    {include file="frontend/objects/content.tpl"}



    <section class="footer-content">
        {call_hook name="Templates::Article::Footer::PageFooter"}
    </section>

</div>

{include file="frontend/components/footer.tpl"}
