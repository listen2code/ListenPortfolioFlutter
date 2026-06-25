import 'package:flutter/material.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'architecture_intent.dart';
import 'architecture_state.dart';
import 'architecture_view_model.dart';
import 'widgets/architecture_section_card.dart';
import 'widgets/architecture_skeleton.dart';

class ArchitectureWidget extends StatelessWidget {
  final bool active;

  const ArchitectureWidget({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return BaseRefreshPage<ArchitectureViewModel, ArchitectureState>(
      provider: architectureViewModelProvider,
      useScaffold: false,
      active: active,
      onLoading: const ArchitectureSkeleton(),
      onRefresh: (viewModel, state) async {
        viewModel.handleIntent(const ArchitectureIntent.refresh());
      },
      body: (context, child, viewModel, state) {
        if (state.sections.isEmpty) return null;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.f),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.header != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 30.f),
                  child: CommonText(
                    state.header!,
                    style: context.textTheme.bodyLarge?.copyWith(color: Colors.grey, height: 1.5),
                    useFittedBox: false,
                  ),
                ),
              ...state.sections.map(
                (section) => ArchitectureSectionCard(section: section, viewModel: viewModel),
              ),
              SizedBox(height: 30.f),
            ],
          ),
        );
      },
    );
  }
}
