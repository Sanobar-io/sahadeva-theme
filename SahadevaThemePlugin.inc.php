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

ini_set('log_errors', 1);
ini_set('error_reporting', E_ALL);

import('lib.pkp.classes.plugins.ThemePlugin');
import('lib.pkp.classes.cache.CacheManager');
import('lib.pkp.classes.site.VersionCheck');

class SahadevaThemePlugin extends ThemePlugin {

	public $request;
	public $issueDao;
	public $journal;
	public $journalId;
	public $cacheManager;
	public $submissionDao;
	public int $the_limit;

	public function init() {

		/**
		 * Initial method calls to reduce excessive calls down the line
		 */
		$this->request = Application::get()->getRequest();
		$this->issueDao = DAORegistry::getDAO('IssueDAO');
		$this->journal = $this->request?->getContext();
		$this->journalId = $this->journal?->getId();

		import('plugins.themes.sahadeva.classes.SahadevaSubmissionDAO');
		$this->cacheManager = CacheManager::getManager();

		/**
		 * Check if in backend
		 */
		
		/**
		 * Styles setup
		 */
		$this->addStyle('stylesheet', 'styles/sahadeva.less');

		$bgBase = $this->getOption('bg-base');
		$baseUrl = $this->request->getBaseUrl();

		$this->modifyStyle(
			'stylesheet',
			[
				'addLessVariables' => "
					@bg-base: $bgBase;
					@base-url: '$baseUrl';
				"
			]
		);

		/**
		 * Get jQuery from CDN
		 */
		$min = Config::getVar('general', 'enable_minified') ? '.min' : '';
		$jquery = $baseUrl . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
		$jqueryUI = $baseUrl . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';

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
		if($this->journal) {
			HookRegistry::register('Templates::Issue::Archive::Issues', [$this, 'groupIssuesByYear']);
		}

		return;

	}

	private function addSahadevaOptions() {

		$start = microtime(true);

		/**
		 * Show theme version in backend
		 */
		$versionFile = $this->getPluginPath() . '/version.xml';

		if (file_exists($versionFile)) {
			$versionInfo = VersionCheck::parseVersionXML($versionFile);
			$versionString = $versionInfo['release'] ? $versionInfo['release'] : 'Unknown';
			$versionDate = $versionInfo['date'] ? $versionInfo['date'] : 'Unknown';
		} else {
			$versionString = 'Unknown';
		}

		$this->addOption('themeVersion', 'FieldHTML', [
			'label' => "Sahadeva Theme Version $versionString",
			'description' => "<ul>
			<li>Version Released: $versionDate</li>
			</ul>",
		]);

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

		$totalTime = microtime(true) - $start;
		error_log("addOptions() took $totalTime<br>");

		return false;
	}

	public function handleTemplateDisplay($hookName, $args) {
		$start = microtime(true);

		[$templateMgr, $template] = $args;

		if($this->journal)
			$this->submissionDao = new SahadevaSubmissionDAO();

		// Register plugins
		if (!isset($GLOBALS['__viewcountPluginRegistered'])) {
			require_once(__DIR__ . '/plugins/modifier.viewcount.php');
			$templateMgr->registerPlugin('modifier', 'viewcount', 'smarty_modifier_viewcount');
			$GLOBALS['__viewcountPluginRegistered'] = true;
		}

		// Serial key check (applies to all pages)
		$this->checkSerialKey($templateMgr, $template);

		
		if(!$this->journal) return false;

		// Homepage logic (load current/previous/next issue)
		if (strpos($template, 'frontend/pages/indexSite.tpl') !== false ||
			strpos($template, 'frontend/pages/indexJournal.tpl') !== false ||
			strpos($template, 'frontend/pages/issue.tpl') !== false ||
			strpos($template, 'frontend/pages/article.tpl') !== false) {
			$this->the_limit =
				is_numeric($this->getOption('mostViewedLimiter')) &&
				(int)$this->getOption('mostViewedLimiter') > 0 ?
				(int)$this->getOption('mostViewedLimiter') :
				5;
			$this->getArticleViews($templateMgr);
		}

		if (strpos($template, 'frontend/pages/indexJournal.tpl') !== false) {
			$this->getArticleLimiter($templateMgr);
		}

		// Article page logic (submission dates)
		if (strpos($template, 'frontend/pages/article.tpl') !== false) {
			$this->addSubmissionDates($templateMgr);
		}

		$totalTime = microtime(true) - $start;
		error_log("addOptions() took $totalTime<br>");

		return false;
	}

	public function checkSerialKey($templateMgr, $template) {
		$start = microtime(true);

		$serialKey = $this->getOption('serialKey') ?? false;

		$contextId = $this->journalId ?? 'site__';

		$cache = $this->cacheManager->getFileCache(
			'sahadeva',
			'isValid_' . $contextId,
			function() use ($serialKey) {
				return $this->_rebuildKeyCache($serialKey);
			}
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

		$templateMgr->assign('jfhr1239hrf973', $data['valid'] ?? false);

		$totalTime = microtime(true) - $start;
		error_log("checkSerialkey() took $totalTime<br>");

		return false;
	}

	public function _rebuildKeyCache ($serialKey) {
		$context = $this->journal;
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
				error_log("Sahadeva: JSON parse error in license validation");
				return [
					'valid' => false,
					'serial' => $serialKey,
					'checkedAt' => time(),
				];
			}
			return [
				'valid' => $json['valid'] ?? false,
				'serial' => $serialKey,
				'checkedAt' => time(),
			];
		}
	}

	public function getArticleViews($templateMgr) {

		$start = microtime(true);

		$contextId = $this->journalId ?? 'site__';

		$cache = $this->cacheManager->getFileCache(
			'sahadeva',
			'viewsCache_' . $contextId,
			[$this, '_rebuildViewsCache'],
		);

		$data = $cache->getContents();
		$now = time();

		if(
			!is_array($data) ||
			($now - $data['checkedAt'] > 86400) ||
			$data['limit'] !== $this->the_limit ||
			$data['articlesByViews'] == null
		) {
			$data = $this->_rebuildViewsCache();
			$cache->setEntireCache($data);
		}

		$articlesByViews = $data['articlesByViews'];
		
		$issues = Services::get('issue')->getMany([
			'contextId' => $this->journalId,
			'isPublished' => true,
			'count' => $this->the_limit, // or however many you want
		]);

		$indexedIssues = [];
		foreach(iterator_to_array($issues) as $an_issue) {
			$indexedIssues[$an_issue->getId()] = $an_issue;
		}

		$templateMgr->assign([
			'topArticles' => $articlesByViews,
			'allIssues' => iterator_to_array($indexedIssues),
		]);

		$totalTime = microtime(true) - $start;
		error_log("addOptions() took $totalTime<br>");

		return false;
	}

	public function _rebuildViewsCache() {

		error_log("Rebuilding views cache...");

		if ($this->the_limit <= 0) {
			return [
				'articlesByViews' => [],
				'limit' => 0,
				'checkedAt' => time(),
			];
		}

		if (!$this->journal) {
			error_log("Sahadeva: No journal context available.");
			return [
				'articlesByViews' => [],
				'limit' => $this->the_limit,
				'checkedAt' => time(),
			];
		}

		$limiter = new DBResultRange($this->the_limit * 2); // buffer to catch invalids
		$metricsDao = DAORegistry::getDAO('MetricsDAO');

		if(!$this->journalId) {
			error_log("Sahadeva: Not within journal context.");
			return false;
		}

		try {
			$columns = ['submission_id', 'metric'];
			$filters = [
				'context_id' => $this->journalId,
				'assoc_type' => ASSOC_TYPE_SUBMISSION,
			];
			$orderBy = ['metric' => STATISTICS_ORDER_DESC];

			$articles = $metricsDao->getMetrics('ojs::counter', $columns, $filters, $orderBy, null, $limiter);

			// Index view counts by submission_id
			$viewCounts = [];
			foreach ($articles as $row) {
				if (!empty($row['submission_id'])) {
					$viewCounts[(int) $row['submission_id']] = (int) $row['metric'];
				}
			}

			$submissionIds = array_keys($viewCounts);
			$submissions = $this->submissionDao->getByIds($submissionIds);

			$articlesByViews = [];
			$count = 0;
			foreach ($submissions as $submission) {
				if ($count >= $this->the_limit) break;

				$submissionId = $submission->getId();
				$viewCount = $viewCounts[$submissionId] ?? 0;

				$publication = $submission->getCurrentPublication();
				if (!$publication) continue;

				$status = $publication->getData('status');
				if ($status !== STATUS_PUBLISHED) continue;

				$articlesByViews[] = [
					'submission' => [
						'submissionId' => $submission->getBestId(),
						'issueId' => $publication->getData('issueId'),
						'title' => $submission->getLocalizedTitle(),
						'pages' => $publication->getData('pages'),
						'doi' => $publication->getStoredPubId('doi') ?? '',
						'authors' => $submission->getAuthorString(),
						'datePublished' => $submission->getDatePublished(),
						'abstract' => $submission->getLocalizedAbstract(),
					],
					'views' => $viewCount,
				];

			}
		} catch (Throwable $e) {
			error_log("Sahadeva: Exception in _rebuildViewsCache - " . $e->getMessage());
		}

		return [
			'articlesByViews' => $articlesByViews,
			'limit' => $this->the_limit,
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
	public function addSubmissionDates($templateMgr) {

		$start = microtime(true);

		$publication = $templateMgr->getTemplateVars('publication');
		if(!$publication) return false;

		$submissionId = $publication->getData('submissionId');
		if(!$submissionId) return false;

		$submission = $this->submissionDao->getById($submissionId);
		if (!$submission) return;

		// 1. Submission date
		$dateSubmitted = $submission->getDateSubmitted();

		// // 2. Acceptance date — look through editor decisions
		$editDecisionDao = DAORegistry::getDAO('EditDecisionDAO');
		$decisions = $editDecisionDao->getEditorDecisions($submissionId);

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

		$totalTime = microtime(true) - $start;
		error_log("addSubmissionDates() took $totalTime<br>");

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
