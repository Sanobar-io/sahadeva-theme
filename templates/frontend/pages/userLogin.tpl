{**
 * templates/frontend/pages/userLogin.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * User login form.
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

<div class="page login-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login"}

	{capture assign=leftCol}

	<h1>
		{translate key="user.login"}
	</h1>
	{* A login message may be displayed if the user was redireceted to the
	   login page from another request. Examples include if login is required
	   before dowloading a file. *}
	{if $loginMessage}
		<p>
			{translate key=$loginMessage}
		</p>
	{/if}

	<div class="welcome text-wrapper center">

	<p>Welcome to the manuscript submission and review portal for authors, reviewers, and editors of
	{if $currentContext}
		{$currentContext->getLocalizedName()}
	{else}
		{$siteTitle}
	{/if}
	</p>

	<p>After signing in or creating an account, you may:</p>

    <ul>
		<li>Submit a new manuscript or letter to the editor</li>
		<li>Submit an invited or revised manuscript</li>
		<li>Continue working on an in-progress submission</li>
		<li>Track the progress of submitted manuscripts</li>
		<li>Access manuscripts assigned to you as a reviewer and complete your review</li>
		<li>Access manuscripts assigned to you as an editor or advisor and complete your evaluation</li>
	</ul>

	<p>We sincerely thank you for contributing to the advancement of knowledge by submitting your work to our journal and supporting the peer review process.</p>

	<p>
	{if $currentContext}
		{$currentContext->getLocalizedName()}
	{else}
		{$siteTitle}
	{/if}
	is committed to promoting scholarly excellence by supporting researchers, educators, and practitioners through rigorous peer-reviewed publishing and open academic collaboration.</p>

	</div>

	{/capture}

	{capture assign=rightCol}
		<form class="login text-wrapper center cmp_form" id="login" method="post" action="{$loginUrl}">
			{csrf}

			{if $error}
				<div class="pkp_form_error">
					{translate key=$error reason=$reason}
				</div>
			{/if}

			<input type="hidden" name="source" value="{$source|default:""|escape}" />

			<fieldset class="fields">
				<div class="username">
					<label>
						<span class="label">
							{translate key="user.username"}
							<span class="required" aria-hidden="true">*</span>
							<span class="pkp_screen_reader">
								{translate key="common.required"}
							</span>
						</span>
					</label>
					<input type="text" name="username" id="username" value="{$username|default:""|escape}" maxlength="32" required aria-required="true">
				</div>
				<div class="password">
					<label>
						<span class="label">
							{translate key="user.password"}
							<span class="required" aria-hidden="true">*</span>
							<span class="pkp_screen_reader">
								{translate key="common.required"}
							</span>
						</span>
						<input type="password" name="password" id="password" value="{$password|default:""|escape}" password="true" maxlength="32" required aria-required="true">
						</label>
				</div>
				<div class="lostPassword">
				<small>
					<a href="{url page="login" op="lostPassword"}">
						{translate key="user.login.forgotPassword"}
					</a>
				</small>
				</div>
				<div class="remember checkbox">
					<label>
						<input type="checkbox" name="remember" id="remember" value="1" checked="$remember">
						<span class="label">
							{translate key="user.login.rememberUsernameAndPassword"}
						</span>
				</label>
			</div>
			<div class="buttons">
				<button class="submit" type="submit">
					{translate key="user.login"}
				</button>

				{if !$disableUserReg}
					{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
					<a href="{$registerUrl}" class="register">
						{translate key="user.login.registerNewAccount"}
					</a>
				{/if}
			</div>
		</fieldset>
	</form>
	{/capture}

	{include file="frontend/objects/content.tpl" sidebarDisabled=True}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
