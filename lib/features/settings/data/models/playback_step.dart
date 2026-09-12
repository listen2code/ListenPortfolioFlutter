import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_step.freezed.dart';
part 'playback_step.g.dart';

/// Represents an individual chronological step within an MVI recorded tape.
///
/// An MVI tape consists of an ordered sequence of these steps. Step 0 is typically
/// an [initState] snapshot, followed by a sequence of [intent], [effect], and [pop] steps.
///
/// Design Pattern:
/// - **Freezed Immutable Model**: Generates `copyWith`, equality operators, and JSON converters.
/// - **Polymorphic Action Tagging**: The [type] field distinguishes between initial state baselines,
///   user domain intents, emitted UI effects, and navigation stack pops.
@freezed
abstract class PlaybackStep with _$PlaybackStep {
  /// Step type representing a baseline environment snapshot containing persistent storage and credentials.
  static const String initState = 'INITIAL_STATE';

  /// Step type representing a user action dispatched to a [BaseViewModel] (e.g. `LoginIntent.submit()`).
  static const String intent = 'INTENT';

  /// Step type representing a UI side-effect emitted by a [BaseViewModel] (e.g. `MessageEffect`, `NavigationEffect`).
  ///
  /// Captured primarily for auditing and log verification; not directly executed during playback
  /// because replaying intents naturally re-triggers effects.
  static const String effect = 'EFFECT';

  /// Step type representing a route pop operation (AppBar back, Android physical back, iOS swipe-back, or dialog dismiss).
  static const String pop = 'POP';

  /// Tag used for system-level actions (e.g. Initial state or Navigator pops) that are not tied to a specific ViewModel.
  static const String system = 'system';

  /// Key identifier within the initial state JSON payload for SharedPreferences snapshot data.
  static const String sp = 'sp';

  /// Key identifier within the initial state JSON payload for FlutterSecureStorage credential data.
  static const String secure = 'secure';

  const factory PlaybackStep({
    /// The discriminator category of this step ([initState], [intent], [effect], or [pop]).
    required String type,

    /// Unique tag of the target [BaseViewModel] (or [system] for non-ViewModel framework actions).
    required String viewModelTag,

    /// Serialized signature or payload of the action (e.g. `LoginIntent.inputAccount(account: test@example.com)`
    /// or JSON snapshot string for [initState]).
    required String name,

    /// Optional active named route identifier where the action originated (e.g. `/login_view` or `/settings`).
    String? route,

    /// Unix epoch timestamp in milliseconds when the step was captured.
    required int timestamp,
  }) = _PlaybackStep;

  /// Creates a [PlaybackStep] from a decoded JSON map.
  factory PlaybackStep.fromJson(Map<String, dynamic> json) => _$PlaybackStepFromJson(json);
}

