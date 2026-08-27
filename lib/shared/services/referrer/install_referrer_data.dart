import 'dart:convert';

/// Represents parsed referral data and deferred deep link information from Google Play Install Referrer.
class InstallReferrerData {
  /// The raw install referrer string returned by Google Play.
  final String rawReferrer;

  /// The primary referrer identifier / promotion code / invitee name (e.g., `refer=ListenCommunity`).
  final String? refer;

  /// UTM Source (e.g. `twitter`, `google`, `github`).
  final String? utmSource;

  /// UTM Medium (e.g. `cpc`, `social`, `readme`).
  final String? utmMedium;

  /// UTM Campaign (e.g. `v1_launch`, `portfolio_promo`).
  final String? utmCampaign;

  /// UTM Content (e.g. `banner_top`, `footer_link`).
  final String? utmContent;

  /// UTM Term (e.g. `flutter_developer`, `portfolio`).
  final String? utmTerm;

  /// Optional deep link target route or tab (e.g. `projects`, `aboutMe`, `settings`).
  final String? targetRoute;

  /// Timestamp in seconds when the referral URL was clicked.
  final int? clickTimestampSeconds;

  /// Timestamp in seconds when the install began.
  final int? installTimestampSeconds;

  /// Indicates whether the app was launched as a Google Play Instant experience.
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

  /// An empty referral data instance.
  static const empty = InstallReferrerData(rawReferrer: '');

  /// Checks if valid referral information is present.
  bool get hasReferral =>
      (refer != null && refer!.trim().isNotEmpty) ||
      (utmSource != null && utmSource!.trim().isNotEmpty) ||
      (utmCampaign != null && utmCampaign!.trim().isNotEmpty);

  /// Returns a user-friendly display string for the referral source.
  String get displaySource {
    if (refer != null && refer!.trim().isNotEmpty) {
      return refer!.trim();
    }
    if (utmSource != null && utmSource!.trim().isNotEmpty) {
      if (utmCampaign != null && utmCampaign!.trim().isNotEmpty) {
        return '${utmSource!.trim()} (${utmCampaign!.trim()})';
      }
      return utmSource!.trim();
    }
    if (rawReferrer.trim().isNotEmpty) {
      return rawReferrer.trim();
    }
    return '';
  }

  /// Parses a raw install referrer string into structured [InstallReferrerData].
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
    String? refer = params['refer'] ?? params['referrer'] ?? params['ref'] ?? params['source'];
    if (refer == null && !raw.contains('=') && raw.trim().isNotEmpty) {
      refer = raw.trim();
    }

    final utmSource = params['utm_source'];
    final utmMedium = params['utm_medium'];
    final utmCampaign = params['utm_campaign'];
    final utmContent = params['utm_content'];
    final utmTerm = params['utm_term'];
    final targetRoute = params['target'] ?? params['route'] ?? params['tab'];

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
