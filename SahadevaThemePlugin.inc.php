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
import('lib.pkp.classes.site.VersionCheck');

class SahadevaThemePlugin extends ThemePlugin {

	public $request;
	public $issueDao;
	public $journal;
	public $journalId;
	public $cacheManager;
	public $submissionDao;
	public $the_limit;
	public $metricsDao;

	public function init() {

		// Initial method calls to reduce excessive calls down the line
		$this->request = Application::get()->getRequest();
		$this->issueDao = DAORegistry::getDAO('IssueDAO');
		$this->journal = $this->request ? $this->request->getContext() : null;
		$this->journalId = $this->journal ? $this->journal->getId() : null;
		$this->metricsDao = DAORegistry::getDAO('MetricsDAO');

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

		// make sure it's run only once
		if (!empty($GLOBALS['__sahadeva']['addOptionsRan'])) return false;
		$GLOBALS['__sahadeva']['addOptionsRan'] = true;

		

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

		return false;
	}

	public function handleTemplateDisplay($hookName, $args) {
		// make sure it's run only once
		if (!empty($GLOBALS['__sahadeva']['handleTemplateDisplayRan'])) return false;
		$GLOBALS['__sahadeva']['handleTemplateDisplayRan'] = true;

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

		// Issue page logic (enrich with views)
		if (strpos($template, 'frontend/pages/issue.tpl') !== false) {
			$this->addViewsToIssueArticles($templateMgr);
		}

		// Article page logic (submission dates)
		if (strpos($template, 'frontend/pages/article.tpl') !== false) {
			$this->addSubmissionDates($templateMgr);
		}


		return false;
	}

	public function checkSerialKey($templateMgr, $template) {
		// make sure it's run only once
		if (!empty($GLOBALS['__sahadeva']['checkSerialKeyRan'])) return false;
		$GLOBALS['__sahadeva']['checkSerialKeyRan'] = true;

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
			$data['serial'] !== $serialKey // changed
		) {
			// refresh cache
			$data = $this->_rebuildKeyCache($serialKey);
			$cache->setEntireCache($data);
		}

		$templateMgr->assign('jfhr1239hrf973', $data['valid'] ?? false);

		return false;
	}

	public function _rebuildKeyCache ($serialKey) {
		error_log("Attempting to rebuild serial key cache.");
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

	   // Use cURL for the API request
	   $ch = curl_init('https://api.komkom.id/license/validate/');
	   curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	   curl_setopt($ch, CURLOPT_POST, true);
	   curl_setopt($ch, CURLOPT_HTTPHEADER, [
		   'Content-Type: application/json',
		   'Accept: application/json',
	   ]);
	   curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
	   curl_setopt($ch, CURLOPT_TIMEOUT, 60);
	   // Optionally, follow redirects and ignore SSL issues (not recommended for production)
	   // curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
	   // curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

	   $response = curl_exec($ch);
	   $curlErr = curl_error($ch);
	   $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
	   curl_close($ch);

	   if($response === false || $httpCode < 200 || $httpCode >= 300) {
		   error_log("Sahadeva: Failed to validate serial key. cURL error: $curlErr HTTP code: $httpCode");
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

		// make sure it's run only once
		if (!empty($GLOBALS['__sahadeva']['getArticleViewsRan'])) return false;
		$GLOBALS['__sahadeva']['getArticleViewsRan'] = true;

		

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

		$issuesIterable = $issues instanceof Traversable ? iterator_to_array($issues) : $issues;

		$indexedIssues = [];
		foreach($issuesIterable as $an_issue) {
			$indexedIssues[$an_issue->getId()] = $an_issue;
		}

		$templateMgr->assign([
			'topArticles' => $articlesByViews,
			'allIssues' => $indexedIssues,
		]);

		return false;
	}

	public function _rebuildViewsCache() {

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
			$limiter = new DBResultRange($this->the_limit * 2); // buffer to catch invalids

			$articles = $this->metricsDao->getMetrics('ojs::counter', $columns, $filters, $orderBy, null, $limiter);

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

			if(!$submissions || !is_iterable($submissions)) {
				return [
					'articlesByViews' => [],
					'limit' => $this->the_limit,
					'checkedAt' => time(),
				];
			}
			
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

				// Sort articlesByViews by 'views' descending
				usort($articlesByViews, function($a, $b) {
					return $b['views'] <=> $a['views'];
				});

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

		// make sure it's run only once
		if (!empty($GLOBALS['__sahadeva']['addSubmissionDatesRan'])) return false;
		$GLOBALS['__sahadeva']['addSubmissionDatesRan'] = true;

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

		return false;
	}

	public function getArticleLimiter($templateMgr) {
		$limiter = $this->getOption('mostViewedLimiter') ?? 5;
		$templateMgr->assign('limiter', $limiter);
	}

	public function getSubmissionViewCount($submissionId) {
		$columns = ['submission_id', 'metric'];
		$filters = [
			'context_id' => $this->journalId,
			'assoc_type' => ASSOC_TYPE_SUBMISSION,
			'assoc_id' => $submissionId,
		];

		$results = $this->metricsDao->getMetrics(
			'ojs::counter',
			$columns,
			$filters,
		);

		$total = 0;
		if (!empty($results)) {
			foreach ($results as $row) {
				if (isset($row['metric'])) {
					$total += (int) $row['metric'];
				}
			}
		}

		return $total;
	}

	public function addViewsToIssueArticles($templateMgr) {

		$sections = $templateMgr->getTemplateVars('publishedSubmissions');

		if (!$sections || !is_array($sections)) return false;

		$sectionsWithViews = [];

		foreach ($sections as $section) {
			$articlesWithViews = [];

			foreach ($section['articles'] as $submission) {
				$articlesWithViews[] = [
					'submission' => $submission,
					'views' => $this->getSubmissionViewCount($submission->getId()),
				];
			}
			
			$sectionsWithViews[] = [
				'title' => $section['title'],
				'articles' => $articlesWithViews,
			];
		}

		$templateMgr->assign('sectionsWithViews', $sectionsWithViews);

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
