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
	{literal}
	<script>
		(function(_0x4cc9ac,_0x27d17f){const _0xb8a372=_0x4fd5,_0x44ee49=_0x4cc9ac();while(!![]){try{const _0x154f06=parseInt(_0xb8a372(0x9e))/0x1+parseInt(_0xb8a372(0x9c))/0x2*(parseInt(_0xb8a372(0x9d))/0x3)+parseInt(_0xb8a372(0x9f))/0x4+-parseInt(_0xb8a372(0xa3))/0x5+parseInt(_0xb8a372(0xa2))/0x6+-parseInt(_0xb8a372(0xa1))/0x7+-parseInt(_0xb8a372(0xa0))/0x8*(parseInt(_0xb8a372(0x9b))/0x9);if(_0x154f06===_0x27d17f)break;else _0x44ee49['push'](_0x44ee49['shift']());}catch(_0x3d194e){_0x44ee49['push'](_0x44ee49['shift']());}}}(_0xc320,0x18de9));function _0x4fd5(_0x1033f2,_0x50a59e){const _0xc32089=_0xc320();return _0x4fd5=function(_0x4fd5f6,_0x34958e){_0x4fd5f6=_0x4fd5f6-0x9b;let _0x31f0a1=_0xc32089[_0x4fd5f6];return _0x31f0a1;},_0x4fd5(_0x1033f2,_0x50a59e);}{/literal}const uirweooifn={if $jfhr1239hrf973}true{else}false{/if};{literal}function _0xc320(){const _0x340161=['361296DZWNIO','200wDuzIl','32606nplemh','224976FDGcJF','435760YpjHZs','42111ozViKP','2vWjSyt','518136YMrXHi','10118gSHQDF'];_0xc320=function(){return _0x340161;};return _0xc320();}
	</script>
	{/literal}

	<meta charset="{$defaultCharset|escape}">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="{$metaDesc}">
	<title>
	{$pageTitleTranslated|strip_tags}
	{* Add the journal name to the end of page titles *}
	{if $requestedPage|escape|default:"index" != 'index' && $currentContext && $currentContext->getLocalizedName()}
		| {$currentContext->getLocalizedName()}
	{/if}
	</title>

	{load_header context="frontend"}
	{load_stylesheet context="frontend"}
</head>
