import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/shared.dart';

part 'home_state.freezed.dart';

/// Enum to manage home page tabs instead of hardcoded indices
enum HomeTab { overview, aboutMe, projects, architecture }

@freezed
abstract class HomeState extends BaseState with _$HomeState {
  const factory HomeState({@Default(HomeTab.overview) HomeTab currentTab}) = _HomeState;

  const HomeState._();

  /// Logic to resolve the title based on the current tab
  String get title {
    switch (currentTab) {
      case HomeTab.aboutMe:
        return authManager.state.isAuthor ? I18nKeys.aboutMe.tr : I18nKeys.aboutAuthor.tr;
      case HomeTab.projects:
        return authManager.state.isAuthor ? I18nKeys.projects.tr : I18nKeys.authorProjects.tr;
      case HomeTab.architecture:
        return I18nKeys.architecture.tr;
      case HomeTab.overview:
        return '';
    }
  }
}
