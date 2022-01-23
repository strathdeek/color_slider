import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class Tile extends StatefulWidget {
  const Tile({Key? key, required this.color}) : super(key: key);

  @override
  State<Tile> createState() => _TileState();

  final Color color;
}

class _TileState extends State<Tile> {
  static double shadowOffset = 10;
  Direction? slideDirection;
  final _offsetLeft = Offset(-shadowOffset, 0);
  final _offsetRight = Offset(shadowOffset, 0);
  final _offsetUp = Offset(0, shadowOffset);
  final _offsetDown = Offset(0, -shadowOffset);

  void _onPanUpdate(DragUpdateDetails details) {
    final x = details.localPosition.dx - 25;
    final y = details.localPosition.dy - 25;

    if (x.abs() < 25 && y.abs() < 25) {
      setState(() {
        slideDirection = null;
      });
    } else {
      setState(() {
        if (x.abs() > y.abs()) {
          slideDirection = x > 0 ? Direction.right : Direction.left;
        } else {
          slideDirection = y > 0 ? Direction.up : Direction.down;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.color,
              offset: _getShadowOffset(),
            ),
          ],
          color: widget.color,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 50,
        width: 50,
      ),
    );
  }

  Offset _getShadowOffset() {
    switch (slideDirection) {
      case Direction.left:
        return _offsetLeft;
      case Direction.right:
        return _offsetRight;
      case Direction.down:
        return _offsetDown;
      case Direction.up:
        return _offsetUp;
      case null:
        return Offset.zero;
    }
  }
}
