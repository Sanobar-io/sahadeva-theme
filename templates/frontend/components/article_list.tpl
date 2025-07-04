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
    {assign var=the_index value=$smarty.foreach.articles.iteration}
    {if $limit && $the_index > $limit}
        {break}
    {/if}
    {assign var=id value=$article->getBestId()}
    {assign var=publication value=$article->getCurrentPublication()}
    {assign var=title value=$article->getLocalizedTitle()|strip_unsafe_html}
    {assign var=the_issue value=$allIssues[$publication->getData('issueId')]}
    {if $the_issue}
        {capture assign=issueId}
            {if $the_issue->getVolume()}
                <span>Vol. {$the_issue->getVolume()}</span>
            {/if}
            {if $the_issue->getNumber()}
                <span>No. {$the_issue->getNumber()}</span>
            {/if}
            {if $the_issue->getYear()}
                <span>, {$the_issue->getYear()}</span>
            {/if}
        {/capture}
    {/if}
    {assign var=views value=$submissionIdsByViews[$id]|default:0}
    {assign var=pages value=$publication->getData('pages')}
    {assign var=doi value=$publication->getStoredPubId('doi')}
    {assign var=authorString value=$article->getAuthorString()|escape}
    {assign var=publishedDate value=$article->getDatePublished()|escape|date_format:"%B %e, %Y"}
    {assign var=abstract value=$article->getLocalizedAbstract()|strip_tags}

    <li>
        <div class="meta">
            <h3 class="text-wrapper"><a href="{url page="article" op="view" path=$id}">{$title}</a></h3>
        </div>
        <div class="author-info">
            {$authorString}
        </div>
        <div class="description">
            {$abstract}
        </div>
        <div class="issue-data">
            <span class="date">Published {$article->getDatePublished()|escape|date_format:"%B %e, %Y"}</span>
            {if $the_issue}
                • <span class="issue">Found in <a href="{url page="issue" op="view" path=$the_issue->getBestIssueId()}">{$issueId}</a></span>
                {if $pages}
                <span class="pages">(pp. {$pages})</span>
                {/if}
            {/if}
        </div>
        <div class="meta-info">
            {if $doi}
            <div class="the-doi clickable tab">
                <icon data-type="doi"></icon>
                <a href="https://doi.org/{$doi}" target="_blank" rel="noopener">{$doi}</a>
            </div>
            {/if}
            <div class="clickable tab see-views" data-text="Viewed {$views} times">
                <icon data-type="eye"></icon>
                    {$views|viewcount}
            </div>
            <div class="clickable tab sharelink" data-url="{url page="article" op="view" path=$id}">
                <icon data-type="share"></icon>
                    Share This
            </div>
        </div>
    </li>
{/foreach}
</ul>