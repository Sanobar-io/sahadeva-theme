{**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3.
*
* Show Reviewers and Editors checkbox in backend
*
* @template sahadeva:frontend/components/showReviewersAndEditors.tpl
*}
<div class="form-group">
    <label>
        <input type="checkbox" name="show_reviewers" value="1"
               {if $show_reviewers}checked="checked"{/if} />
        Show Reviewers
    </label>
</div>
<div class="form-group">
    <label>
        <input type="checkbox" name="show_editors" value="1"
               {if $show_editors}checked="checked"{/if} />
        Show Editors
    </label>
</div>