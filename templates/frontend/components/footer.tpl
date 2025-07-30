{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3.
*
* This is the template for the footer that appears in the bottom of free version
* of Sahadeva
*
* @template sahadeva:frontend/components/footer.tpl
*}
<footer class="sahadeva-footer">
    <div class="footer-inner inner-wrapper">
        <div class="left-col">

            {* Footer Logo *}
            <div class="site-name">
            {capture assign="homeUrl"}
                {url page="index" router=$smarty.const.ROUTE_PAGE}
            {/capture}
            {if $displayPageHeaderTitle}
                <a href="{$homeUrl}" class="is_text footer-journal-name">{$displayPageHeaderTitle|escape}</a>
            {/if}
            </div>

            {* Address *}
            {if $currentJournal && $currentJournal->getData('mailingAddress')}
            <ul class="address-info">
                <li>{$currentJournal->getData('mailingAddress')}</li>
                </ul>
            {/if}
            
            {* ISSN Numbers *}
            {if ($activeTheme->getOption('issnPrint') || $activeTheme->getOption('issnElectronic'))}
            <ul class="issn-info">
            {if $activeTheme->getOption('issnPrint')}
                <li>ISSN Print: <a href="https://portal.issn.org/resource/ISSN/{$activeTheme->getOption('issnPrint')}" target="_blank">{$activeTheme->getOption('issnPrint')}</a></li>
            {/if}
            {if $activeTheme->getOption('issnElectronic')}
                <li>ISSN Online: <a href="https://portal.issn.org/resource/ISSN/{$activeTheme->getOption('issnElectronic')}" target="_blank">{$activeTheme->getOption('issnElectronic')}</a></li>
            {/if}
            </ul>
            {/if}

            {* Contact Info *}
            {if $currentJournal && ($currentJournal->getData('supportPhone') || $currentJournal->getData('supportEmail'))}
            <ul class="contact-info">
            {if $currentJournal->getData('supportPhone')}
                <li>{$currentJournal->getData('supportPhone')}</li>
            {/if}
            {if $currentJournal->getData('supportEmail')}
                <li><a href="mailto:{$currentJournal->getData('supportEmail')}">{$currentJournal->getData('supportEmail')}</a></li>
            {/if}
            </ul>
            {/if}

            <ul class="social-media">
            {assign var=instagram value=$activeTheme->getOption('instagram')}
            {assign var=tiktok value=$activeTheme->getOption('tiktok')}
            {assign var=facebook value=$activeTheme->getOption('facebook')}
            {if ($instagram || $tiktok || $facebook)}
                <li><b>{translate key='plugins.themes.sahadeva.footer.followUs'}</b></li>
            {/if}
            {if $instagram}
                <li><a href="http://instagram.com/{$activeTheme->getOption('instagram')}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/instagram-social.png" /></a></li>
            {/if}
            {if $tiktok}
                <li><a href="http://tiktok.com/@{$activeTheme->getOption('tiktok')}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/tiktok-social.png" /></a></li>
            {/if}
            {if $facebook}  
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