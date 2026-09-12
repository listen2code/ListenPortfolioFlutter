import 'dart:convert';

/// Represents parsed referral data and deferred deep link metadata retrieved
/// from Google Play's Install Referrer API.
///
/// ### Architecture & Business Context:
/// When a user clicks a marketing link leading to Google Play (e.g., from an
/// invite, social post, or marketing email), custom parameters are appended
/// to the Play Store URL via the `&referrer=` query parameter.
/// Upon first application startup after installation, this class parses,
/// sanitizes, and structures that raw string to drive the personalized
/// onboarding dialog and automated deep-link navigation.
class InstallReferrerData {
  /// The raw, unparsed install referrer string returned directly by Google Play.
  /// Useful for debugging and offline diagnostic logging.
  final String rawReferrer;

  /// The primary referrer identifier / promotion code / inviter name (e.g., `refer=ListenCommunity`).
  /// This field is the mandatory gating key for triggering the welcome flow.
  final String? refer;

  /// Standard UTM Source parameter indicating marketing origin (e.g. `twitter`, `google`, `github`).
  final String? utmSource;

  /// Standard UTM Medium parameter indicating delivery vehicle (e.g. `cpc`, `social`, `readme`).
  final String? utmMedium;

  /// Standard UTM Campaign parameter identifying the marketing effort (e.g. `v1_launch`, `portfolio_promo`).
  final String? utmCampaign;

  /// Standard UTM Content parameter identifying creative variations (e.g. `banner_top`, `footer_link`).
  final String? utmContent;

  /// Standard UTM Term parameter identifying search keywords or audience segments.
  final String? utmTerm;

  /// Optional deep link destination route or tab identifier (e.g. `projects`, `aboutMe`, `settings`).
  /// Used by `HomeViewModel` to automatically navigate the user to their intended destination.
  final String? targetRoute;

  /// Timestamp in seconds (epoch) when the referral URL was clicked by the user.
  final int? clickTimestampSeconds;

  /// Timestamp in seconds (epoch) when the app installation process began on the device.
  final int? installTimestampSeconds;

  /// Indicates whether the application was launched as a Google Play Instant experience
  /// within the past 7 days.
  final bool googlePlayInstant;

  const InstallReferrerData({
    required this.rawReferrer,
    this.refer,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.utmContent,
    this.utmTerm,
    this.targetRoute,
    this.clickTimestampSeconds,
    this.installTimestampSeconds,
    this.googlePlayInstant = false,
  });

  /// An empty referral data instance representing natural installs without marketing attribution.
  static const empty = InstallReferrerData(rawReferrer: '');

  /// Evaluates whether genuine, intentional referral attribution is present.
  ///
  /// ### Design Note:
  /// Google Play frequently returns default organic tokens such as
  /// `utm_source=google-play&utm_medium=organic` or `utm_source=(not set)`.
  /// To prevent normal, non-referred users from incorrectly seeing the welcome
  /// modal, this property strictly requires a non-empty, sanitized [refer] key.
  bool get hasReferral => refer != null && refer!.trim().isNotEmpty;

  /// Returns a user-friendly display string representing the referral source,
  /// falling back to an empty string if unassigned.
  String get displaySource => (refer != null && refer!.trim().isNotEmpty) ? refer!.trim() : '';

  /// Sanitizes raw query parameter values, filtering out Google Play default
  /// placeholders, URL-encoded artifacts, and literal null strings.
  static String? _sanitizeValue(String? val) {
    if (val == null) return null;
    final trimmed = val.trim();
    if (trimmed.isEmpty) return null;

    final lower = trimmed.toLowerCase();
    if (lower == '(not set)' ||
        lower == 'not set' ||
        lower == '(not%20set)' ||
        lower == 'not%20set' ||
        lower == 'null' ||
        lower == '(null)' ||
        lower == 'undefined') {
      return null;
    }
    return trimmed;
  }

  /// Parses a raw install referrer string into structured [InstallReferrerData].
  ///
  /// ### Parsing Pipeline:
  /// 1. **URL Decoding**: Recursively decodes percent-encoded query components
  ///    (e.g., `refer%3DListenCommunity%26target%3Dprojects`).
  /// 2. **Query String Splitting**: Breaks tokens on `&` and `;` delimiters.
  /// 3. **Raw Code Fallback**: If the string is a single non-delimited promo code
  ///    (e.g., `Listen2026`), maps it directly to [refer].
  /// 4. **Placeholder Sanitization**: Passes all extracted values through [_sanitizeValue]
  ///    to discard `(not set)` and null strings.
  factory InstallReferrerData.fromRawReferrer(
    String raw, {
    int? clickTimestampSeconds,
    int? installTimestampSeconds,
    bool googlePlayInstant = false,
  }) {
    if (raw.trim().isEmpty) {
      return InstallReferrerData.empty;
    }

    String decoded = raw;
    // Attempt multi-level URL decoding if parameters are encoded (e.g., refer%3DListen)
    try {
      if (decoded.contains('%')) {
        decoded = Uri.decodeFull(decoded);
      }
    } catch (_) {}

    // Parse query parameters
    final params = _parseQueryString(decoded);

    // If query parameters weren't key-value formatted (e.g. just a raw code "Listen2026"), treat the raw string as refer
    String? rawRefer = params['refer'] ?? params['referrer'] ?? params['ref'] ?? params['source'];
    if (rawRefer == null && !raw.contains('=') && raw.trim().isNotEmpty) {
      rawRefer = raw.trim();
    }

    final refer = _sanitizeValue(rawRefer);
    final utmSource = _sanitizeValue(params['utm_source']);
    final utmMedium = _sanitizeValue(params['utm_medium']);
    final utmCampaign = _sanitizeValue(params['utm_campaign']);
    final utmContent = _sanitizeValue(params['utm_content']);
    final utmTerm = _sanitizeValue(params['utm_term']);
    final targetRoute = _sanitizeValue(params['target'] ?? params['route'] ?? params['tab']);

    return InstallReferrerData(
      rawReferrer: raw,
      refer: refer,
      utmSource: utmSource,
      utmMedium: utmMedium,
      utmCampaign: utmCampaign,
      utmContent: utmContent,
      utmTerm: utmTerm,
      targetRoute: targetRoute,
      clickTimestampSeconds: clickTimestampSeconds,
      installTimestampSeconds: installTimestampSeconds,
      googlePlayInstant: googlePlayInstant,
    );
  }

  /// Internal helper to parse key-value pairs from a query string,
  /// supporting both standard ampersands (`&`) and semicolons (`;`).
  static Map<String, String> _parseQueryString(String query) {
    final Map<String, String> result = {};
    if (query.isEmpty) return result;

    // Strip leading '?' if present
    final String cleanQuery = query.startsWith('?') ? query.substring(1) : query;

    // Handle standard ampersand-separated pairs and semicolon-separated pairs
    final pairs = cleanQuery.split(RegExp(r'[;&]'));
    for (final pair in pairs) {
      if (pair.isEmpty) continue;
      final splitIndex = pair.indexOf('=');
      if (splitIndex > 0) {
        final key = pair.substring(0, splitIndex).trim();
        final rawVal = pair.substring(splitIndex + 1).trim();
        try {
          result[key] = Uri.decodeComponent(rawVal);
        } catch (_) {
          result[key] = rawVal;
        }
      }
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'rawReferrer': rawReferrer,
      'refer': refer,
      'utmSource': utmSource,
      'utmMedium': utmMedium,
      'utmCampaign': utmCampaign,
      'utmContent': utmContent,
      'utmTerm': utmTerm,
      'targetRoute': targetRoute,
      'clickTimestampSeconds': clickTimestampSeconds,
      'installTimestampSeconds': installTimestampSeconds,
      'googlePlayInstant': googlePlayInstant,
    };
  }

  factory InstallReferrerData.fromJson(Map<String, dynamic> json) {
    return InstallReferrerData(
      rawReferrer: json['rawReferrer'] as String? ?? '',
      refer: json['refer'] as String?,
      utmSource: json['utmSource'] as String?,
      utmMedium: json['utmMedium'] as String?,
      utmCampaign: json['utmCampaign'] as String?,
      utmContent: json['utmContent'] as String?,
      utmTerm: json['utmTerm'] as String?,
      targetRoute: json['targetRoute'] as String?,
      clickTimestampSeconds: json['clickTimestampSeconds'] as int?,
      installTimestampSeconds: json['installTimestampSeconds'] as int?,
      googlePlayInstant: json['googlePlayInstant'] as bool? ?? false,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static InstallReferrerData? fromJsonString(String? jsonStr) {
    if (jsonStr == null || jsonStr.trim().isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return InstallReferrerData.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() =>
      'InstallReferrerData(refer: $refer, utmSource: $utmSource, target: $targetRoute, raw: $rawReferrer)';
}
