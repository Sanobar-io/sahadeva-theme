<div id="popup">
    <div class="popup-inner text-wrapper">
        <h1>
            {if $currentJournal->_data.abbreviation.en_US}
                {$currentJournal->_data.abbreviation.en_US}
            {else}
                {$currentContext->getLocalizedName()}
            {/if}<br/>
            is using the free version of Sahadeva Theme
        </h1>
        <a id="view-ad" class="cta-rounded">Close (View Ad)</a>
        <a href="mailto:hello@komkom.id" class="buy">Purchase the full version and <b>remove all ads forever</b></a>
        <p>The free version is supported by ad revenue. Click the button above to support <a href="https://github.com/Sanobar-io" target="_blank">Sanobar</a> by viewing an ad.</p>
        <small>© 2025. <a href="https://github.com/Sanobar-io" target="_blank">Developed by Sanobar</a>.</small>
    </div>
</div>