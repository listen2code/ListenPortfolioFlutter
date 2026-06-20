import 'dart:convert';
import 'dart:io';

void main() {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('Error: pubspec.yaml not found.');
    return;
  }

  final content = pubspecFile.readAsStringSync();
  final versionRegExp = RegExp(r'^version:\s*([^\s+]+)\+?(\d*)', multiLine: true);
  final match = versionRegExp.firstMatch(content);

  if (match == null) {
    print('Error: Could not parse version from pubspec.yaml');
    return;
  }

  final version = match.group(1);
  final buildNumber = int.tryParse(match.group(2) ?? '1') ?? 1;

  final descRegExp = RegExp('^desc:\\s*["\']?(.*?)["\']?\$', multiLine: true);
  final descZhRegExp = RegExp('^desc_zh:\\s*["\']?(.*?)["\']?\$', multiLine: true);
  final descEnRegExp = RegExp('^desc_en:\\s*["\']?(.*?)["\']?\$', multiLine: true);
  final descJaRegExp = RegExp('^desc_ja:\\s*["\']?(.*?)["\']?\$', multiLine: true);

  final descMatch = descRegExp.firstMatch(content);
  final descZhMatch = descZhRegExp.firstMatch(content);
  final descEnMatch = descEnRegExp.firstMatch(content);
  final descJaMatch = descJaRegExp.firstMatch(content);

  final defaultDesc = descMatch?.group(1) ?? 'Update to version $version';
  final descZh = descZhMatch?.group(1) ?? defaultDesc;
  final descEn = descEnMatch?.group(1) ?? defaultDesc;
  final descJa = descJaMatch?.group(1) ?? defaultDesc;

  final pagesVersionJsonFile = File('pages/version.json');
  final Map<String, dynamic> data = {
    'version': version,
    'buildNumber': buildNumber,
    'url': 'https://play.google.com/store/apps/details?id=com.listen.portfolio.listen_portfolio_flutter',
    'changelog': {
      'zh': descZh,
      'en': descEn,
      'ja': descJa
    }
  };

  // Preserve existing url if version.json exists in pages/
  if (pagesVersionJsonFile.existsSync()) {
    try {
      final existingData = json.decode(pagesVersionJsonFile.readAsStringSync()) as Map<String, dynamic>;
      data['url'] = existingData['url'] ?? data['url'];
    } catch (_) {}
  }

  final jsonContent = '${const JsonEncoder.withIndent('  ').convert(data)}\n';
  pagesVersionJsonFile.writeAsStringSync(jsonContent);
  print('Successfully generated version.json at pages/ with version: $version ($buildNumber)');
}
