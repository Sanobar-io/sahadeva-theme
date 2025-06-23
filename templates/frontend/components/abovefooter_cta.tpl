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