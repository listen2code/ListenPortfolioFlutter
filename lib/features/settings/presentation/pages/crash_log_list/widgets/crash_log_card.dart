import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../../shared/shared.dart';

class CrashLogCard extends StatelessWidget {
  final File file;
  final String name;
  final String date;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const CrashLogCard({
    super.key,
    required this.file,
    required this.name,
    required this.date,
    required this.onTap,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.f),
        side: BorderSide(color: context.theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.f, vertical: 12.f),
        leading: Container(
          padding: EdgeInsets.all(8.f),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.f),
          ),
          child: const Icon(Icons.description_outlined, color: Colors.redAccent),
        ),
        title: CommonText(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.f),
            CommonText(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 4.f),
            CommonClickable(
              ripple: false,
              onTap: () {
                Clipboard.setData(ClipboardData(text: file.path));
                CommonToast.show(I18nKeys.copiedToClipboard.tr);
              },
              semanticLabel: I18nKeys.copiedToClipboard.tr,
              child: CommonText(
                file.path,
                style: TextStyle(
                  fontSize: 10,
                  color: context.accentColor.withValues(alpha: 0.7),
                  decoration: TextDecoration.underline,
                  decorationColor: context.accentColor.withValues(alpha: 0.5),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onTap: onTap,
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
          onSelected: (value) {
            if (value == 'share') {
              onShare();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  const Icon(Icons.share_outlined, size: 20, color: Colors.blueAccent),
                  SizedBox(width: 12.f),
                  CommonText(I18nKeys.share.tr),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                  SizedBox(width: 12.f),
                  CommonText(I18nKeys.delete.tr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
