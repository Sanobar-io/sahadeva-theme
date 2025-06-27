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
*}
<ul class="articles-wrapper">
{foreach name=articles from=$articles item=article}
    {assign var=id value=$article->getBestId()}
    <li>
        <div class="meta">
            <h3 class="text-wrapper"><a href="{url page="article" op="view" path=$id}">{$article->getLocalizedTitle()|strip_unsafe_html}</a></h3>
            <div class="meta-info">
                {assign var=views value=$submissionIdsByViews[$id]|default:0}
                
                <div class="clickable see-views" data-text="Viewed {$views} times">
                <icon data-type="eye"></icon>
                    {if $views}
                    {$views|viewcount}
                    {else}
                    0
                    {/if}
                </div>
                <div class="sharelink clickable" data-url="{url page="article" op="view" path=$id}">
                    <icon data-type="share"></icon>Share
                </div>
            </div>
        </div>
        <div class="author-date">
            {$article->getAuthorString()|escape} •
            <span class="date">{$article->getDatePublished()|escape|date_format:"%B %e, %Y"}</span>
        </div>
        <div class="description">
            {$article->getLocalizedAbstract()|strip_tags}
        </div>
    </li>
{/foreach}
</ul>