{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3. See the COPYING file in the OJS root.
*
* This is the template for the disclaimer that appears in the bottom of free version
* of Sahadeva
*
* @template sahadeva:frontend/components/footer.tpl
*}
<footer class="sahadeva-footer">
    <div class="footer-inner inner-wrapper">
        <div class="left-col">
            <div class="site-name">
            {capture assign="homeUrl"}
                {url page="index" router=$smarty.const.ROUTE_PAGE}
            {/capture}
            {if $displayPageHeaderLogo}
                <a href="{$homeUrl}" class="is_img">
                    <img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if} />
                </a>
            {elseif $displayPageHeaderTitle}
                <a href="{$homeUrl}" class="is_text">{$displayPageHeaderTitle|escape}</a>
            {else}
                <a href="{$homeUrl}" class="is_img">
                    <img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />
                </a>
            {/if}
            </div>
            <ul class="address-info">
            {if $currentJournal->getData('mailingAddress')}
                <li>{$currentJournal->getData('mailingAddress')}</li>
            {/if}
            {if $activeTheme->getOption('issnPrint')}
                <li>ISSN Print: <a href="https://portal.issn.org/resource/ISSN/{$activeTheme->getOption('issnPrint')}" target="_blank">{$activeTheme->getOption('issnPrint')}</a></li>
            {/if}
            {if $activeTheme->getOption('issnElectronic')}
                <li>ISSN Online: <a href="https://portal.issn.org/resource/ISSN/{$activeTheme->getOption('issnElectronic')}" target="_blank">{$activeTheme->getOption('issnElectronic')}</a></li>
            {/if}
            </ul>
            <ul class="contact-info">
            {if $currentJournal->getData('contactPhone')}
                <li>{$currentJournal->getData('contactPhone')}</li>
            {/if}
            {if $currentJournal->getData('contactEmail')}
                <li><a href="mailto:{$currentJournal->getData('contactEmail')}">{$currentJournal->getData('contactEmail')}</a></li>
            {/if}
            </ul>
            <ul class="social-media">
                <li><b>{translate key='plugins.themes.sahadeva.footer.followUs'}</b></li>
            {if $activeTheme->getOption('instagram')}
                <li><a href="http://instagram.com/{$activeTheme->getOption('instagram')}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/instagram-social.png" /></a></li>
            {/if}
            {if $activeTheme->getOption('tiktok')}
                <li><a href="http://tiktok.com/@{$activeTheme->getOption('tiktok')}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/tiktok-social.png" /></a></li>
            {/if}
            {if $activeTheme->getOption('facebook')}
                <li><a href="https://facebook.com/profile.php?id={$activeTheme->getOption('facebook')}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/facebook-social.png" /></a></li>
            {/if}
            </ul>
        </div>
        <div class="right-col">
            {$pageFooter}
        </div>
    </div>
</div>

{load_script context="frontend"}
{call_hook name="Templates::Common::Footer::PageFooter"}
 
</body>
</html>