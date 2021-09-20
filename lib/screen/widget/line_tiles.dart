import 'package:flutter/material.dart';
import 'package:spacerock/provider/node_state.dart';

class LineTiles extends StatelessWidget {
  final NodeState nodeState;
  final double height;
  final VoidCallback onTap;
  final int index;

  const LineTiles(
      {Key? key,
      required this.nodeState,
      required this.height,
      required this.onTap,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTapDown: (_) {
          onTap();
        },
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Container(
            color: color,
          ),
        ),
      ),
    );
  }

  Color get color {
    switch (nodeState) {
      case NodeState.Ready:
        return Colors.purple;
      case NodeState.Missed:
        return Colors.red;
      case NodeState.Tapped:
        return Colors.blue;
    }
  }
}
