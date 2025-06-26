<?php

/**
 * @file plugins/themes/sahadeva/SahadevaThemePlugin.inc.php
 *
 * Copyright (c) 2014-2016 Simon FsettalUniversity Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class SahadevaThemePlugin
 * @ingroup plugins_themes_default
 *
 * @brief Default theme
 */

import('lib.pkp.classes.plugins.ThemePlugin');
import('lib.pkp.classes.cache.CacheManager');

class SahadevaThemePlugin extends ThemePlugin {
	/**
	 * Initialize the theme's styles, scripts and hooks. This is only run for
	 * the currently active theme.
	 *
	 * @return null
	 */

	public function init() {

		$this->request = Application::get()->getRequest();
		$this->issueDao = DAORegistry::getDAO('IssueDAO');
		$this->submissionDao = Application::getSubmissionDAO();
		$this->cacheManager = CacheManager::getManager();
		
		// add styles
		$this->addStyle('stylesheet', 'styles/sahadeva.less');

		$bgBase = $this->getOption('bg-base');
		$baseUrl = $this->request->getBaseUrl();

		$this->modifyStyle(
			'stylesheet',
			[
				'addLessVariables' =>
					"@bg-base: $bgBase;",
					"@base-url: $baseUrl;",
			]
		);

		// add scripts
		$this->addScript('sahadeva-script', 'js/sahadeva.js', ['contexts' => 'frontend']);

		// add navs
		$this->addMenuArea(array('primary', 'user', 'footer', 'belowAbout'));

		// add options		
		$this->addOption('serialKey', 'FieldText', [
			'label' => 'Serial Key',
			'description' => 'Input valid serial key to remove ads. Purchase a key from <a href="mailto:hello@sanobario.com">Sanobario</a>.',
		]);

		$this->addOption('bg-base', 'FieldColor', [
			'label' => __('plugins.themes.sahadeva.option.color.label'),
			'description' => __('plugins.themes.sahadeva.option.color.description'),
			'default' => '#1E6292',
		]);
		
		$this->addOption('leftColTextFieldHeading', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.leftColTextFieldHeading.label'),
			'description' => 'This is the heading for the Additional Content found in Settings → Website → Appearance → Advanced.'
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
		$this->addOption('aboveFooterCtaButtonText', 'FieldText', [
			'label' => 'Above Footer CTA Button Text',
			'description' => 'This is what appears on the CTA button.',
		]);
		$this->addOption('aboveFooterCtaButtonUrl', 'FieldText', [
			'label' => 'Above Footer CTA Button URL',
			'description' => 'This is the URL the CTA button links to.',
		]);

		foreach([
			'instagram',
			'tiktok',
			'facebook'
		] as $socialField) {
			$this->addOption($socialField, 'FieldText', ['label' => ucfirst($socialField)]);
		}

		$this->addOption('additionalFooterInfo', 'FieldRichTextarea', [
			'label' => __('plugins.themes.sahadeva.option.additionalFooterInfo.label'),
			'description' => __('plugins.themes.sahadeva.option.additionalFooterInfo.description')
		]);

		// hooks
		HookRegistry::register('TemplateManager::display', [$this, 'handleTemplateDisplay']);
		HookRegistry::register('Templates::Issue::Archive::Issues', [$this, 'groupIssuesByYear']);

	}

	public function handleTemplateDisplay($hookName, $args) {
		[$templateMgr, $template] = $args;

		// Serial key check (applies to all pages)
		$this->checkSerialKey($templateMgr, $template);

		// Homepage logic (load current/previous/next issue)
		if (strpos($template, 'frontend/pages/indexSite.tpl') !== false ||
			strpos($template, 'frontend/pages/indexJournal.tpl') !== false ||
			strpos($template, 'frontend/pages/issue.tpl') !== false ||
			strpos($template, 'frontend/pages/article.tpl') !== false) {
			$this->loadCurrentIssue($templateMgr);
			$this->getArticleViews($templateMgr);
		}

		// Article page logic (submission dates)
		if (strpos($template, 'frontend/pages/article.tpl') !== false) {
			$this->addSubmissionDates($templateMgr);
		}

		return false;
	}

	public function checkSerialKey($templateMgr, $template) {
		$serialKey = $this->getOption('serialKey') ?? false;

		if(!$serialKey) return false;

		$cache = $this->cacheManager->getFileCache(
			'sahadeva',
			'isValid',
			function($cache) use ($serialKey) {
				return $this->_rebuildKeyCache($cache, $serialKey);
			},
		);

		$data = $cache->getContents();
		$now = time();

		// check if expired or not valid
		if(
			!isset($data['checkedAt']) ||
			($now - $data['checkedAt'] > 86400) ||
			$data['valid'] == false ||
			$data['serial'] !== $serialKey) {
			// refresh cache
			$data = $this->_rebuildKeyCache($serialKey);
			$cache->setEntireCache($data);
		}

		$templateMgr->assign('validSerialKey', $data['valid']);
	}

	public function _rebuildKeyCache ($serialKey) {
		$data = ['serial' => $serialKey];
		$options = [
			'http' => [
				'header'  => "Content-Type: application/json\r\n",
				'method'  => 'POST',
				'content' => json_encode($data),
				'ignore_errors' => true, // Get response even if HTTP error
				'timeout' => 2,
			],
		];

		$validateContext = stream_context_create($options);
		$response = file_get_contents('https://api.komkom.id/license/validate/', false, $validateContext);

		if($response === false) {
			return [
				'valid' => false,
				'serial' => null,
				'checkedAt' => null,
			];
		} else {
			$json = json_decode($response, true);
			if(isset($json['valid']) && $json['valid'] === true) {
				return [
					'valid' => true,
					'serial' => $serialKey,
					'checkedAt' => time(),
				];
			}
		}

		return [
				'valid' => false,
				'serial' => null,
				'checkedAt' => null,
			];
	}
	
	public function getIssuesbyYear($templateMgr) {

		$start = mictrotime(true);

		$journal = $this->request->getJournal();
		$issues = $this->issueDao->getPublishedIssues($journal->getId())->toArray();

		$grouped = [];

		foreach($issues as $issue) {
			$year = date('Y', strtotime($issue->getDatePublished()));
			$grouped[$year][] = $issue;
		}

		krsort($grouped);

		$templateMgr->assign('groupedIssuesByYear', $grouped);

		error_log("getIssuesByYear " . (microtime(true) - $start) . "s");

		return false;
	}

	public function getArticleViews($templateMgr) {

		$cache = $this->cacheManager->getFileCache(
			'sahadeva',
			'viewsCache',
			[$this, '_rebuildViewsCache'],
		);

		$data = $cache->getContents();
		$now = time();

		if(
			!is_array($data) ||
			($now - $data['checkedAt'] > 86400) ||
			$data['articlesByViews'] == null
		) {
			$data = $this->_rebuildViewsCache();
			$cache->setEntireCache($data);
		}

		$articlesByViews = $data['articlesByViews'];
		
		$topArticles = [];

		// get top 5
		foreach(array_slice($articlesByViews, 0, 5, true) as $id => $views) {
			$submission = $this->submissionDao->getByid($id);
			if($submission) $topArticles[] = $submission;
		}

		$templateMgr->assign([
			'topArticles' => $topArticles,
			'submissionIdsByViews' => $articlesByViews,
		]);
	}

	public function _rebuildViewsCache() {

		$journal = $this->request->getContext();

		// get most-viewed articles
		$metricsDao = DAORegistry::getDAO('MetricsDAO');
		$columns = ['submission_id', 'metric'];
		$filters = [
			'context_id' => $journal->getId(),
			'assoc_type' => ASSOC_TYPE_SUBMISSION,
		];
		$orderBy = [
			'metric' => STATISTICS_ORDER_DESC,
		];

		$articles = $metricsDao->getMetrics('ojs::counter', $columns, $filters, $orderBy);
		
		// load the article objects
		$articlesByViews = [];

		foreach($articles as $row) {
			$submission = $this->submissionDao->getByid($row['submission_id']);
			if($submission) {
				$articlesByViews[$row['submission_id']] = $row['metric'];
			}
		}

		return [
			'articlesByViews' => $articlesByViews,
			'checkedAt' => time(),
		];
	}

	/**
	 * Get the latest issue object
	 * @return bool
	 */
	public function loadCurrentIssue($templateMgr)
	{
		
		$journal = $this->request->getContext();

		// current issue, previous issue, and next issue
		if ($journal) {
			$currentIssue = $this->issueDao->getCurrent($journal->getId(), true);

			$previousIssue = null;
			$nextIssue = null;

			if ($currentIssue) {
				// Get all published issues ordered by datePublished descending
				$issues = $this->issueDao->getPublishedIssues($journal->getId());
				$issuesArray = [];
				while ($issue = $issues->next()) {
					$issuesArray[] = $issue;
				}
				$issuesArray = array_values($issuesArray); // Ensure it's numerically indexed

				// Find index of current issue
				foreach ($issuesArray as $i => $issue) {
					if ($issue->getId() === $currentIssue->getId()) {
						if (isset($issuesArray[$i + 1])) {
							$previousIssue = $issuesArray[$i + 1]; // later in time = older = previous
						}
						if (isset($issuesArray[$i - 1])) {
							$nextIssue = $issuesArray[$i - 1]; // earlier in time = newer = next
						}
						break;
					}
				}
			}

			// Assign to template
			$templateMgr->assign([
				'currentIssue' => $currentIssue,
				'previousIssue' => $previousIssue,
				'nextIssue' => $nextIssue,
			]);
		}

		return false;
	}

	public function addSubmissionDates($templateMgr)
	{

		$start = microtime(true);

		$publication = $templateMgr->getTemplateVars('publication');

		$submissionId = $publication->getData('submissionId');

		$submission = $this->submissionDao->getById($submissionId);

		if (!$submission) return;

		// 1. Submission date
		$dateSubmitted = $submission->getDateSubmitted();

		// // 2. Acceptance date — look through editor decisions
		$editDecisionDao = DAORegistry::getDAO('EditDecisionDAO');
		$decisions = $editDecisionDao->getEditorDecisions($submission->getId());

		$acceptanceDate = null;
		foreach ($decisions as $decision) {
			if ($decision['decision'] == SUBMISSION_EDITOR_DECISION_ACCEPT) {
				$acceptanceDate = $decision['dateDecided'];
				break; // get the first accept
			}
		}

		// 3. Publication date
		$publishDate = $publication->getData('datePublished');

		// Assign to template
		$templateMgr->assign([
			'submissionDate' => $dateSubmitted,
			'acceptanceDate' => $acceptanceDate,
			'publishDate' => $publishDate,
		]);

		error_log("addSubmissionDates took " . (microtime(true) - $start) . "s");

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
