{**
 * sahadeva/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showDatePublished bool Show the date this article was published?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 * @uses $heading string HTML heading element, default: h2
 *}

{assign var=articlePath value=$article->getBestId()}
{assign var=publication value=$article->getCurrentPublication()}
{assign var=views value=$submissionIdsByViews[$id]|default:0}
{assign var=doi value=$publication->getStoredPubId('doi')}
{assign var=abstract value=$article->getLocalizedAbstract()|strip_tags}
{assign var=pages value=$publication->getData('pages')}

<div class="article-card">
	<div class="meta">
		<div class="authors">{$article->getAuthorString()|escape}</div>
		<span class="pages">pp. {$pages}</span>
	</div>
	<h3>
		<a href="{url page="article" op="view" path=$articlePath}">
			{$article->getLocalizedTitle()|strip_unsafe_html}
		</a>
	</h3>
	<div class="meta-info">
		{if $doi}
		<div class="the-doi clickable tab">
			<icon data-type="doi"></icon>
			<a href="https://doi.org/{$doi}" target="_blank" rel="noopener">{$doi}</a>
		</div>
		{/if}
		<div class="clickable tab sharelink" data-url="{url page="article" op="view" path=$id}">
			<icon data-type="share"></icon>
				Share This
		</div>
	</div>
</div>