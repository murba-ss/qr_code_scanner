import 'dart:ui';

import 'package:flutter/material.dart';

class QrScannerCustomOverlayShape extends ShapeBorder {
  final Color overlayColor;
  final double borderRadius;
  final double cutOutSize;

  QrScannerCustomOverlayShape({
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 40),
    this.borderRadius = 10,
    this.cutOutSize = 250,
  }) : assert(
            cutOutSize != null,
            "Border can't be Null");

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final _cutOutSize = cutOutSize != null && cutOutSize < width
        ? cutOutSize
        : width;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final boxPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.clear;

    final cutOutRect = Rect.fromLTWH(
      width / 2 - _cutOutSize / 2,
      height / 2 - _cutOutSize / 2,
      _cutOutSize,
      _cutOutSize,
    );

    canvas.saveLayer(
      rect,
      backgroundPaint,
    );

    canvas
      ..drawRect(
        rect,
        backgroundPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerCustomOverlayShape(
      overlayColor: overlayColor,
    );
  }
}
