import 'package:flutter/material.dart';
import 'dart:async';

class DataRedactionWidget extends StatefulWidget {
  final Widget? child;

  const DataRedactionWidget({super.key, this.child});

  static final List<DataRedactionWidgetState> _activeInstances = [];

  static List<DataRedactionWidgetState> get activeInstances => List.unmodifiable(_activeInstances);

  /// Returns a Future that resolves to a list of coordinates and sizes of all active instances.
  static Future<List<Map<String, dynamic>>> getAllCoordinatesAndSizes() async {
    final Completer<List<Map<String, dynamic>>> completer = Completer();
    if (_activeInstances.isEmpty) {
      return Future.value([]);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final data = _activeInstances.map((instance) {
          return instance._getPositionAndSize();
        }).toList();
        completer.complete(data);
      });
      WidgetsBinding.instance.ensureVisualUpdate();
    }
    return completer.future;
  }

  @override
  DataRedactionWidgetState createState() => DataRedactionWidgetState();
}

class DataRedactionWidgetState extends State<DataRedactionWidget> {
  @override
  void initState() {
    super.initState();
    DataRedactionWidget._activeInstances.add(this);
  }

  @override
  void dispose() {
    DataRedactionWidget._activeInstances.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? SizedBox.shrink();
  }

  Map<String, dynamic> _getPositionAndSize() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      return {
        'position': {'x': position.dx, 'y': position.dy},
        'size': {'width': size.width, 'height': size.height},
      };
    }
    return {'position': null, 'size': null};
  }
}