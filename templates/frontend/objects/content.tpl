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
        {$rightCol}
    {/if}
    {capture assign="sidebarCode"}
        {call_hook name="Templates::Common::Sidebar"}
    {/capture}
    {if $sidebarCode}
        {$sidebarCode}
    {/if}
    </div>
</section>