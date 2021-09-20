import 'package:flutter/material.dart';
import 'package:spacerock/model/node_model.dart';
import 'package:spacerock/screen/widget/line_tiles.dart';

class LineWidget extends AnimatedWidget {
  final int lineNumber;
  final List<NodeModel> currentNode;
  final Animation<double> animation;
  final Function(NodeModel note) onTileTap;

  const LineWidget({
    key,
    required this.lineNumber,
    required this.currentNode,
    required this.animation,
    required this.onTileTap,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> _animation = animation;
    double height = MediaQuery.of(context).size.height;
    double tileHeight = height / 4;

    List<NodeModel> lineNode =
        currentNode.where((note) => note.line == lineNumber).toList();

    // ignore: non_constant_identifier_names
    List<Widget> TilesWidget = lineNode.map((e) {
      int index = currentNode.indexOf(e);
      double offset = (3 - index + _animation.value) * tileHeight;
      return Transform.translate(
        offset: Offset(0, offset),
        child: LineTiles(
          nodeState: e.noteState,
          height: tileHeight,
          onTap: () => onTileTap(e),
          index: index,
        ),
      );
    }).toList();
    return SizedBox.expand(
      child: Stack(
        children: TilesWidget,
      ),
    );
  }
}
