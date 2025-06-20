<?php

/**
 * @file plugins/themes/default/SahadevaThemePlugin.inc.php
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SahadevaThemePlugin
 * @ingroup plugins_themes_default
 *
 * @brief Default theme
 */

import('lib.pkp.classes.plugins.ThemePlugin');

class SahadevaThemePlugin extends ThemePlugin {
	/**
	 * Initialize the theme's styles, scripts and hooks. This is only run for
	 * the currently active theme.
	 *
	 * @return null
	 */
	public function init() {
		
		// add styles
		$this->addStyle('stylesheet', 'styles/sahadeva.less');

		$bgBase = $this->getOption('bg-base');

		$this->modifyStyle(
			'stylesheet',
			[
				'addLessVariables' =>
					"@bg-base: $bgBase;",
				]
		);

		// add scripts
		$this->addScript('sahadeva-script', 'js/sahadeva.js');

		// add navs
		$this->addMenuArea(array('primary', 'user', 'footer'));

		// add options

		$this->addOption('bg-base', 'FieldColor', [
			'label' => __('plugins.themes.sahadeva.option.color.label'),
			'description' => __('plugins.themes.sahadeva.option.color.description'),
			'default' => '#1E6292',
		]);
		
		$this->addOption('leftColTextFieldHeading', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.leftColTextFieldHeading.label'),
		]);

		$this->addOption('issnPrint', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.issnPrint.label'),
		]);

		$this->addOption('issnElectronic', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.issnElectronic.label'),
		]);

		$this->addOption('aboveFooterCtaHeading', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.aboveFooterCtaHeading.label'),
		]);

		$this->addOption('aboveFooterCtaContent', 'FieldRichTextarea', [
			'label' => __('plugins.themes.sahadeva.option.aboveFooterCtaContent.label'),
		]);

		$this->addOption('additionalFooterInfo', 'FieldRichTextarea', [
			'label' => __('plugins.themes.sahadeva.option.additionalFooterInfo.label'),
			'description' => __('plugins.themes.sahadeva.option.additionalFooterInfo.description')
		]);

		// Social media options
		$this->addOption('instagram', 'FieldText', [
			'label' => 'Instagram',
		]);

		$this->addOption('tiktok', 'FieldText', [
			'label' => 'TikTok',
		]);

		$this->addOption('facebook', 'FieldText', [
			'label' => 'Facebook',
		]);

		HookRegistry::register('TemplateManager::display', [$this, 'loadCurrentIssue']);

	}

	/**
	 * Get the latest issue object
	 * @return bool
	 */
	public function loadCurrentIssue($hookName, $args)
	{
		$templateMgr = $args[0];
		$request = Application::get()->getRequest();
		$journal = $request->getContext();

		if ($journal) {
			$issueDao = DAORegistry::getDAO('IssueDAO');
			$currentIssue = $issueDao->getCurrent($journal->getId(), true);
			$templateMgr->assign('currentIssue', $currentIssue);
		}

		return false;
	}

	/**
	 * Get the display name of this plugin
	 * @return string
	 */
	function getDisplayName() {
		return __('plugins.themes.sahadeva.name');
	}

	/**
	 * Get the description of this plugin
	 * @return string
	 */
	function getDescription() {
		return __('plugins.themes.sahadeva.description');
	}
}

?>
