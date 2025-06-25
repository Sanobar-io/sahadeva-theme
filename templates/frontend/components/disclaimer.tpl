<div id="popup">
    <div class="popup-inner text-wrapper center">
        <h1>
            {if $currentJournal->_data.abbreviation.en_US}
                {$currentJournal->_data.abbreviation.en_US}
            {else}
                {$currentContext->getLocalizedName()}
            {/if}
            is using the free version of Sahadeva Theme
        </h1>

        <p>Click the button below to close this popup and support the developers by viewing an ad.</p>

        <a id="view-ad" class="cta-rounded">Close (View Ad)</a>
        <a href="mailto:hello@sanobario.com" class="buy">Purchase the full version and <b>remove all ads forever</b></a>        
        
        <small>© 2025 <a href="https://sanobario.com" target="_blank">Sanobario</a>.</small>
    </div>
</div>