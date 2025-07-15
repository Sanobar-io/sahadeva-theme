{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3.
*
* This is the template for the disclaimer that appears in the bottom of free version of Sahadeva
*
* @template sahadeva:frontend/pages/indexSite.tpl
*}

{include file="frontend/components/header.tpl"}

<div class="page page_index_site">

	{if $about}
		<div class="about_site">
			{$about}
		</div>
	{/if}

	<div class="journals">
		<h2>
			{translate key="context.contexts"}
		</h2>
		{if !$journals|@count}
			{translate key="site.noJournals"}
		{else}
			<ul>
				{foreach from=$journals item=journal}
					{capture assign="url"}{url journal=$journal->getPath()}{/capture}
					{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
					{assign var="description" value=$journal->getLocalizedDescription()}
					<li{if $thumb} class="has_thumb"{/if}>
						{if $thumb}
							<div class="thumb">
								<a href="{$url|escape}">
									<img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"{if $thumb.altText} alt="{$thumb.altText|escape|default:''}"{/if}>
								</a>
							</div>
						{/if}

						<div class="body">
							<h3>
								<a href="{$url|escape}" rel="bookmark">
									{$journal->getLocalizedName()|escape}
								</a>
							</h3>
							{if $description}
								<div class="description">
									{$description}
								</div>
							{/if}
							<ul class="links">
								<li class="view">
									<a href="{$url|escape}">
										{translate key="site.journalView"}
									</a>
								</li>
								<li class="current">
									<a href="{url|escape journal=$journal->getPath() page="issue" op="current"}">
										{translate key="site.journalCurrent"}
									</a>
								</li>
							</ul>
						</div>
					</li>
				{/foreach}
			</ul>
		{/if}
	</div>

</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
