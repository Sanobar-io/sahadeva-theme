{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

{* Header *}
{call_hook name="Templates::Index::journal"}
<header class="sahadeva-header" role="banner"
    {if $activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
        style="background-image: url('{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"};');"
    {/if}
>
    <div class="header-inner">

        <div class="burger-menu">
            <button class="burger-menu-btn">
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

		{* Wrapper for page content and sidebars *}
		{* {if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a> *}
