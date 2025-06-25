{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3. See the COPYING file in the OJS root.
*
* This is the template for the disclaimer that appears in the bottom of free version of Sahadeva
*
* @template sahadeva:frontend/components/article_list.tpl
*}
<div id="popup">
    <div class="popup-inner center">
        <div>
            <b>
            {if $currentJournal->_data.abbreviation.en_US}
                {$currentJournal->_data.abbreviation.en_US}
            {else}
                {$currentContext->getLocalizedName()}
            {/if}
            is using the free version of Sahadeva Theme.
            </b> Click the button to close this and support the developers by viewing an ad.
        </div>
        <a id="view-ad" class="cta-rounded">Close (View Ad)</a>     
        <div><a href="mailto:hello@sanobario.com" class="buy">Purchase the full version and <b>remove all ads forever</b></a>.</div>
    </div>
</div>