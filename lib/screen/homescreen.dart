//@dart=2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacerock/model/node_model.dart';
import 'package:spacerock/provider/node_state.dart';
import 'package:spacerock/provider/song_provider.dart';
// import 'package:spacerock/screen/widget/line_tiles.dart';
import 'package:spacerock/screen/widget/line_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<NodeModel> node = mission1();
  AnimationController _animationController;
  int currentNodeIndex = 0;
  AudioCache player = AudioCache();
  int point = 0;
  int highscore = 0;
  bool isplaying = true;
  bool hasstarted = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isplaying) {
        if (node[currentNodeIndex].noteState != NodeState.Tapped) {
          //game over
          setState(() {
            isplaying = false;
            node[currentNodeIndex].noteState = NodeState.Missed;
          });
          _animationController.reverse().then((_) => _showFinishDialog());
        } else if (currentNodeIndex == node.length - 5) {
          //song finished
          _showFinishDialog();
        } else {
          setState(() => ++currentNodeIndex);
          _animationController.forward(from: 0);
        }
      }
    });
    _animationController.forward(from: -1);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              height: double.infinity,
              child: Image.asset("assets/background.gif", fit: BoxFit.cover),
            ),
            Row(
              children: [
                _drawLine(0),
                // LineDivider(),
                _drawLine(1),
                // LineDivider(),
                _drawLine(2),
                // LineDivider(),
                _drawLine(3)
              ],
            ),
            _drawPoint(),
            _drawCompleteTile(),
          ],
        ),
      ),
    );
  }

  Widget drawLineWidget(int lineNumber) {
    return Expanded(
        child: LineWidget(
      lineNumber: lineNumber,
      currentNode: node.sublist(currentNodeIndex, currentNodeIndex + 5),
      animation: _animationController,
      onTileTap: (NodeModel node) {
        _notePlay(node);
        setState(() {
          node.noteState = NodeState.Tapped;
          ++point;
        });
      },
    ));
  }

  void _notePlay(NodeModel node) {
    switch (node.line) {
      case 0:
        player.play('a.wav');
        print('object final');
        return;
      case 1:
        player.play('c.wav');
        print('object 1');
        return;
      case 2:
        player.play('e.wav');
        print('object 2');
        return;
      case 3:
        player.play('f.wav');
        print('object 3');
        return;
    }
  }

  addIntToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('wahaj', highscore);
  }

  Future<void> _showFinishDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int a = prefs.getInt('wahaj') ?? 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(150)),
                  ),
                  child: Icon(Icons.play_arrow, size: 50),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(150)),
                  ),
                  child: Text(
                    "Score: $point"
                            "\nHighest: " +
                        a.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _startWidget(),
              ],
            ),
          ),
        );
      },
    ).then((_) => _restart());
  }

  //   @override
  // void dispose() {
  //   super.dispose();
  //   _animationController.dispose();
  // }

  void _restart() {
    setState(() {
      hasstarted = false;
      isplaying = true;
      node = mission1();
      point = 0;
      currentNodeIndex = 0;
      _animationController.duration = Duration(milliseconds: 300);
    });
    _animationController.reset();
  }

  Widget _startWidget() {
    if (point >= 10 && point < 49)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.green[200],
          ),
          Icon(
            Icons.star,
            color: Colors.green[200],
          ),
        ],
      );
    else if (point >= 50 && point < 72)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.green[200],
          ),
        ],
      );
    else if (point >= 71)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
          Icon(
            Icons.star,
            color: Colors.deepOrange,
          ),
        ],
      );
    else
      return Container();
  }

  _drawLine(int lineNumber) {
    return Expanded(
      child: LineWidget(
        lineNumber: lineNumber,
        currentNode: node.sublist(currentNodeIndex, currentNodeIndex + 5),
        animation: _animationController,
        onTileTap: _onTap,
      ),
    );
  }

  void _onTap(NodeModel note) {
    bool areAllPreviousTapped = node
        .sublist(0, note.orderNumber)
        .every((n) => n.noteState == NodeState.Tapped);

    if (areAllPreviousTapped) {
      if (!hasstarted) {
        setState(() => hasstarted = true);
        _animationController.forward();
      }
      _notePlay(note);
      setState(() {
        note.noteState = NodeState.Tapped;
        ++point;
        if (point == 10) {
          _animationController.duration = Duration(milliseconds: 300);
        } else if (point == 15) {
          _animationController.duration = Duration(milliseconds: 290);
        } else if (point == 30) {
          _animationController.duration = Duration(milliseconds: 250);
        } else if (point == 40) {
          _animationController.duration = Duration(milliseconds: 230);
        } else if (point == 50) {
          _animationController.duration = Duration(milliseconds: 210);
        } else if (point == 60) {
          _animationController.duration = Duration(milliseconds: 200);
        } else if (point == 70) {
          _animationController.duration = Duration(milliseconds: 180);
        }
      });
    }
  }

  Widget _drawCompleteTile() {
    return Positioned(
      top: 25,
      right: 50,
      left: 50,
      child: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _tileWidget(Icons.star,
              color: point >= 10 ? Colors.deepOrange : Colors.green[200]),
          _tileHorizontalLine(
              point >= 10 ? Colors.deepOrange : Colors.deepOrange[200]),
          _tileWidget(Icons.star,
              color: point >= 50 ? Colors.deepOrange : Colors.green[200]),
          _tileHorizontalLine(
              point >= 70 ? Colors.deepOrange : Colors.deepOrange[200]),
          _tileWidget(Icons.star,
              color: point >= 71 ? Colors.deepOrange : Colors.green[200]),
        ]),
      ),
    );
  }

  _drawPoint() {
    setState(() {});
    addIntToSF();

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Text(
          "$point",
          style: TextStyle(color: Colors.red, fontSize: 60),
        ),
      ),
    );
  }

  _tileWidget(IconData icon, {Color color}) {
    return Container(
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  _tileHorizontalLine(Color color) {
    return Container(
      width: 80,
      height: 4,
      color: color,
    );
  }
}
