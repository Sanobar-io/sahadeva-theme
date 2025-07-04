{**
*
*   templates/frontend/objects/content.tpl
*
*}

<section class="content-wrapper inner-wrapper">
    <div class="col-left">
        {$leftCol}
    </div>
    <div class="col-right">
    {if $rightCol}
    <div class="additionalColContent{if $theContext && $theContext == 'article'} articleAdditional{/if}">
        {$rightCol}
    </div>
    {/if}
    {if !$sidebarDisabled}
        {capture assign="sidebarCode"}
            {call_hook name="Templates::Common::Sidebar"}
        {/capture}
        {if $sidebarCode}
            {$sidebarCode}
        {/if}
    {/if}
    </div>
</section>