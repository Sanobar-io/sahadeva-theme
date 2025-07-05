{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3.
*
* @template sahadeva:frontend/components/footer.tpl
* @brief This is the template for the disclaimer that appears in the bottom of free version of Sahadeva
*}

{* Show Logo/String *}
{strip}
	{assign var="logoExists" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="logoExists" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $logoExists} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

{* Header *}
{call_hook name="Templates::Index::journal"}

<header class="sahadeva-header" role="banner"
    {if $activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
        style="background-image: url('{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"};');"
    {/if}
>
    <div class="header-inner">

        <div class="burger-menu">
            <button id="burger-menu-btn" data-toggle="false">
                <img src="{$baseUrl}/plugins/themes/sahadeva/images/burger-icon.svg" />
            </button>
        </div>

        <div class="primary-nav-wrapper">
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
                        <img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}"/>
                    </a>
                {/if}
            </div>
            {load_menu name="primary" id="primary-nav" ulClass="sahadeva-primarynav"}
        </div>


        <div class="user-nav-wrapper">
            {* Search form *}
            {if $currentContext && $requestedPage !== 'search'}
                <div class="search-wrapper">
                    <a href="{url page="search"}" class="pkp_search pkp_search_desktop">
                        <span class="fa fa-search" aria-hidden="true"></span>
                        <img src="{$baseUrl}/plugins/themes/sahadeva/images/search.svg" />
                    </a>
                </div>
            {/if}
            {load_menu name="user" id="user-nav"}
        </div>

    </div>
    
    </header>

    {include file="frontend/components/mobile_menu.tpl"}

    {call_hook name="Templates::Common::Header::PageHeader"}