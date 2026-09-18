part of 'builder_cubit.dart';

enum BuilderMode { create, edit }

enum SaveStatus { idle, pending, failure, success }

/// The five builder steps. The first four are numbered in the header.
enum BuilderStep {
  universe('universe', 1),
  filters('filters', 2),
  ranking('ranking', 3),
  allocation('allocation', 4),
  review('review', null);

  const BuilderStep(this.path, this.number);

  /// URL segment.
  final String path;

  /// 1-based position shown as `n/4`; null for review.
  final int? number;

  static const int numberedCount = 4;

  static BuilderStep fromPath(String? path) => BuilderStep.values.firstWhere(
    (s) => s.path == path,
    orElse: () => BuilderStep.universe,
  );

  BuilderStep? get next => switch (this) {
    BuilderStep.universe => BuilderStep.filters,
    BuilderStep.filters => BuilderStep.ranking,
    BuilderStep.ranking => BuilderStep.allocation,
    BuilderStep.allocation => BuilderStep.review,
    BuilderStep.review => null,
  };

  BuilderStep? get previous => switch (this) {
    BuilderStep.universe => null,
    BuilderStep.filters => BuilderStep.universe,
    BuilderStep.ranking => BuilderStep.filters,
    BuilderStep.allocation => BuilderStep.ranking,
    BuilderStep.review => BuilderStep.allocation,
  };
}

class BuilderState extends Equatable {
  const BuilderState({
    this.isActive = false,
    this.mode = BuilderMode.create,
    this.editingId,
    this.editingRevision,
    this.editingName = '',
    this.isCopy = false,
    required this.draft,
    required this.original,
    this.returnToReview = false,
    this.saveStatus = SaveStatus.idle,
    this.saveError,
    this.savedStrategy,
    this.nameError,
    this.validationError,
    this.saveAttempt = 0,
  });

  factory BuilderState.inactive() {
    final blank = StrategyDraft.blank();
    return BuilderState(draft: blank, original: blank);
  }

  final bool isActive;
  final BuilderMode mode;
  final String? editingId;
  final String? editingRevision;

  /// Name of the strategy being edited, for the header.
  final String editingName;

  /// True when editing a freshly created copy.
  final bool isCopy;
  final StrategyDraft draft;
  final StrategyDraft original;

  /// When true, step pages offer "Review changes" and return to review.
  final bool returnToReview;
  final SaveStatus saveStatus;
  final String? saveError;
  final Strategy? savedStrategy;

  /// Inline error under the name field.
  final String? nameError;

  /// Non-name validation problem surfaced on the review screen.
  final String? validationError;

  /// Bumps on every save attempt so listeners can react to repeats.
  final int saveAttempt;

  bool get isEdit => mode == BuilderMode.edit;
  bool get isSaving => saveStatus == SaveStatus.pending;
  bool get isDirty => draft != original;

  /// Whether leaving should ask for confirmation.
  bool get shouldConfirmExit => isEdit ? isDirty : true;

  BuilderState copyWith({
    bool? isActive,
    BuilderMode? mode,
    String? editingId,
    String? editingRevision,
    String? editingName,
    bool? isCopy,
    StrategyDraft? draft,
    StrategyDraft? original,
    bool? returnToReview,
    SaveStatus? saveStatus,
    String? saveError,
    bool clearSaveError = false,
    Strategy? savedStrategy,
    bool clearSavedStrategy = false,
    String? nameError,
    bool clearNameError = false,
    String? validationError,
    bool clearValidationError = false,
    int? saveAttempt,
  }) => BuilderState(
    isActive: isActive ?? this.isActive,
    mode: mode ?? this.mode,
    editingId: editingId ?? this.editingId,
    editingRevision: editingRevision ?? this.editingRevision,
    editingName: editingName ?? this.editingName,
    isCopy: isCopy ?? this.isCopy,
    draft: draft ?? this.draft,
    original: original ?? this.original,
    returnToReview: returnToReview ?? this.returnToReview,
    saveStatus: saveStatus ?? this.saveStatus,
    saveError: clearSaveError ? null : (saveError ?? this.saveError),
    savedStrategy: clearSavedStrategy
        ? null
        : (savedStrategy ?? this.savedStrategy),
    nameError: clearNameError ? null : (nameError ?? this.nameError),
    validationError: clearValidationError
        ? null
        : (validationError ?? this.validationError),
    saveAttempt: saveAttempt ?? this.saveAttempt,
  );

  @override
  List<Object?> get props => <Object?>[
    isActive,
    mode,
    editingId,
    editingRevision,
    editingName,
    isCopy,
    draft,
    original,
    returnToReview,
    saveStatus,
    saveError,
    savedStrategy,
    nameError,
    validationError,
    saveAttempt,
  ];
}
