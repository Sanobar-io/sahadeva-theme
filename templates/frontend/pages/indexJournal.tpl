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

<main class="sahadeva-main">
    <div class="col-left">
        <div class="about">
            <h2 class="about-label">
                About
                <div class="jakpp">JAKPP</div>
            </h2>
            <p>{$currentContext->getLocalizedData('description')}</p>
        </div>
    </div>
    <div class="col-right">
    </div>
</main>

{include file="frontend/components/footer.tpl"}
