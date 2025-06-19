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

<main class="sahadeva-main inner-wrapper column-wrapper ">
    <div class="col-left">
        <div class="about">
            <h2 class="about-label">
                About
                <div class="jakpp">JAKPP</div>
            </h2>
            <p>{$currentContext->getLocalizedData('description')}</p>
            <a class="cta-arrow" href="{url page='about'}">Aims & Scope</a>
        </div>
        <div class="team-container">
            <a href="{url page='about' op='editorialTeam'}">Editorial Team</a>
            <a href="{url page='about' op='editorialTeam'}">Reviewers</a>
        </div>
    </div>
    <div class="col-right">
        <div class="current-issue">
            <div class="metabox">
                <h2 class="label">Current Issue</h2>
                <div class="issue-info">
                    Volume {$currentIssue->getVolume()} | Number {$currentIssue->getNumber()} | {$currentIssue->getYear()}
                </div>
            </div>
            <div class="issue-details">
                <div class="overview">
                {if $issue}
                    <img src="{$issue->getLocalizedCoverImageUrl()}" />
                {/if}
                    <div class="overview-ctas">
                        <a class="cta-rounded" href="{url page='about' op='submissions'}">Author Guidelines</a>
                        <a class="cta-rounded" href="{url page='submissions' op='start'}">Submit Manuscript</a>
                    </div>
                </div>
                <div class="articles"></div>
            </div>
        </div>
    </div>
</main>

<section class="sahadeva-secondary inner-wrapper column-wrapper ">
    <div class="col-left">
        <div class="custom-content">
            {if $activeTheme->getOption('leftColTextFieldHeading')}
                <h2 class="label">{$activeTheme->getOption('leftColTextFieldHeading')}</h2>
            {/if}
            {$additionalHomeContent}
        </div>
    </div>
    <div class="col-right">
    </div>
</section>

{if $activeTheme->getOption('aboveFooterCtaHeading') || $activeTheme->getOption('aboveFooterCtaContent')}

<section class="abovefooter-cta inner-wrapper">
{if $activeTheme->getOption('aboveFooterCtaHeading')}                
    <h2>{$activeTheme->getOption('aboveFooterCtaHeading')}</h2>
{/if}
{if $activeTheme->getOption('aboveFooterCtaContent')}
    <p>{$activeTheme->getOption('aboveFooterCtaContent')}</p>
{/if}
<a class="cta-rounded" href="{url page='submissions' op='start'}">Submit Manuscript</a>
</section>

{/if}

{include file="frontend/components/footer.tpl"}
