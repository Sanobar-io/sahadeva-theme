<?php

/**
* Sahadeva Theme
*
* Copyright (c) 2025 Sanobario
* Licensed under the GNU GPL v3.
*
* This is the style for the Above Footer CTA.
*
* @class SahadevaThemePlugin
*/

import('lib.pkp.classes.plugins.ThemePlugin');
import('lib.pkp.classes.cache.CacheManager');

class SahadevaThemePlugin extends ThemePlugin {

	public function init() {
		/**
		 * Initial method calls to reduce excessive calls down the line
		 */
		$this->request = Application::get()->getRequest();
		$this->issueDao = DAORegistry::getDAO('IssueDAO');

		import('plugins.themes.sahadeva.classes.SahadevaSubmissionDAO');
		$this->submissionDao = new SahadevaSubmissionDAO();

		$this->cacheManager = CacheManager::getManager();
		$this->templateMgr = TemplateManager::getManager($this->request);

		/**
		 * Register plugins
		 */
		if (!isset($GLOBALS['__viewcountPluginRegistered'])) {
			require_once(__DIR__ . '/plugins/modifier.viewcount.php');
			$this->templateMgr->registerPlugin('modifier', 'viewcount', 'smarty_modifier_viewcount');
			$GLOBALS['__viewcountPluginRegistered'] = true;
		}
		
		/**
		 * Styles setup
		 */
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

		/**
		 * Get jQuery from CDN
		 */
		$min = Config::getVar('general', 'enable_minified') ? '.min' : '';
		$jquery = $this->request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
		$jqueryUI = $this->request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';

		$this->addScript('jQuery', $jquery, array('baseUrl' => ''));
		$this->addScript('jQueryUI', $jqueryUI, array('baseUrl' => ''));

		// Load custom JavaScript for this theme
		$this->addScript('sahadeva', 'js/sahadeva.js');
		$this->addScript('swapperJs', 'js/swapper.js');

		/**
		 * Menu Areas setup
		 */
		$this->addMenuArea(array('primary', 'user', 'footer', 'belowAbout'));

		/**
		 * Options Setup
		 */
		$this->addSahadevaOptions();
		
		/**
		 * The Hooks
		 */
		HookRegistry::register('TemplateManager::display', [$this, 'handleTemplateDisplay']);
		HookRegistry::register('Templates::Issue::Archive::Issues', [$this, 'groupIssuesByYear']);

	}

	private function addSahadevaOptions() {
		/**
		 * Serial Key Options
		 */
		$this->addOption('serialKey', 'FieldText', [
			'label' => 'Serial Key',
			'description' => 'Input valid serial key to remove ads. Purchase a key from <a href="mailto:hello@sanobario.com">Sanobario</a>.',
		]);

		/** Primary Color Options */
		$this->addOption('bg-base', 'FieldColor', [
			'label' => __('plugins.themes.sahadeva.option.color.label'),
			'description' => __('plugins.themes.sahadeva.option.color.description'),
			'default' => '#1E6292',
		]);

		/**
		 * Body Content Options
		 */		
		$this->addOption('leftColTextFieldHeading', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.leftColTextFieldHeading.label'),
			'description' => 'This is the heading for the Additional Content found in Settings → Website → Appearance → Advanced.'
		]);

		/**
		 * Most-viewed Limit Options
		 */
		$this->addOption('mostViewedLimiter', 'FieldText', [
			'label' => 'Number of most-viewed posts to show on front page (Default: 5)',
			'inputType' => 'number',
		]);

		/**
		 * ISSN Options
		 */
		$this->addOption('issnPrint', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.issnPrint.label'),
		]);
		$this->addOption('issnElectronic', 'FieldText', [
			'label' => __('plugins.themes.sahadeva.option.issnElectronic.label'),
		]);

		/**
		 * Above Footer CTA Options
		 */
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

		/**
		 * Social Media Options
		 */
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

		return false;
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
			$this->getArticleViews($templateMgr);
		}

		if (strpos($template, 'frontend/pages/indexJournal.tpl') !== false) {
			$this->getArticleLimiter($templateMgr);
		}

		// Article page logic (submission dates)
		if (strpos($template, 'frontend/pages/article.tpl') !== false) {
			$this->addSubmissionDates($templateMgr);
		}

		return false;
	}

	public function checkSerialKey($templateMgr, $template) {
		$serialKey = $this->getOption('serialKey') ?? false;

		$cache = $this->cacheManager->getFileCache(
			'sahadeva',
			'isValid',
			function($cache) use ($serialKey) {
				return $this->_rebuildKeyCache($serialKey);
			},
		);

		$data = $cache->getContents();

		// check if never checked or not valid
		if(
			!isset($data['checkedAt']) || // never checked
			$data['serial'] !== $serialKey) {
			// refresh cache
			$data = $this->_rebuildKeyCache($serialKey);
			$cache->setEntireCache($data);
		}

		$templateMgr->assign('jfhr1239hrf973', $data['valid']);

		return false;
	}

	public function _rebuildKeyCache ($serialKey) {
		$context = $this->request->getContext();
		$contextPath = $this->request->getDispatcher()->url(
			$this->request,
			ROUTE_PAGE,
			$context ? $context->getPath() : null,
			null
		);

		$origin = $contextPath;
		$data = [
			'serial' => $serialKey,
			'origin' => $origin,
		];

		$options = [
			'http' => [
				'header'  => "Content-Type: application/json\r\nAccept: application/json\r\n",
				'method'  => 'POST',
				'content' => json_encode($data),
				'ignore_errors' => true, // Get response even if HTTP error
				'timeout' => 60,
			],
		];

		$validateContext = stream_context_create($options);
		$response = file_get_contents('https://api.komkom.id/license/validate/', false, $validateContext);

		if($response === false) {
			return [
				'valid' => false,
				'serial' => $serialKey,
				'checkedAt' => time(),
			];
		} else {
			$json = json_decode($response, true);
			if (json_last_error() !== JSON_ERROR_NONE) {
				echo "Whoa! There's an error!";
			}
			return [
				'valid' => $json['valid'],
				'serial' => $serialKey,
				'checkedAt' => time(),
			];
		}
	}
	
	public function getIssuesbyYear($templateMgr) {

		$journal = $this->request->getJournal();
		$issues = $this->issueDao->getPublishedIssues($journal->getId())->toArray();

		$grouped = [];

		foreach($issues as $issue) {
			$year = date('Y', strtotime($issue->getDatePublished()));
			$grouped[$year][] = $issue;
		}

		krsort($grouped);

		$templateMgr->assign('groupedIssuesByYear', $grouped);

		return false;
	}

	public function getArticleViews($templateMgr) {
		$the_limit = $this->getOption('mostViewedLimiter');
		// make sure the limit is 0 or a positive integer, otherwise default to 5
		$the_limit = is_numeric($the_limit) && (int)$the_limit > 0 ? (int)$the_limit : 5;

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
			$data['limiter'] !== $the_limit ||
			$data['articlesByViews'] == null
		) {
			$data = $this->_rebuildViewsCache($the_limit);
			$cache->setEntireCache($data);
		}

		$articlesByViews = $data['articlesByViews'];
		$ids = array_keys($articlesByViews);
		
		$submissions = $this->submissionDao->getByIds($ids);
		$journal = $this->request->getContext();
		$issues = Services::get('issue')->getMany([
			'contextId' => $journal->getId(),
			'isPublished' => true,
			'count' => $the_limit, // or however many you want
		]);

		$indexedIssues = [];
		foreach(iterator_to_array($issues) as $an_issue) {
			$indexedIssues[$an_issue->getId()] = $an_issue;
		}

		$submissionById = [];
		foreach ($submissions as $submission) {
			$submissionById[$submission->getId()] = $submission;
		}

		$topArticles = [];

		foreach ($articlesByViews as $submissionId => $views) {
			if (!isset($submissionById[$submissionId])) continue;

			$submission = $submissionById[$submissionId];
			$publication = $submission->getCurrentPublication();
			$issueId = $publication->getData('issueId');

			$topArticles[] = [
				'submission' => $submission,
				'publication' => $publication,
				'issue' => $issueId,
			];
		}

		$templateMgr->assign([
			'topArticles' => $topArticles,
			'allIssues' => iterator_to_array($indexedIssues),
			'submissionIdsByViews' => $articlesByViews,
		]);

		return false;
	}

	public function _rebuildViewsCache($the_limit) {

		if($the_limit <= 0) { // return an empty array if limit is zero
			return [
				'articlesByViews' => [],
				'limit' => $the_limit,
				'checkedAt' => time(),
			];
		}

		$limiter = new DBResultRange($the_limit * 2);

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

		$articles = $metricsDao->getMetrics('ojs::counter', $columns, $filters, $orderBy, null, $limiter);
		
		// load the article objects
		$articlesByViews = [];
		$count = 0;

		foreach($articles as $row) {
			if($count >= $the_limit) break;
			$submission = $this->submissionDao->getByid($row['submission_id']);
			$publication = $submission->getCurrentPublication();
			$published = $publication->getData('status');
			if($submission && $published !== STATUS_PUBLISHED) continue;

			$articlesByViews[$row['submission_id']] = $row['metric'];
			$count++;
		}

		return [
			'articlesByViews' => $articlesByViews,
			'limit' => $the_limit,
			'checkedAt' => time(),
		];
	}

	/**
	 * Assigns submission-related dates to the template for display on the article page.
	 *
	 * This function retrieves the submission, acceptance, and publication dates
	 * from the submission and its associated editorial decisions, then assigns them
	 * to the Smarty template manager $templateMgr using assign().
	 *
	 * Assigned variables:
	 * - `submissionDate` (string|null)
	 * - `acceptanceDate` (string|null)
	 * - `publishDate` (string|null)
	 *
	 * @param TemplateManager $templateMgr
	 * @return false Always returns false to continue normal template rendering flow
	 */
	public function addSubmissionDates($templateMgr)
	{

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

		return false;
	}

	public function getArticleLimiter($templateMgr) {
		$limiter = $this->getOption('mostViewedLimiter') ?? 5;
		$templateMgr->assign('limiter', $limiter);
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
