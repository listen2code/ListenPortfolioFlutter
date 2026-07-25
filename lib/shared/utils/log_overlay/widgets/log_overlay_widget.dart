part of '../log_overlay_manager.dart';

class _LogOverlayWidget extends StatefulWidget {
  final Offset initialOffset;
  final Offset? initialWindowOffset;
  final Size? initialWindowSize;
  final bool startExpanded;
  final void Function(Offset) onPositionChanged;
  final void Function(Offset, Size) onWindowChanged;
  final VoidCallback onClose;

  const _LogOverlayWidget({
    required this.initialOffset,
    this.initialWindowOffset,
    this.initialWindowSize,
    this.startExpanded = false,
    required this.onPositionChanged,
    required this.onWindowChanged,
    required this.onClose,
  });

  @override
  State<_LogOverlayWidget> createState() => _LogOverlayWidgetState();
}

enum OverlayTab { logs, perf, network }

class _LogOverlayWidgetState extends State<_LogOverlayWidget> {
  late Offset buttonOffset; // Memory for floating button
  late Offset windowOffset; // Temporary position for expanded window
  late Size windowSize; // Dimensions of the expanded window
  late bool isExpanded;
  OverlayTab currentTab = OverlayTab.logs;
  final TextEditingController _traceController = TextEditingController();

  // Explicitly tracked playback progress state
  PlaybackProgress? _playbackProgress;

  static const double minWidth = 250.0;
  static const double minHeight = 200.0;
  static const double handleSize = 30.0;

  @override
  void initState() {
    super.initState();
    buttonOffset = widget.initialOffset;
    windowOffset = widget.initialWindowOffset ?? const Offset(0, 50);
    windowSize = widget.initialWindowSize ?? Size.zero;
    isExpanded = widget.startExpanded;

    _playbackProgress = MviPlaybackPlayer.instance.progress;

    // Start monitoring frame metrics on overlay initialization
    FrameMonitor.instance.start();

    _traceController.addListener(() {
      setState(() {});
    });
    // Listen to playback player progress changes to explicitly update local widget state
    MviPlaybackPlayer.instance.onProgressChanged = (progress) {
      if (mounted) {
        setState(() {
          _playbackProgress = progress;
        });
      }
    };

    // Listen to external trace linkage requests (e.g. from crash logs)
    LogOverlayManager.traceFilterNotifier.addListener(_onTraceFilterChanged);
  }

  @override
  void dispose() {
    // Stop frame timing callbacks to release resources
    FrameMonitor.instance.stop();
    _traceController.dispose();
    // Clean up playback progress listener
    MviPlaybackPlayer.instance.onProgressChanged = null;
    LogOverlayManager.traceFilterNotifier.removeListener(_onTraceFilterChanged);
    super.dispose();
  }

  void _onTraceFilterChanged() {
    final traceId = LogOverlayManager.traceFilterNotifier.value;
    if (traceId != null && traceId.isNotEmpty) {
      setState(() {
        _traceController.text = traceId;
        currentTab = OverlayTab.logs;
      });
    }
  }

  // Clamps and updates the relevant offset based on expansion state
  void _updateOffset(Offset delta, Size screenSize, Size widgetSize) {
    setState(() {
      if (isExpanded) {
        windowOffset += delta;
        // Clamp window within screen boundaries
        final double newX = windowOffset.dx.clamp(0, screenSize.width - windowSize.width);
        final double newY = windowOffset.dy.clamp(0, screenSize.height - windowSize.height);
        windowOffset = Offset(newX, newY);
        widget.onWindowChanged(windowOffset, windowSize);
      } else {
        buttonOffset += delta;
        // Clamp button
        final double newX = buttonOffset.dx.clamp(0, screenSize.width - widgetSize.width);
        final double newY = buttonOffset.dy.clamp(0, screenSize.height - widgetSize.height);
        buttonOffset = Offset(newX, newY);
        widget.onPositionChanged(buttonOffset);
      }
    });
  }

  // Logic to handle resizing from corners and edges
  void _handleResize(Offset delta, Alignment alignment, Size screenSize) {
    setState(() {
      double newX = windowOffset.dx;
      double yVal = windowOffset.dy;
      double newW = windowSize.width;
      double newH = windowSize.height;

      if (alignment == Alignment.topLeft) {
        newX += delta.dx;
        yVal += delta.dy;
        newW -= delta.dx;
        newH -= delta.dy;
      } else if (alignment == Alignment.topRight) {
        yVal += delta.dy;
        newW += delta.dx;
        newH -= delta.dy;
      } else if (alignment == Alignment.bottomLeft) {
        newX += delta.dx;
        newW -= delta.dx;
        newH += delta.dy;
      } else if (alignment == Alignment.bottomRight) {
        newW += delta.dx;
        newH += delta.dy;
      } else if (alignment == Alignment.bottomCenter) {
        newH += delta.dy;
      }

      // Enforce minimum size and screen boundaries
      if (newW >= minWidth && (newX >= 0 && newX + newW <= screenSize.width)) {
        windowOffset = Offset(newX, windowOffset.dy);
        windowSize = Size(newW, windowSize.height);
      }
      if (newH >= minHeight && (yVal >= 0 && yVal + newH <= screenSize.height)) {
        windowOffset = Offset(windowOffset.dx, yVal);
        windowSize = Size(windowSize.width, newH);
      }
      widget.onWindowChanged(windowOffset, windowSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Initialize default window size if not set (first expansion)
    if (windowSize == Size.zero && screenSize.width > 0) {
      windowSize = Size(screenSize.width, screenSize.height * 0.5);
    }

    // Clamp coordinates dynamically to prevent offset going out of screen boundaries (e.g. initial zero-size pollution during splash)
    final double safeButtonX = buttonOffset.dx.clamp(0.0, math.max(0.0, screenSize.width - 130.0));
    final double safeButtonY = buttonOffset.dy.clamp(0.0, math.max(0.0, screenSize.height - 50.0));

    final double safeWindowX = windowOffset.dx.clamp(
      0.0,
      math.max(0.0, screenSize.width - (windowSize.width > 0 ? windowSize.width : minWidth)),
    );
    final double safeWindowY = windowOffset.dy.clamp(
      0.0,
      math.max(0.0, screenSize.height - (windowSize.height > 0 ? windowSize.height : minHeight)),
    );

    return Positioned(
      left: isExpanded ? safeWindowX : safeButtonX,
      top: isExpanded ? safeWindowY : safeButtonY,
      child: Material(
        color: Colors.transparent,
        child: isExpanded ? _buildExpandedViewWithHandles(screenSize) : _buildFloatingButton(screenSize),
      ),
    );
  }

  Future<void> _showSaveDialog({bool shouldExpandAfter = false}) async {
    final controller = TextEditingController();
    await CommonDialog.showCustom<void>(
      title: I18nKeys.saveTape.tr,
      barrierDismissible: false,
      body: CommonTextField(
        controller: controller,
        hintText: I18nKeys.enterTapeName.tr,
      ),
      actions: [
        CommonButton(
          text: I18nKeys.discard.tr,
          type: ButtonType.text,
          foregroundColor: Colors.grey,
          isFullWidth: false,
          onPressed: () {
            MviPlaybackRecorder.instance.stopRecording();
            AppNav.back();
            CommonToast.show(I18nKeys.discardTapeMsg.tr);
          },
        ),
        CommonButton(
          text: I18nKeys.save.tr,
          type: ButtonType.text,
          isFullWidth: false,
          onPressed: () async {
            final name = await MviPlaybackRecorder.instance.stopRecording(customName: controller.text);
            AppNav.back();
            CommonToast.show(I18nKeys.saveTapeSuccessMsg.tr.replaceAll('%s', name));
            AppNav.to(Routes.playbackTapeList);
          },
        ),
      ],
    );
    if (mounted) {
      setState(() {
        if (shouldExpandAfter) {
          isExpanded = true;
        }
      });
    }
  }

  Widget _buildFloatingButton(Size screenSize) {
    final isRecording = MviPlaybackRecorder.instance.isRecording;

    // ignore: use_common_clickable
    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details.delta, screenSize, const Size(130, 50)),
      onTap: () {
        if (isRecording) {
          // Click to stop recording directly from the collapsed button,
          // prompt save dialog, and expand the log manager window upon completion.
          _showSaveDialog(shouldExpandAfter: false);
        } else {
          setState(() => isExpanded = true);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 130.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: Colors.white10, width: 0.5),
              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black45, offset: Offset(0, 4))],
            ),
            child: Row(
              children: [
                // Left-side circular control icon
                Container(
                  width: 50.0,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Icon(
                    isRecording
                        ? Icons.stop_rounded
                        : (_playbackProgress?.isPlaying == true
                              ? Icons.play_arrow_rounded
                              : Icons.bug_report_rounded),
                    color: isRecording
                        ? Colors.redAccent
                        : (_playbackProgress?.isPlaying == true ? Colors.blueAccent : Colors.greenAccent),
                    size: 26.0,
                  ),
                ),
                const VerticalDivider(color: Colors.white10, width: 1, indent: 10, endIndent: 10),
                // Right-side real-time FPS mini line chart
                const Expanded(child: Center(child: _FpsMiniChart())),
                const SizedBox(width: 8),
              ],
            ),
          ),
          if (_playbackProgress?.isPlaying == true &&
              _playbackProgress?.currentStepName.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: CommonText(
                '${_playbackProgress?.currentStepIndex}/${_playbackProgress?.totalSteps}\n${_playbackProgress?.currentStepName}',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedViewWithHandles(Size screenSize) {
    return Stack(
      children: [
        _buildWindowContent(screenSize),
        // Corner Resize Handles
        _buildResizeHandle(Alignment.topLeft, screenSize),
        _buildResizeHandle(Alignment.topRight, screenSize),
        _buildResizeHandle(Alignment.bottomLeft, screenSize),
        _buildResizeHandle(Alignment.bottomRight, screenSize),
        // Bottom Edge Resize Handle
        _buildResizeHandle(Alignment.bottomCenter, screenSize),
      ],
    );
  }

  Widget _buildResizeHandle(Alignment alignment, Size screenSize) {
    double? left, top, width, height;

    if (alignment == Alignment.bottomCenter) {
      left = handleSize;
      top = windowSize.height - handleSize;
      width = windowSize.width - (handleSize * 2);
      height = handleSize;
    } else {
      left = (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft)
          ? 0
          : windowSize.width - handleSize;
      top = (alignment == Alignment.topLeft || alignment == Alignment.topRight)
          ? 0
          : windowSize.height - handleSize;
      width = handleSize;
      height = handleSize;
    }

    return Positioned(
      left: left,
      top: top,
      // ignore: use_common_clickable
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) => _handleResize(details.delta, alignment, screenSize),
        child: Container(
          width: width,
          height: height,
          color: Colors.transparent, // Invisible interactive area
        ),
      ),
    );
  }

  Widget _headerTab(String label, OverlayTab tab) {
    final bool isSelected = currentTab == tab;
    return CommonClickable(
      onTap: () => setState(() => currentTab = tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.greenAccent.withValues(alpha: 0.3) : Colors.transparent,
            width: 0.5,
          ),
        ),
        child: CommonText(
          label,
          alignment: Alignment.center,
          style: TextStyle(
            color: isSelected ? Colors.greenAccent : Colors.white60,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWindowContent(Size screenSize) {
    return Container(
      width: windowSize.width,
      height: windowSize.height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 0.5),
        boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black54)],
      ),
      child: Column(
        children: [
          // Level 1: Draggable Header Bar
          // ignore: use_common_clickable
          GestureDetector(
            onPanUpdate: (details) => _updateOffset(details.delta, screenSize, windowSize),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bug_report_rounded, color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _headerTab(I18nKeys.tabLogs.tr, OverlayTab.logs),
                          const SizedBox(width: 4),
                          _headerTab(I18nKeys.tabPerf.tr, OverlayTab.perf),
                          const SizedBox(width: 4),
                          _headerTab(I18nKeys.tabNetwork.tr, OverlayTab.network),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildHeaderAction(Icons.fiber_manual_record, () {
                    if (!(_playbackProgress?.isPlaying ?? false)) {
                      MviPlaybackRecorder.instance.startRecording();
                      setState(() => isExpanded = false);
                      CommonToast.show(I18nKeys.recordingStartedMsg.tr);
                    }
                  }, color: Colors.red),
                  _buildHeaderAction(Icons.video_library_rounded, () {
                    if (!(_playbackProgress?.isPlaying ?? false)) {
                      setState(() => isExpanded = false);
                      AppNav.to(Routes.playbackTapeList);
                    }
                  }, color: Colors.blueAccent),
                  _buildHeaderAction(
                    Icons.close_fullscreen_rounded,
                    () => setState(() => isExpanded = false),
                  ),
                  _buildHeaderAction(
                    Icons.power_settings_new_rounded,
                    widget.onClose,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: currentTab == OverlayTab.logs
                ? _LogsInspectorTab(
                    traceController: _traceController,
                    onNavigateToPerf: (traceId) {
                      setState(() {
                        currentTab = OverlayTab.perf;
                        _traceController.text = traceId;
                      });
                    },
                  )
                : (currentTab == OverlayTab.perf
                      ? _PerfDashboardTab(traceFilter: _traceController.text)
                      : _NetworkInspectorTab(
                          traceController: _traceController,
                          onNavigateToLogs: (traceId) {
                            setState(() {
                              _traceController.text = traceId;
                              currentTab = OverlayTab.logs;
                            });
                          },
                        )),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap, {Color color = Colors.white70}) {
    return CommonClickable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 5, top: 5, bottom: 5),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
