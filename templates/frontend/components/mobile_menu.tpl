<div id="mobile-menu">
    {if $isUserLoggedIn}
        <ul id="user-nav-logged">
            <li>
                <div class="name">
                    <a href="{url page="submissions"}">{$loggedInUsername|escape}</a>
                    <button id="admin-expand-btn" data-expanded="false"></button>
                    </div>
                <ul id="user-expanded">
                    <li><a href="{url page="submissions"}">Dashboard</a></li>
                    <li><a href="{url page="user" op="profile"}">View Profile</a></li>
                </ul>
            </li>
        </ul>
    {else}
        {load_menu name="user" id="user-nav"}
    {/if}

    <div class="search">
        <form class="search-form" method="get" action="{url page='search' op='search'}">
            <input type="text" id="query" name="query" value="{$query|escape}" class="query" placeholder="{translate|escape key="common.search"}">
            <button class="submit" type="submit">{translate key="common.search"}</button>   
        </form>
    </div>

    {load_menu name="primary" id="primary-nav" ulClass="sahadeva-primarynav"}

    <div class="footer">
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
        <ul class="contact-info">
        {if $currentJournal->getData('contactPhone')}
            <li>Phone:<br />
            {$currentJournal->getData('contactPhone')}</li>
        {/if}
        {if $currentJournal->getData('contactEmail')}
            <li>Email:<br/>
            <a href="mailto:{$currentJournal->getData('contactEmail')}"> {$currentJournal->getData('contactEmail')}</a></li>
        {/if}
        </ul>
        {assign var=instagram value=$activeTheme->getOption('instagram')}
        {assign var=tiktok value=$activeTheme->getOption('tiktok')}
        {assign var=facebook value=$activeTheme->getOption('facebook')}
        {if ($instagram || $tiktok || $facebook)}
        <ul class="social-media">
            <li><b>{translate key='plugins.themes.sahadeva.footer.followUs'}</b></li>
        {if $instagram}
            <li><a href="http://instagram.com/{$instagram}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/instagram-social.png" /></a></li>
        {/if}
        {if $tiktok}
            <li><a href="http://tiktok.com/@{$tiktok}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/tiktok-social.png" /></a></li>
        {/if}
        {if $facebook}
            <li><a href="https://facebook.com/profile.php?id={$facebook}" target="_blank"><img class="icon" src="{$baseUrl}/plugins/themes/sahadeva/images/facebook-social.png" /></a></li>
        {/if}
        </ul>
        {/if}
    </div>
</div>
<div id="defocus"></div>