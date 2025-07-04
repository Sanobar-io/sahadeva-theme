{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3.
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
    <div class="article-meta">
        <h1>{$publication->getLocalizedTitle()|escape}</h1>
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
    </div>

    <hr />

    <article id="the-article" class="article inner-wrapper">
    <div id="abstract-wrapper" class="text-wrapper center">
    {assign var=abstracts value=$publication->getData('abstract')}
    {assign var=keywords value=$publication->getData('keywords')}
    {if $abstracts}
        {if $abstracts|@count > 1}
        <div id="lang-selector">
        {assign var=langIndex value=0}
        {foreach from=$abstracts key=locale item=abstract}
            <button onclick="showAbstract({$langIndex}, this)">{$locale}</button>
            {assign var=langIndex value=$langIndex + 1}
        {/foreach}
        </div>
        {/if}
        <div id="abstracts-slider">
        {foreach from=$abstracts key=locale item=abstract}
        {if $locale === $currentLocale}
        <section class="abstract">
            <h2>{translate key="article.abstract" locale=$locale}</h2>
            {$abstract|strip_unsafe_html}
            <hr />
            {* Keywords *}
            {if $keywords[$locale]}
            <div class="keywords-wrapper">
                <div class="label">{translate key="article.subject" locale=$locale}</div>
                <ul class="keywords">
                    {foreach from=$keywords[$locale] item=keyword}
                    <li class="keyword">{$keyword}</li>
                    {/foreach}
                </ul>
            </div>
            {/if}
        </section>
        {/if}
        {/foreach}
        {foreach from=$abstracts key=locale item=abstract}
        {if $locale !== $currentLocale}
        <section class="abstract">
            <h2>{translate key="article.abstract" locale=$locale}</h2>
            {$abstract|strip_unsafe_html}
            <hr />
            {* Keywords *}
            {if $keywords[$locale]}
            <div class="keywords-wrapper">
                <div class="label">{translate key="article.subject" locale=$locale}</div>
                <ul class="keywords">
                    {foreach from=$keywords[$locale] item=keyword}
                    <li class="keyword">{$keyword}</li>
                    {/foreach}
                </ul>
            </div>
            {/if}
        </section>
        {/if}
        {/foreach}
        </div>
    {/if}
    </div>
        {* Galley *}
        {assign var=galleys value=$publication->getData('galleys')}
        <section class="cta text-center">
        {if $galleys|@count}
        {foreach from=$galleys item=galley}
            {if $galley->getFileType() == 'application/pdf'}
                <p>Access the full text by clicking the button below.</p>
                <a class="center" href="{url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId()}">Read Full Text <img src="{$baseUrl}/plugins/themes/sahadeva/images/pdf.png" /></a>
                {break}
            {/if}
        {/foreach}
        {else}
            <p>No full text available.</p>
        {/if}
        </section>

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
    <div class="article-publication-info">
        {* Volume Info *}
        <div class="label">Found In Issue</div>
        <div class="section-text">
            <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
                {if $issue->getVolume()}
                    <span>Vol. {$issue->getVolume()}</span>
                {/if}
                {if $issue->getNumber()}
                    <span>No. {$issue->getNumber()}</span>
                {/if}
                {if $issue->getYear()}
                    <span>, {$issue->getYear()}</span>
                {/if}
            </a>
        </div>
        {* Article Section *}
        {if $section}
        <div class="label">Section</div>
        <div class="section-text">{$section->getLocalizedTitle()|escape}</div>
        {/if}
        <div class="label">Article History</div>
        <div class="section-text">
            <ul class="process-meta">
            {if $submissionDate}
                <li><b>Submitted:</b> {$submissionDate|date_format:"%B %e, %Y"}</li>
            {/if}
            {if $acceptanceDate}
                <li><b>Accepted:</b> {$acceptanceDate|date_format:"%B %e, %Y"}</li>
            {/if}
            {if $publishDate}
                <li><b>Published:</b> {$publishDate|date_format:"%B %e, %Y"}</li>
            {/if}
            </ul>
        </div>
        {* DOI *}
        {if $publication->getStoredPubId('doi')}
        <div class="label">DOI</div>
        <div class="section-text doi-section">
            <icon data-type="doi"></icon>
            <a href="https://doi.org/{$publication->getStoredPubId('doi')}">{$publication->getStoredPubId('doi')}</a>
        </div>
        {/if}
        {* Licensing Info *}
        {if $publication->getLocalizedData('copyrightHolder')}
        <div class="label">Licensing Terms</div>
        <div class="section-text">
            {assign var=licenseTerms value=$currentContext->getLocalizedData('licenseTerms')}
            © {$publishDate|date_format:"Y"} {$publication->getLocalizedData('copyrightHolder')}
            {$licenseTerms}
        </div>
        {/if}
        {* How to Cite *}
        {if $citation}
        <div class="label">{translate key="submission.howToCite"}</div>
        <div class="section-text">
            {$citation}
        </div>
        {/if}
        <div class="extra-content">
            {call_hook name="Templates::Article::Details"}
        </div>
    </div>
    {/capture}

    {include file="frontend/objects/content.tpl" sidebarDisabled=true theContext=article}

    <section class="footer-content">
        {call_hook name="Templates::Article::Footer::PageFooter"}
    </section>

</div>

{include file="frontend/components/footer.tpl"}
