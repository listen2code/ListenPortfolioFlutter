import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum _ImageType { asset, network, file }

/// A unified image component supporting assets, network (with caching), disk files, SVG, and optimized GIFs.
class CommonImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final double borderRadius;
  final _ImageType _type;

  /// Limits the decoded image size in memory to prevent crashes with large images.
  final int? memCacheWidth;
  final int? memCacheHeight;

  const CommonImage.asset(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.borderRadius = 0,
  }) : _type = _ImageType.asset,
       memCacheWidth = null,
       memCacheHeight = null;

  const CommonImage.url(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius = 0,
    this.memCacheWidth,
    this.memCacheHeight,
  }) : _type = _ImageType.network;

  // Removed 'const' because file.path is evaluated at runtime
  CommonImage.file(
    File file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius = 0,
  }) : source = file.path,
       _type = _ImageType.file,
       memCacheWidth = null,
       memCacheHeight = null;

  @override
  Widget build(BuildContext context) {
    Widget image;

    final isSvg = source.toLowerCase().endsWith('.svg');
    final isGif = source.toLowerCase().endsWith('.gif');

    if (isSvg) {
      image = _buildSvgImage();
    } else if (isGif && _type == _ImageType.network) {
      image = _buildNativelyHandledNetworkImage(context);
    } else {
      switch (_type) {
        case _ImageType.asset:
          image = _buildAssetImage();
          break;
        case _ImageType.network:
          image = _buildCachedNetworkImage(context);
          break;
        case _ImageType.file:
          image = _buildFileImage();
          break;
      }
    }

    if (borderRadius > 0) {
      return ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: image);
    }

    return image;
  }

  Widget _buildSvgImage() {
    if (_type == _ImageType.asset) {
      return SvgPicture.asset(
        source,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else if (_type == _ImageType.file) {
      return SvgPicture.file(
        File(source),
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else {
      return SvgPicture.network(
        source,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        placeholderBuilder: (context) => _buildPlaceholder(context),
      );
    }
  }

  Widget _buildAssetImage() {
    return Image.asset(source, width: width, height: height, fit: fit, color: color);
  }

  Widget _buildFileImage() {
    return Image.file(File(source), width: width, height: height, fit: fit, color: color);
  }

  Widget _buildCachedNetworkImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: source,
      width: width,
      height: height,
      fit: fit,
      color: color,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, url) => _buildPlaceholder(context),
      errorWidget: (context, url, error) => _buildErrorWidget(context),
    );
  }

  Widget _buildNativelyHandledNetworkImage(BuildContext context) {
    return Image.network(
      source,
      width: width,
      height: height,
      fit: fit,
      color: color,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder(context);
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Smooth gradient placeholder replacing the spinner
        gradient: LinearGradient(
          colors: [
            theme.dividerColor.withValues(alpha: 0.05),
            theme.dividerColor.withValues(alpha: 0.1),
            theme.dividerColor.withValues(alpha: 0.05),
          ],
          begin: const Alignment(-1.0, -0.5),
          end: const Alignment(1.0, 0.5),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      color: theme.dividerColor.withValues(alpha: 0.1),
      child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 24),
    );
  }
}
