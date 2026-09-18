/// Every user-visible string in the app, grouped by screen.
///
/// Copy is taken verbatim from the Penpot design. Keep curly apostrophes.
abstract final class AppStrings {
  // ---- Brand -------------------------------------------------------------
  static const String appName = 'kalpi';
  static const String tagline = 'YOUR IDEAS. YOUR RULES.';

  // ---- Common actions ------------------------------------------------------
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String exit = 'Exit';
  static const String cancel = 'Cancel';
  static const String continueLabel = 'Continue';
  static const String close = 'Close';
  static const String retry = 'Retry';
  static const String clearSearch = 'Clear search';
  static const String moreActions = 'More actions';
  static const String profile = 'Profile';

  // ---- Onboarding · Welcome -------------------------------------------------
  static const String welcomeHeadline =
      'Invest with\na little more\nintention.';
  static const String welcomeBody =
      'Turn an investing idea into a clear,\nrepeatable strategy. No code needed.';
  static const String welcomeStepUniverseTitle = 'Start with a stock universe';
  static const String welcomeStepUniverseSubtitle = 'Nifty 500';
  static const String welcomeStepRulesTitle = 'Add rules you believe in';
  static const String welcomeStepRulesSubtitle = 'Filter. Rank. Allocate.';
  static const String welcomeStepResult = 'A strategy that follows your logic';
  static const String welcomeCta = 'Let’s get started';
  static const String welcomeFootnote =
      'Explore first. Build at your own pace.';

  // ---- Onboarding · Experience -------------------------------------------
  static const String experienceTopBar = 'A little about you';
  static const String personaliseEyebrow = 'PERSONALISE YOUR GUIDANCE';
  static const String experienceTitle = 'Where are you\nstarting from?';
  static const String experienceSubtitle =
      'We’ll adjust the explanations to suit you.';
  static const String changeLaterHint = 'You can change this later.';
  static const String savePreference = 'Save preference';

  // ---- Onboarding · Intent -------------------------------------------------
  static const String intentTopBar = 'Make it yours';
  static const String intentTitle = 'What brings you\nto Kalpi?';
  static const String intentSubtitle =
      'Choose what you’d like to explore first.';
  static const String intentFootnote =
      'This helps us tailor your experience.\nIt doesn’t determine your investment risk.';
  static const String intentCta = 'Make myself at home';
  static const String intentCtaLearn = 'Explore an example';

  // ---- Strategy list -------------------------------------------------------
  static const String notebookEyebrow = 'Your investing notebook';
  static const String myStrategies = 'My strategies';
  static String strategyCountSummary(int count) =>
      '$count ${count == 1 ? 'strategy' : 'strategies'} · Your ideas, organised.';
  static const String searchStrategiesHint = 'Find a strategy';
  static const String filterAll = 'All';
  static const String filterSaved = 'Saved';
  static const String savedStrategy = 'Saved strategy';
  static const String viewStrategy = 'View strategy';
  static const String createStrategy = 'Create a strategy';
  static const String listFootnote =
      'Saved ideas stay here until you need them.';
  static String savedBanner(String name) => '“$name” saved';
  static String deletedBanner(String name) => '“$name” deleted';
  static const String changesSavedBanner = 'Changes saved';
  static const String copyCreatedBanner = 'Copy created';
  static const String noMatchingTitle = 'No matching strategies';
  static const String noMatchingBody =
      'Try another name, or clear your search\nto see all your saved strategies.';
  static const String loadFailedTitle = 'Couldn’t load your strategies';
  static const String loadFailedBody =
      'Something went wrong while reading your notebook. Try again.';

  // ---- Empty state -----------------------------------------------------------
  static const String emptyTitle = 'Your first idea starts here.';
  static const String emptyBody =
      'Choose your stocks, add a few rules,\nand save a strategy that’s yours.';
  static const String emptyCta = 'Build my first strategy';
  static const String learnPromoTitle = 'New to rule-based investing?';
  static const String learnPromoBody =
      'See how a simple strategy comes together.';
  static const String learnPromoLink = 'Explore an example  →';

  // ---- Bottom navigation -------------------------------------------------------
  static const String navStrategies = 'Strategies';
  static const String navBuild = 'Build';
  static const String navLearn = 'Learn';

  // ---- Builder · shared --------------------------------------------------------
  static String buildStepTitle(int step, int total) =>
      'Build a strategy · $step/$total';
  static String editStepTitle(String name) => 'Edit $name';
  static String editCopyTopBar = 'Edit copied strategy';
  static String stepCounter(int step, int total) => '$step of $total';
  static const String reviewChanges = 'Review changes';
  static const String matchAllRules = 'Match all rules';
  static const String and = 'AND';

  // ---- Builder · Universe ------------------------------------------------------
  static const String universeTitle = 'Where should we\nlook for stocks?';
  static const String universeSubtitle =
      'Your stock universe is the starting pool.';
  static const String customUniverse = 'Custom universe';
  static const String customUniverseDescription =
      'Choose a specific set of stocks.';
  static String customUniverseSelected(int count) =>
      '$count ${count == 1 ? 'stock' : 'stocks'} selected.';
  static const String universeHint =
      'A wider universe gives your rules more\nstocks to choose from.';
  static const String continueToFilters = 'Continue to filters';

  // ---- Builder · Custom universe ---------------------------------------------
  static const String chooseStocksTopBar = 'Choose stocks';
  static const String customTitle = 'Make your own\nstarting pool.';
  static const String customSubtitle =
      'Search and select the stocks to include.';
  static const String searchStocksHint = 'Search name or symbol';
  static String stocksSelected(int count) =>
      '$count ${count == 1 ? 'stock' : 'stocks'} selected';
  static const String noStocksSelected = 'No stocks selected yet';
  static const String noStocksFound = 'No stocks match your search.';
  static const String customFootnote =
      'Illustrative catalogue. Live constituents need market data.';
  static const String useSelectedStocks = 'Use selected stocks';
  static const String backToUniverse = 'Back to stock universe';

  // ---- Builder · Filters -------------------------------------------------------
  static const String filtersTitle = 'What makes a\nstock a good fit?';
  static const String filtersSubtitle =
      'Keep only stocks that meet your rules.';
  static const String addAnotherRule = 'Add another rule';
  static const String addFirstRule = 'Add a rule';
  static const String noRulesHint =
      'Without rules, every stock in your universe passes through to ranking.';
  static const String plainEnglishTitle = 'In plain English';
  static const String continueToRanking = 'Continue to ranking';

  // ---- Rule editor ---------------------------------------------------------------
  static const String addRuleTitle = 'Add a rule';
  static String editRuleTitle(String categoryWord) => 'Edit $categoryWord rule';
  static const String metricLabel = 'Metric';
  static const String conditionLabel = 'Condition';
  static const String exampleRuleHint =
      'Example rule • adjust to your own approach';
  static const String saveRule = 'Save rule';
  static const String removeRule = 'Remove rule';
  static const String closeRuleEditor = 'Close rule editor';
  static const String ruleValueRequiredError = 'Enter a number for this rule.';
  static const String ruleValueNumberError = 'Enter a valid number.';
  static const String ruleValuePositiveError = 'Enter a number greater than 0.';
  static const String ruleValueNonNegativeError =
      'Enter a number of 0 or more.';
  static const String ruleValuePercentRangeError =
      'Enter a percentage between -100 and 1000.';
  static const String ruleValueTooLargeError = 'That value is too large.';
  static const String duplicateRuleError =
      'You already have this exact rule. Edit it instead.';

  // ---- Metric picker --------------------------------------------------------------
  static const String chooseMetricTopBar = 'Choose a metric';
  static const String chooseRankingMetricTopBar = 'Ranking metric';
  static const String metricsTitle = 'What matters to you?';
  static const String searchMetricsHint = 'Search metrics';
  static const String noMetricsFound = 'No metrics match your search.';
  static String rankingMetricNote(String metricLabel) =>
      'This strategy ranks by ${metricLabel.toLowerCase()}.';

  // ---- Builder · Ranking ------------------------------------------------------------
  static const String rankingTitle = 'Which stocks\nshould come first?';
  static const String rankingSubtitle =
      'Rank the stocks that pass your filters.';
  static const String rankBy = 'Rank by';
  static const String holdingsQuestion = 'How many stocks should we keep?';
  static String holdingsHint(int count) =>
      'We’ll keep up to the top $count after ranking.';
  static const String logicSoFarTitle = 'Your logic so far';
  static const String continueToAllocation = 'Continue to allocation';
  static const String holdingsPositiveError = 'Keep at least one stock.';
  static String holdingsExceedUniverseError(int universeCount) =>
      'Your universe has only $universeCount stocks.';
  static const String customHoldingsLabel = 'Custom';

  // ---- Builder · Allocation ----------------------------------------------------------
  static const String allocationTitle = 'Give every stock\nits place.';
  static const String allocationSubtitle =
      'Decide how your strategy is divided.';
  static String equalWeightDescription(int count) =>
      'Give each of your $count stocks\nthe same share.';
  static const String marketCapDescription =
      'Give larger companies a larger share.';
  static String balancedSplitTitle(int count) =>
      '$count ${count == 1 ? 'stock' : 'stocks'}. One balanced split.';
  static String approxPerStock(String percent) =>
      'Approximately $percent per stock';
  static const String marketCapPreviewTitle = 'Weighted by size.';
  static const String marketCapPreviewNote =
      'Illustrative shape only. Real weights need market-cap data.';
  static const String reviewMyStrategy = 'Review my strategy';

  // ---- Builder · Review -------------------------------------------------------------
  static const String reviewTopBar = 'Review strategy';
  static const String reviewTitle = 'Your idea,\nwritten into rules.';
  static const String reviewSubtitle = 'Check the details before you save.';
  static const String editReviewTitle = 'Review your\nupdated strategy.';
  static const String editReviewSubtitle =
      'Your original is updated only when you save.';
  static const String strategyNameLabel = 'Strategy name';
  static const String strategyNameRequiredLabel = 'Strategy name *';
  static const String strategyNameHint = 'e.g. Quality first';
  static const String sectionStocks = 'Stocks';
  static const String sectionFilters = 'Filters';
  static const String sectionRanking = 'Ranking';
  static const String sectionAllocation = 'Allocation';
  static const String noFilters = 'No filters';
  static const String reviewFootnote =
      'Saving creates a strategy in your notebook.\nIt won’t place any trades.';
  static const String savingFootnote =
      'Saving your rules securely.\nPlease wait a moment.';
  static const String saveStrategy = 'Save strategy';
  static const String savingStrategy = 'Saving strategy…';
  static const String saveChanges = 'Save changes';
  static const String savingChanges = 'Saving changes…';
  static const String nameRequiredError = 'Enter a name for your strategy.';
  static const String nameTooLongError = 'Keep the name under 60 characters.';
  static const String customUniverseEmptyError =
      'Choose at least one stock for your custom universe.';

  // ---- Save recovery ---------------------------------------------------------------
  static const String saveErrorTitle = 'Your idea is\nstill here.';
  static const String saveErrorSubtitle =
      'We couldn’t save the strategy right now.';
  static const String saveErrorCardTitle = 'Connection interrupted';
  static const String saveErrorCardBody =
      'Check your connection and try again.\nYour rules are kept on this screen.';
  static const String backToReview = 'Back to review';
  static const String trySavingAgain = 'Try saving again';

  // ---- Exit confirmation -------------------------------------------------------------
  static const String exitTitle = 'Leave this strategy?';
  static const String exitBody =
      'Your changes haven’t been saved.\nKeep building, or discard this draft\nand return to My strategies.';
  static const String keepBuilding = 'Keep building';
  static const String discardDraft = 'Discard draft';

  // ---- Strategy detail -----------------------------------------------------------------
  static const String savedStrategyEyebrow = 'SAVED STRATEGY';
  static const String startingStocks = 'Starting stocks';
  static const String filtersStat = 'Filters';
  static const String targetHoldings = 'Target holdings';
  static const String rulesBehindIt = 'The rules behind it';
  static const String stockUniverseKey = 'Stock universe';
  static const String mustMatchAllKey = 'Must match all';
  static const String allocationKey = 'Allocation';
  static const String rankingKey = 'Ranking';
  static const String detailFootnote =
      'This is a saved strategy, not an active investment.';
  static const String editStrategy = 'Edit strategy';
  static const String strategyNotFoundTitle = 'Strategy not found';
  static const String strategyNotFoundBody =
      'It may have been deleted. Head back to your strategies.';
  static const String backToMyStrategies = 'Back to my strategies';

  // ---- Strategy actions sheet ------------------------------------------------------------
  static const String manageSubtitle = 'Manage your saved strategy';
  static const String duplicateStrategy = 'Duplicate strategy';
  static const String deleteStrategy = 'Delete strategy';

  // ---- Delete confirmation ---------------------------------------------------------------------
  static String deleteTitle(String name) => 'Delete “$name”?';
  static const String deleteBody =
      'This removes the saved strategy and its\nrules from your notebook. This action\ncannot be undone.';
  static const String keepStrategy = 'Keep strategy';
  static const String deleting = 'Deleting…';
  static const String deleteFailed = 'Couldn’t delete right now. Try again.';

  // ---- Duplicate ------------------------------------------------------------------------------
  static const String duplicateTitle = 'A fresh take on\na familiar idea.';
  static const String duplicateSubtitle =
      'Keep the original and explore a variation.';
  static const String newStrategyName = 'New strategy name';
  static String copyName(String name) => '$name — copy';
  static const String duplicateHint =
      'All rules and allocation settings will\nbe copied. Your original stays unchanged.';
  static const String createCopy = 'Create copy';
  static const String creatingCopy = 'Creating copy…';
  static const String duplicateFailed = 'Couldn’t create the copy. Try again.';

  // ---- Learn ---------------------------------------------------------------------------------
  static const String learnTopBar = 'Learn with an example';
  static const String learnEyebrow = 'A 2-MINUTE GUIDE';
  static const String learnTitle = 'From an idea\nto a strategy.';
  static const String learnQuote =
      '“I want profitable companies with less debt.”';
  static const String learnStep1Title = 'Choose the starting pool';
  static const String learnStep1Body = 'Look within the Nifty 500.';
  static const String learnStep2Title = 'Set the quality bar';
  static const String learnStep2Body = 'ROE above 15%. Debt-to-equity below 1.';
  static const String learnStep3Title = 'Rank and spread the weight';
  static const String learnStep3Body =
      'Keep the top 15 by ROE. Weight equally.';
  static const String learnFootnote =
      'Illustrative example for learning.\nNot an investment recommendation.';
  static const String tryBuildingIt = 'Try building it';

  // ---- Preferences ----------------------------------------------------------------------------------
  static const String preferencesTitle = 'Your preferences';
  static const String preferencesSubtitle =
      'Make Kalpi work the way you think.';
  static const String investingExperience = 'Investing experience';
  static const String yourFocus = 'Your focus';
  static const String appearance = 'Appearance';
  static const String appearanceDark = 'Dark';
  static const String preferencesFootnote =
      'Guidance preferences don’t determine\nyour investment risk.';
  static const String demoSectionTitle = 'Demo settings';
  static const String simulateFailureTitle = 'Simulate save failure';
  static const String simulateFailureBody =
      'Makes the next save or delete fail so you can see the recovery flow.';
  static const String demoDataNotice =
      'This build stores strategies on this device only. No trades, market data or accounts are involved.';
  static const String notSet = 'Not set';

  // ---- Generic errors -----------------------------------------------------------------------------------
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String offlineErrorMessage = 'Connection interrupted';
}
