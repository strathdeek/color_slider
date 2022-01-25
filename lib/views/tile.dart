import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  const Tile({
    Key? key,
    required this.color,
    this.height = 50,
    this.width = 50,
    this.padding = 25,
    required this.getColorForDirection,
    required this.onNewSlideDirection,
  }) : super(key: key);

  @override
  State<Tile> createState() => _TileState();

  final Color color;
  final double height;
  final double width;
  final double padding;
  final Color Function(Direction) getColorForDirection;
  final Function(Direction?) onNewSlideDirection;
}

class _TileState extends State<Tile> {
  Direction? slideDirection;
  static double cornerRadiusResting = 15;
  static double stretchDistance = 10;
  static Duration animationDuration = const Duration(milliseconds: 300);
  static Curve animationCurve = Curves.ease;
  static double gradientStart = .7;
  static double gradientStop = 1;

  late double tileHeight;
  late double tileWidth;
  double? tileTop;
  double? tileLeft;
  double? tileBottom;
  double? tileRight;
  late BorderRadius tileRadius;
  late LinearGradient tileGradient;

  @override
  void initState() {
    tileHeight = _getTileHeight();
    tileWidth = _getTileWidth();
    tileTop = _getTileTop();
    tileLeft = _getTileLeft();
    tileRadius = _getBorderRadius();
    tileGradient = _getTileGradient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height + widget.padding * 2,
      width: widget.width + widget.padding * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
            duration: animationDuration,
            top: tileTop,
            left: tileLeft,
            right: tileRight,
            bottom: tileBottom,
            curve: animationCurve,
            child: GestureDetector(
              onPanCancel: _onPanCancel,
              onPanUpdate: _onPanUpdate,
              onPanEnd: (details) => _moveTile(slideDirection),
              child: AnimatedContainer(
                duration: animationDuration,
                curve: animationCurve,
                height: tileHeight,
                width: tileWidth,
                decoration: BoxDecoration(
                  borderRadius: tileRadius,
                  gradient: tileGradient,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      _setTileDirection(newDirection);
    }
  }

  void _onPanCancel() => _setTileDirection(null);

  void _setTileDirection(Direction? direction) {
    setState(() {
      slideDirection = direction;
      tileHeight = _getTileHeight();
      tileWidth = _getTileWidth();
      tileTop = _getTileTop();
      tileLeft = _getTileLeft();
      tileRadius = _getBorderRadius();
      tileGradient = _getTileGradient();
    });
  }

  void _setTilePosition({double? l, double? t, double? r, double? b}) {
    setState(() {
      tileTop = t;
      tileLeft = l;
      tileBottom = b;
      tileRight = r;
      slideDirection = null;
      tileHeight = _getTileHeight();
      tileWidth = _getTileWidth();
      tileRadius = _getBorderRadius();
      tileGradient = _getTileGradient();
    });
  }

  void _moveTile(Direction? direction) {
    switch (direction) {
      case Direction.left:
        _setTilePosition(l: -widget.width, t: widget.padding);
        break;
      case Direction.right:
        _setTilePosition(
          l: (widget.padding * 2) + widget.width,
          t: widget.padding,
        );
        break;
      case Direction.up:
        _setTilePosition(
          l: widget.padding,
          t: -widget.height,
        );
        break;
      case Direction.down:
        _setTilePosition(
          l: widget.padding,
          t: widget.height + (widget.padding * 2),
        );
        break;
      case null:
        break;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (slideDirection) {
      case Direction.left:
        return BorderRadius.horizontal(
          right: Radius.circular(cornerRadiusResting),
          left: Radius.elliptical(widget.width, widget.height * .8),
        );

      case Direction.right:
        return BorderRadius.horizontal(
          left: Radius.circular(cornerRadiusResting),
          right: Radius.elliptical(widget.width, widget.height * .8),
        );
      case Direction.down:
        return BorderRadius.vertical(
          top: Radius.circular(cornerRadiusResting),
          bottom: Radius.elliptical(widget.width * .8, widget.height),
        );
      case Direction.up:
        return BorderRadius.vertical(
          top: Radius.elliptical(widget.width * .8, widget.height),
          bottom: Radius.circular(cornerRadiusResting),
        );
      case null:
        return BorderRadius.all(
          Radius.circular(cornerRadiusResting),
        );
    }
  }

  double _getTileLeft() {
    switch (slideDirection) {
      case Direction.left:
        return widget.padding - stretchDistance;
      case Direction.right:
      case Direction.down:
      case Direction.up:
      case null:
        return widget.padding;
    }
  }

  double _getTileTop() {
    switch (slideDirection) {
      case Direction.up:
        return widget.padding - stretchDistance;
      case Direction.down:
      case Direction.left:
      case Direction.right:
      case null:
        return widget.padding;
    }
  }

  double _getTileWidth() {
    switch (slideDirection) {
      case Direction.left:
      case Direction.right:
        return stretchDistance + widget.width;
      case Direction.down:
      case Direction.up:
      case null:
        return widget.width;
    }
  }

  double _getTileHeight() {
    switch (slideDirection) {
      case Direction.down:
      case Direction.up:
        return widget.height + stretchDistance;
      case Direction.left:
      case Direction.right:
      case null:
        return widget.height;
    }
  }

  LinearGradient _getTileGradient() {
    switch (slideDirection) {
      case Direction.down:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
          stops: [gradientStart, gradientStop],
        );
      case Direction.up:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [gradientStart, gradientStop],
        );
      case Direction.left:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          stops: [gradientStart, gradientStop],
        );
      case Direction.right:
        return LinearGradient(
          colors: [
            widget.color,
            widget.getColorForDirection(slideDirection!),
          ],
          stops: [gradientStart, gradientStop],
        );
      case null:
        return LinearGradient(
          colors: [widget.color, widget.color],
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
