{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3. See the COPYING file in the OJS root.
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
                {assign var=views value=$submissionIdsByViews[$id]}
                {if $views}

                <div>
                    <icon data-type="views"></icon>
                    {$views}
                </div>

                {/if}
                <div class="sharelink clickable" data-url="{url page="article" op="view" path=$id}">
                    <icon data-type="link"></icon>Share
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