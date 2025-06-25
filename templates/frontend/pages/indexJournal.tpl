{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 * @uses $issue Issue Current issue
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page">

    {if $announcements|@count}

    <section class="announcements">
        <div class="announcements-wrapper">
        {foreach name=announcements from=$announcements item=announcement}
            {if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
                {break}
            {/if}
            {if $smarty.foreach.announcements.iteration == 1}
            <div class="announcements-card">
                <h3>
                    <a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}">
                        {$announcement->getLocalizedTitle()|escape}
                    </a>
                </h3>
                {$announcement->getLocalizedDescriptionShort()|strip_unsafe_html}
                <span class="read-more" aria-hidden="true" role="presentation">
                    <a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->getId()}">
                        {translate key="common.readMore"}
                    </a>
                </span>
            </div>
            {/if}
        {/foreach}
        </div>
    </section>

    {/if}

    <main class="sahadeva-main column-wrapper ">
        <div class="col-left">
            <div class="about">
                <h2 class="about-label">
                    About
                    <div class="jakpp">{$currentJournal->_data.abbreviation.en_US}</div>
                </h2>
                <p>{$currentContext->getLocalizedData('description')}</p>
                <a class="cta-arrow" href="{url page='about'}">Read More</a>
            </div>
            {load_menu name="belowAbout" id="belowAbout-nav"}
        </div>
        <div class="col-right">

            <div class="current-issue">
                {* Check If Issue Exists *}
                {if $issue}

                <div class="metabox">
                    <h2 class="label">{translate key="plugins.themes.sahadeva.currentIssue"}</h2>
                    <div class="issue-info">
                        Volume {$currentIssue->getVolume()} | Number {$currentIssue->getNumber()} | {$currentIssue->getYear()}
                    </div>
                </div>
                <div class="issue-details">
                    <div class="overview">
                    {if $issue}
                        <a href="{url page="issue"}">
                            <img src="{$currentIssue->getLocalizedCoverImageUrl()}" />
                        </a>
                    {/if}
                        <div class="overview-ctas">
                            <a class="cta-rounded" href="{url page='about' op='submissions'}">Author Guidelines</a>
                            <a class="cta-rounded" href="{url page='submission' op='wizard'}">{translate key="plugins.themes.sahadeva.submitManuscript.label"}</a>
                        </div>
                    </div>
                    <div class="articles-wrapper">
                    {if $issue}

                    {foreach name=sections from=$publishedSubmissions item=section}
                        {foreach name=articles from=$section.articles item=article}
                            {if $smarty.foreach.articles.iteration > 5}
                                {break}
                            {/if}
                            {include file="frontend/objects/article_summary.tpl" heading=$articleHeading}
                        {/foreach}
                    {/foreach}

                        <a class="cta-arrow" href="{url page="issue"}">{translate key="plugins.themes.sahadeva.viewTOC"}</a>

                    {/if}
                    </div>
                </div>

                {else}
                    <h2>No Issues Published</h2>
                {/if}
            </div>
            
        </div>
    </main>

    {capture assign=leftCol}
        {if $topViewedArticles}
            <h2>Most Viewed Articles</h2>
            {assign var=articles value=array_column($topViewedArticles, 'article')}
            {assign var=views value=array_column($topViewedArticles, 'views')}
            {include file="frontend/components/article_list.tpl" articles=$articles views=$views}
        {/if}
    {/capture}

    {include file="frontend/objects/content.tpl"}

    <section class="additional-content">
    {if $activeTheme->getOption('leftColTextFieldHeading')}

    <h2>{$activeTheme->getOption('leftColTextFieldHeading')}</h2>

    {/if}
        {$additionalHomeContent}
    </section>

    {if $activeTheme->getOption('aboveFooterCtaHeading') || $activeTheme->getOption('aboveFooterCtaContent')}

    <section class="abovefooter-cta">
    {if $activeTheme->getOption('aboveFooterCtaHeading')}                
        <h2>{$activeTheme->getOption('aboveFooterCtaHeading')}</h2>
    {/if}
    {if $activeTheme->getOption('aboveFooterCtaContent')}
        <p>{$activeTheme->getOption('aboveFooterCtaContent')}</p>
    {/if}
    <a class="cta-rounded" href="{url page='submission' op='wizard'}">{translate key="plugins.themes.sahadeva.submitManuscript.label"}</a>
    </section>

    {/if}

</div>

{include file="frontend/components/footer.tpl"}
