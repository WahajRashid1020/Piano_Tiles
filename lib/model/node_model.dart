import 'package:spacerock/provider/node_state.dart';

class NodeModel {
  final int orderNumber;
  final int line;

  NodeState noteState = NodeState.Ready;

  NodeModel(this.orderNumber, this.line);
}
