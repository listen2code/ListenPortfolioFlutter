part of '../log_overlay_manager.dart';

class _NetworkInspectorTab extends StatefulWidget {
  final TextEditingController traceController;
  final ValueChanged<String> onNavigateToLogs;

  const _NetworkInspectorTab({
    required this.traceController,
    required this.onNavigateToLogs,
  });

  @override
  State<_NetworkInspectorTab> createState() => _NetworkInspectorTabState();
}

class _NetworkInspectorTabState extends State<_NetworkInspectorTab> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter and Action Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white.withValues(alpha: 0.01),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Icon(Icons.search, size: 14, color: Colors.white30),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: const TextTheme(
                              bodyLarge: TextStyle(color: Colors.white, fontSize: 12),
                              titleMedium: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                          ),
                          child: CommonTextField(
                            controller: _searchController,
                            hintText: 'Filter URL, status, traceId...',
                            onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty) ...[
                        CommonClickable(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(Icons.clear, size: 14, color: Colors.white30),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CommonClickable(
                onTap: () => NetworkInspectorStore.instance.clear(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2), width: 0.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 13),
                      SizedBox(width: 4),
                      CommonText(
                        'Clear',
                        style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white10, height: 1),

        // Requests List
        Expanded(
          child: ValueListenableBuilder<List<NetworkRequestEntry>>(
            valueListenable: NetworkInspectorStore.instance.requestsNotifier,
            builder: (context, requests, _) {
              final filtered = requests.where((req) {
                if (_searchQuery.isEmpty) return true;
                return req.url.toLowerCase().contains(_searchQuery) ||
                    req.method.toLowerCase().contains(_searchQuery) ||
                    (req.statusCode?.toString().contains(_searchQuery) ?? false) ||
                    req.traceId.toLowerCase().contains(_searchQuery);
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 28, color: Colors.white.withValues(alpha: 0.15)),
                      const SizedBox(height: 8),
                      CommonText(
                        _searchQuery.isNotEmpty ? 'No matching requests' : 'No network activity captured',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11),
                      ),
                    ],
                  ),
                );
              }

              // Display newest requests at the top
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final req = filtered[filtered.length - 1 - index];
                  return _RequestRowWidget(
                    request: req,
                    onNavigateToLogs: widget.onNavigateToLogs,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RequestRowWidget extends StatefulWidget {
  final NetworkRequestEntry request;
  final ValueChanged<String> onNavigateToLogs;

  const _RequestRowWidget({
    required this.request,
    required this.onNavigateToLogs,
  });

  @override
  State<_RequestRowWidget> createState() => _RequestRowWidgetState();
}

class _RequestRowWidgetState extends State<_RequestRowWidget> {
  bool _isExpanded = false;

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.blueAccent;
      case 'POST':
        return Colors.greenAccent;
      case 'PUT':
        return Colors.orangeAccent;
      case 'DELETE':
        return Colors.redAccent;
      default:
        return Colors.purpleAccent;
    }
  }

  Color _getStatusColor(int? statusCode) {
    if (statusCode == null || statusCode == 0) return Colors.white30;
    if (statusCode >= 200 && statusCode < 300) return Colors.greenAccent;
    if (statusCode >= 300 && statusCode < 400) return Colors.cyanAccent;
    if (statusCode >= 400 && statusCode < 500) return Colors.amberAccent;
    return Colors.redAccent;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}.${(time.millisecond).toString().padLeft(3, '0')}';
  }

  String _prettyPrintBody(dynamic body) {
    if (body == null) return 'Empty';
    try {
      const encoder = JsonEncoder.withIndent('  ');
      if (body is String) {
        return encoder.convert(jsonDecode(body));
      }
      return encoder.convert(body);
    } catch (_) {
      return body.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final methodColor = _getMethodColor(req.method);
    final statusColor = _getStatusColor(req.statusCode);

    return Column(
      children: [
        // Primary Request Header Clickable Card
        CommonClickable(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: _isExpanded ? Colors.white.withValues(alpha: 0.02) : Colors.transparent,
            child: Row(
              children: [
                // Method Tag
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: methodColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: methodColor.withValues(alpha: 0.25), width: 0.5),
                  ),
                  child: CommonText(
                    req.method,
                    style: TextStyle(color: methodColor, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),

                // Path & Time Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        req.path.isNotEmpty ? req.path : '/',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      CommonText(
                        _formatTime(req.requestTime),
                        style: const TextStyle(color: Colors.white30, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Status & Duration
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CommonText(
                      req.statusCode == null || req.statusCode == 0
                          ? 'PENDING'
                          : req.statusCode.toString(),
                      style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3),
                    CommonText(
                      req.statusCode == null ? '-- ms' : '${req.durationMs} ms',
                      style: const TextStyle(color: Colors.white54, fontSize: 9),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white30,
                  size: 16,
                ),
              ],
            ),
          ),
        ),

        // Expanded Detail Section
        if (_isExpanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            color: Colors.white.withValues(alpha: 0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.white10, height: 12),

                // Action Bar (Drill Logs & Copy APIs)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (req.traceId.isNotEmpty && req.traceId != 'no-trace-id')
                        CommonClickable(
                          onTap: () => widget.onNavigateToLogs(req.traceId),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3), width: 0.5),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.zoom_in_rounded, color: Colors.greenAccent, size: 12),
                                SizedBox(width: 4),
                                CommonText(
                                  'Drill Logs',
                                  style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      CommonClickable(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: req.url));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL copied to clipboard'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white12, width: 0.5),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.copy_all_rounded, color: Colors.white54, size: 12),
                              SizedBox(width: 4),
                              CommonText(
                                'Copy URL',
                                style: TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Details Fields
                _buildMetadataBlock('Full URL', req.url),
                if (req.traceId.isNotEmpty)
                  _buildMetadataBlock('Trace ID', req.traceId),
                if (req.errorMessage != null)
                  _buildMetadataBlock('Error Message', req.errorMessage!, valueColor: Colors.redAccent),

                const SizedBox(height: 8),
                _buildCollapsibleSection('Request Headers', _prettyPrintBody(req.headers)),
                if (req.requestBody != null)
                  _buildCollapsibleSection('Request Payload', _prettyPrintBody(req.requestBody)),
                if (req.responseBody != null)
                  _buildCollapsibleSection('Response Payload', _prettyPrintBody(req.responseBody)),
              ],
            ),
          ),
        const Divider(color: Colors.white10, height: 1),
      ],
    );
  }

  Widget _buildMetadataBlock(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            label,
            style: const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          SelectableText(
            value,
            style: TextStyle(color: valueColor ?? Colors.white70, fontSize: 10, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection(String title, String content) {
    return _CollapsibleCard(title: title, content: content);
  }
}

class _CollapsibleCard extends StatefulWidget {
  final String title;
  final String content;

  const _CollapsibleCard({required this.title, required this.content});

  @override
  State<_CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends State<_CollapsibleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonClickable(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CommonText(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: Colors.white54,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SelectableText(
                    widget.content,
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 9.5, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
