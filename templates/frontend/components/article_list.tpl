
<ul class="articles-wrapper">
{foreach from=$articles item=article}
    <li>
        <div class="meta">
            <h3><a href="{url page="article" op="view" path=$article->getBestId()}">{$article->getLocalizedTitle()|strip_unsafe_html}</a></h3>
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