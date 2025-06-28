{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3.
*
* This template overrides the default article list layout
* to match the Sahadeva theme design.
*
* @template sahadeva:frontend/components/article_list.tpl
* @param $articles an array of Submission objects
* @param 
*}
<ul class="articles-wrapper">
{foreach name=articles from=$articles item=article}
    {assign var=id value=$article->getBestId()}
    {assign var=publication value=$article->getCurrentPublication()}
    {assign var=title value=$article->getLocalizedTitle()|strip_unsafe_html}
    {assign var=views value=$submissionIdsByViews[$id]|default:0}
    {assign var=doi value=$publication->getStoredPubId('doi')}
    {assign var=authorString value=$article->getAuthorString()|escape}
    {assign var=publishedDate value=$article->getDatePublished()|escape|date_format:"%B %e, %Y"}
    {assign var=abstract value=$article->getLocalizedAbstract()|strip_tags}

    <li>
        <div class="meta">
            <h3 class="text-wrapper"><a href="{url page="article" op="view" path=$id}">{$article->getLocalizedTitle()|strip_unsafe_html}</a></h3>
        </div>
        <div class="author-date">
            {$article->getAuthorString()|escape} •
            <span class="date">{$article->getDatePublished()|escape|date_format:"%B %e, %Y"}</span>
        </div>
        <div class="meta-info">
            <div class="clickable">
                <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
                    {$issue->getIssueIdentification()|escape}
                </a>
            </div>
            {if $doi}
            <div class="the-doi">
                <icon data-type="doi"></icon>
                <a href="https://doi.org/{$doi}" target="_blank" rel="noopener">https://doi.org/{$doi}</a>
            </div>
            {/if}
            <div class="clickable see-views" data-text="Viewed {$views} times">
                <icon data-type="eye"></icon>
                    {$views|viewcount}
            </div>
            <div class="sharelink clickable" data-url="{url page="article" op="view" path=$id}">
                <icon data-type="share"></icon>Share
            </div>
        </div>
        <div class="description">
            {$article->getLocalizedAbstract()|strip_tags}
        </div>
    </li>
{/foreach}
</ul>