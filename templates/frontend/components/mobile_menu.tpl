<div id="mobile-menu">
    {load_menu name="user" id="user-nav"}

    <div class="search">
        <form class="search-form" method="get" action="{url page='search' op='search'}">
            <input type="text" id="query" name="query" value="{$query|escape}" class="query" placeholder="{translate|escape key="common.search"}">
            <button class="submit" type="submit">{translate key="common.search"}</button>   
        </form>
    </div>

    {load_menu name="primary" id="primary-nav" ulClass="sahadeva-primarynav"}

    <div class="footer">

        <ul class="social-media">
        {if $activeTheme->getOption('instagram')}
            <li><a href="http://instagram.com/{$activeTheme->getOption('instagram')}" target="_blank"><img class="icon" src="/plugins/themes/sahadeva/images/instagram-social.png" /></a></li>
        {/if}
        {if $activeTheme->getOption('tiktok')}
            <li><a href="http://tiktok.com/@{$activeTheme->getOption('tiktok')}" target="_blank"><img class="icon" src="/plugins/themes/sahadeva/images/tiktok-social.png" /></a></li>
        {/if}
        {if $activeTheme->getOption('facebook')}
            <li><a href="https://facebook.com/profile.php?id={$activeTheme->getOption('facebook')}" target="_blank"><img class="icon" src="/plugins/themes/sahadeva/images/facebook-social.png" /></a></li>
        {/if}
        </ul>

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
    </div>
</div>
<div id="defocus"></div>