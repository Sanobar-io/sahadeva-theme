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
 {assign var=submissionPages value=$publication->getData('pages')}

<div class="article-card">
	<div class="meta">
		<div class="authors">{$article->getAuthorString()|escape}</div>
		<div class="pages">
		{if $submissionPages}
			{$submissionPages}
		{/if}
		</div>
	</div>
	<h3>
		<a href="{url page="article" op="view" path=$articlePath}">
			{$article->getLocalizedTitle()|strip_unsafe_html}
		</a>
	</h3>
</div>