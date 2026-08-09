import 'models.dart';
import 'score_engine.dart';

/// Future ML-backed scorer. Rails only — delegates to [RuleBasedScoreEngine] for now.
///
/// Later: load `DecisionTreeClassifier.fromJson(...)` and map diagnostic features.
class MlScoreEngine implements ScoreEngine {
  MlScoreEngine({ScoreEngine? fallback})
      : _fallback = fallback ?? const RuleBasedScoreEngine();

  final ScoreEngine _fallback;

  /// Placeholder for a serialized ml_algo model JSON.
  String? modelJson;

  @override
  ScoreResult score(BusinessDiagnostic diagnostic) {
    // TODO: when modelJson is set, run DecisionTreeClassifier.fromJson(modelJson)
    // and map prediction to ScoreResult. Until then, rules.
    return _fallback.score(diagnostic);
  }
}
