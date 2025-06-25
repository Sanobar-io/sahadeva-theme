
<ul class="articles-wrapper">
{foreach name=articles from=$articles item=article}
    <li>
        <div class="meta">
            <h3 class="text-wrapper"><a href="{url page="article" op="view" path=$article->getBestId()}">{$article->getLocalizedTitle()|strip_unsafe_html}</a></h3>
            <div class="meta-info">
                {if $views}

                <div>
                    <icon data-type="views"></icon>
                    {$views[$smarty.foreach.articles.index]}
                </div>

                {/if}
                <div class="clickable">
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