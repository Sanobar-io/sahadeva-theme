{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3. See the COPYING file in the OJS root.
*
* This is the style for the Above Footer CTA.
*
* @template sahadeva:frontend/components/abovefooter_cta.tpl
* @uses $announcement Announcement The announcement to display
*}

{if $activeTheme->getOption('aboveFooterCtaHeading') || $activeTheme->getOption('aboveFooterCtaContent')}

<section class="abovefooter-cta">
{if $activeTheme->getOption('aboveFooterCtaHeading')}                
    <h2>{$activeTheme->getOption('aboveFooterCtaHeading')}</h2>
{/if}

{if $activeTheme->getOption('aboveFooterCtaContent')}
    <p>{$activeTheme->getOption('aboveFooterCtaContent')}</p>
{/if}

{if $activeTheme->getOption('aboveFooterCtaButtonText') && $activeTheme->getOption('aboveFooterCtaButtonUrl')}
    <a class="cta-rounded" href="{$activeTheme->getOption('aboveFooterCtaButtonUrl')}">{$activeTheme->getOption('aboveFooterCtaButtonText')}</a>
{/if}

</section>

{/if}