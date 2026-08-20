// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final lcovFile = File('coverage/lcov.info');
  if (!lcovFile.existsSync()) {
    print('coverage/lcov.info not found. Please run: flutter test --coverage');
    return;
  }

  final lines = lcovFile.readAsLinesSync();
  int totalLF = 0;
  int totalLH = 0;

  final Map<String, List<int>> moduleCoverage = {}; // module -> [LH, LF]
  final List<Map<String, dynamic>> fileCoverages = [];

  String? currentFile;
  int currentLF = 0;
  int currentLH = 0;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3).trim().replaceAll('\\', '/');
      currentLF = 0;
      currentLH = 0;
    } else if (line.startsWith('LF:')) {
      currentLF = int.parse(line.substring(3).trim());
    } else if (line.startsWith('LH:')) {
      currentLH = int.parse(line.substring(3).trim());
    } else if (line == 'end_of_record') {
      if (currentFile != null && currentLF > 0) {
        // Exclude generated files like .g.dart, .freezed.dart
        if (!currentFile.endsWith('.g.dart') && !currentFile.endsWith('.freezed.dart')) {
          totalLF += currentLF;
          totalLH += currentLH;

          // Determine module
          String module = 'other';
          if (currentFile.contains('lib/features/auth/')) {
            module = 'features/auth';
          } else if (currentFile.contains('lib/features/ai_chat/')) {
            module = 'features/ai_chat';
          } else if (currentFile.contains('lib/features/home/')) {
            module = 'features/home';
          } else if (currentFile.contains('lib/features/settings/')) {
            module = 'features/settings';
          } else if (currentFile.contains('lib/features/fault_injection/')) {
            module = 'features/fault_injection';
          } else if (currentFile.contains('lib/features/splash/')) {
            module = 'features/splash';
          } else if (currentFile.contains('lib/shared/')) {
            module = 'shared';
          } else if (currentFile.contains('lib/core/')) {
            module = 'core';
          }

          moduleCoverage.putIfAbsent(module, () => [0, 0]);
          moduleCoverage[module]![0] += currentLH;
          moduleCoverage[module]![1] += currentLF;

          final double filePercent = (currentLH / currentLF) * 100;
          fileCoverages.add({
            'file': currentFile,
            'lh': currentLH,
            'lf': currentLF,
            'percent': filePercent,
          });
        }
      }
    }
  }

  print('====================================================');
  print('📊 OVERALL CODE COVERAGE (Excluding generated code):');
  print('====================================================');
  final double overallPercent = totalLF > 0 ? (totalLH / totalLF) * 100 : 0;
  print('Total Lines: $totalLF');
  print('Lines Hit:   $totalLH');
  print('Coverage:    ${overallPercent.toStringAsFixed(2)}%');
  print('');

  print('====================================================');
  print('📦 MODULE BREAKDOWN:');
  print('====================================================');
  final sortedModules = moduleCoverage.keys.toList()..sort();
  for (final module in sortedModules) {
    final stats = moduleCoverage[module]!;
    final lh = stats[0];
    final lf = stats[1];
    final pct = lf > 0 ? (lh / lf) * 100 : 0;
    print('${module.padRight(25)}: ${pct.toStringAsFixed(2).padLeft(6)}% ($lh / $lf lines)');
  }
  print('');

  print('====================================================');
  print('🏆 TOP COVERED MODULES / CRITICAL PATHS:');
  print('====================================================');
  final highCoverage = fileCoverages.where((f) => (f['percent'] as double) >= 90).length;
  final medCoverage = fileCoverages.where((f) => (f['percent'] as double) >= 70 && (f['percent'] as double) < 90).length;
  final lowCoverage = fileCoverages.where((f) => (f['percent'] as double) < 70).length;
  print('Files >= 90% coverage: $highCoverage');
  print('Files 70% - 89% coverage: $medCoverage');
  print('Files < 70% coverage: $lowCoverage');
  print('Total Source Files: ${fileCoverages.length}');
}
