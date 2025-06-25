{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3. See the COPYING file in the OJS root.
*
* This template overrides the default article list layout
* to match the Sahadeva theme design.
*
* @template sahadeva:frontend/pages/article.tpl
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
            {* Keywords *}
            {if $publication->getData('keywords')}
            <hr />
            <div class="keywords-wrapper">
                <div class="label">Keywords</div>
                <ul class="keywords">
                    {foreach from=$publication->getLocalizedData('keywords') item=keyword}
                    <li class="keyword">{$keyword}</li>
                    {/foreach}
                </ul>
            </div>
            {/if}
        </section>
        {* Galley *}
        {assign var=galleys value=$publication->getData('galleys')}
        {if $galleys|@count}
        <section class="cta text-center">
        {foreach from=$galleys item=galley}
            {if $galley->getFileType() == 'application/pdf'}
                <p>This text has been made available for reading.</p>
                <a class="center" href="{url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId()}">Read Full Text <img src="{$baseUrl}/plugins/themes/sahadeva/images/pdf.png" /></a>
                {break}
            {/if}
        {/foreach}
        </section>
        {/if}

        {* References *}
        {if $parsedCitations || $publication->getData('citationsRaw')}
        <hr/>
        <section class="item references">
            <h3>
                {translate key="submission.citations"}
            </h3>
            <div class="value">
                {if $parsedCitations}
                    {foreach from=$parsedCitations item="parsedCitation"}
                        <p>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
                    {/foreach}
                {else}
                    {$publication->getData('citationsRaw')|escape|nl2br}
                {/if}
            </div>
        </section>
        {/if}
    </article>
    
    {/capture}

    {capture assign=rightCol}
        <section class="article-publication-info">
            {* Volume Info *}
            <div class="label">Found In Issue</div>
            <div class="section-text">
                <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
                    {$issue->getIssueIdentification()|escape}
                </a>
            </div>
            {* Article Section *}
            {if $section}
            <div class="label">Section</div>
            <div class="section-text">{$section->getLocalizedTitle()|escape}</div>
            {/if}
            {* DOI *}
            {if $publication->getStoredPubId('doi')}
            <div class="label">DOI</div>
            <div class="section-text">
                <a href="https://doi.org/{$publication->getStoredPubId('doi')}">{$publication->getStoredPubId('doi')}</a>
            </div>
            {/if}
            {* Licensing Info *}
            {if $publication->getLocalizedData('copyrightHolder')}
            <div class="label">Licensing Terms</div>
            <div class="section-text">
                {assign var=licenseTerms value=$currentContext->getLocalizedData('licenseTerms')}
                © {$publishDate|date_format:"Y"} {$article->getAuthorString()|escape}. {$licenseTerms}
            </div>
            {/if}
        </section>
    {/capture}

    {include file="frontend/objects/content.tpl" sidebarDisabled=true}

    <section class="footer-content">
        {call_hook name="Templates::Article::Footer::PageFooter"}
    </section>

</div>

{include file="frontend/components/footer.tpl"}
