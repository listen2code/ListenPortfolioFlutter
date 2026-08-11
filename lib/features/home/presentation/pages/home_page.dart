import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../shared/shared.dart';
import 'about_me/about_me_intent.dart';
import 'about_me/about_me_view_model.dart';
import 'about_me/about_me_widget.dart';
import 'architecture/architecture_widget.dart';
import 'home_intent.dart';
import 'home_state.dart';
import 'home_view_model.dart';
import 'overview/overview_widget.dart';
import 'projects/projects_widget.dart';

import 'package:flutter/services.dart';
import 'widgets/home_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return BaseRefreshPage<HomeViewModel, HomeState>(
      provider: homeViewModelProvider,
      title: state.title,
      drawer: HomeDrawer(viewModel: viewModel, state: state),
      drawerEnableOpenDragGesture: false,
      canPop:
          false, // Always intercept system back gesture on home screen to handle tab change or double back exit
      actions: state.currentTab == HomeTab.aboutMe
          ? [
              Consumer(
                builder: (context, ref, child) {
                  return CommonIconButton(
                    icon: const Icon(Icons.share_outlined),
                    tooltip: I18nKeys.shareApp.tr,
                    onPressed: () {
                      ref
                          .read(aboutMeViewModelProvider.notifier)
                          .handleIntent(const AboutMeIntent.shareApp());
                    },
                  );
                },
              ),
            ]
          : null,
      onInterceptBack: () async {
        if (state.currentTab != HomeTab.overview) {
          viewModel.handleIntent(const HomeIntent.tabChanged(HomeTab.overview));
        } else {
          final now = DateTime.now();
          if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
            _lastPressedAt = now;
            CommonToast.show(I18nKeys.pressBackAgainToExit.tr);
          } else {
            await LocalMockServer.stop();
            SystemNavigator.pop();
          }
        }
      },
      onLoading: _buildOverviewSkeleton(context),
      isEmptyTitle: false,
      body: (context, child, viewModel, state) {
        // Use IndexedStack to persist sub-page states while driving lifecycles via active flag
        return IndexedStack(
          index: state.currentTab.index,
          children: [
            RepaintBoundary(
              child: OverviewWidget(active: state.currentTab == HomeTab.overview, homeViewModel: viewModel),
            ),
            RepaintBoundary(child: AboutMeWidget(active: state.currentTab == HomeTab.aboutMe)),
            RepaintBoundary(child: ProjectsWidget(active: state.currentTab == HomeTab.projects)),
            RepaintBoundary(child: ArchitectureWidget(active: state.currentTab == HomeTab.architecture)),
          ],
        );
      },
    );
  }

  Widget _buildOverviewSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.f, vertical: 20.f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonSkeleton.line(width: 180.f, height: 28.f),
          SizedBox(height: 12.f),
          CommonSkeleton.line(width: 260.f, height: 16.f),
          SizedBox(height: 24.f),
          CommonSkeleton(width: double.infinity, height: 100.f, borderRadius: 20.f),
          SizedBox(height: 12.f),
          Row(
            children: [
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
              SizedBox(width: 12.f),
              Expanded(
                child: CommonSkeleton(height: 80.f, borderRadius: 20.f),
              ),
            ],
          ),
          SizedBox(height: 40.f),
          const CommonSkeletonListTile(),
          const CommonSkeletonListTile(),
        ],
      ),
    );
  }
}
