import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  Tile(
      {Key? key,
      required this.color,
      this.height = 50,
      this.width = 50,
      this.padding = 25,
      required this.getColorForDirection,
      required this.onNewSlideDirection})
      : super(key: key);

  void setSlideDirection(Direction? direction) {
    _tileState.setSlideDirection(direction);
  }

  @override
  State<Tile> createState() => _tileState;

  final _TileState _tileState = _TileState();
  final Color color;
  final double height;
  final double width;
  final double padding;
  final Color Function(Direction) getColorForDirection;
  final Function(Direction?) onNewSlideDirection;
}

class _TileState extends State<Tile> {
  Direction? slideDirection;
  static double cornerRadius = 10;
  static int animationTimeInMS = 150;
  static Curve animationCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height + widget.padding * 2,
      width: widget.width + widget.padding * 2,
      child: Stack(
        children: [
          AnimatedPositioned(
            height: _getShadowHeight(),
            width: _getShadowWidth(),
            duration: Duration(milliseconds: animationTimeInMS),
            top: _getShadowTopAnchor(),
            left: _getShadowLeftAnchor(),
            curve: animationCurve,
            child: Container(
              decoration: BoxDecoration(
                gradient: _getShadowGradient(),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              child: AnimatedContainer(
                curve: animationCurve,
                duration: Duration(milliseconds: animationTimeInMS),
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: _getBorderRadius(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setSlideDirection(Direction? direction) {
    setState(() {
      slideDirection = direction;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final x = details.localPosition.dx - 25;
    final y = details.localPosition.dy - 25;
    Direction? newDirection;

    if (x.abs() < 25 && y.abs() < 25) {
      newDirection = null;
    } else {
      if (x.abs() > y.abs()) {
        newDirection = x > 0 ? Direction.right : Direction.left;
      } else {
        newDirection = y > 0 ? Direction.down : Direction.up;
      }
    }

    if (newDirection != slideDirection) {
      setState(() {
        slideDirection = newDirection;
      });
      widget.onNewSlideDirection(newDirection);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (slideDirection) {
      case Direction.left:
        return BorderRadius.horizontal(
          right: Radius.circular(cornerRadius),
        );

      case Direction.right:
        return BorderRadius.horizontal(
          left: Radius.circular(cornerRadius),
        );
      case Direction.down:
        return BorderRadius.vertical(
          top: Radius.circular(cornerRadius),
        );
      case Direction.up:
        return BorderRadius.vertical(
          bottom: Radius.circular(cornerRadius),
        );
      case null:
        return BorderRadius.all(
          Radius.circular(cornerRadius),
        );
    }
  }

  double _getShadowLeftAnchor() {
    switch (slideDirection) {
      case Direction.left:
        return 0;
      case Direction.right:
        return widget.width + widget.padding;
      case Direction.down:
      case Direction.up:
      case null:
        return widget.padding;
    }
  }

  double _getShadowTopAnchor() {
    switch (slideDirection) {
      case Direction.down:
        return widget.height + widget.padding;
      case Direction.up:
        return 0;
      case Direction.left:
      case Direction.right:
      case null:
        return widget.padding;
    }
  }

  double _getShadowWidth() {
    switch (slideDirection) {
      case Direction.left:
      case Direction.right:
        return widget.padding;
      case Direction.down:
      case Direction.up:
      case null:
        return widget.width;
    }
  }

  double _getShadowHeight() {
    switch (slideDirection) {
      case Direction.down:
      case Direction.up:
        return widget.padding;
      case Direction.left:
      case Direction.right:
      case null:
        return widget.height;
    }
  }

  LinearGradient _getShadowGradient() {
    switch (slideDirection) {
      case Direction.down:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        );
      case Direction.up:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        );
      case Direction.left:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        );
      case Direction.right:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
        );
      case null:
        return const LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        );
    }
  }
}

enum Direction { up, down, left, right }

extension Opposites on Direction {
  Direction opposite() {
    switch (this) {
      case Direction.down:
        return Direction.up;

      case Direction.up:
        return Direction.down;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }
}
