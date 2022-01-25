import 'package:color_slider/utils/color_utils.dart';
import 'package:color_slider/views/tile.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final int columns = 5;
  final int rows = 5;
  final tileSize = 50.0;
  final spacing = 20.0;

  List<List<Color>> grid = [];

  @override
  void initState() {
    super.initState();
    for (var col = 0; col < columns; col++) {
      grid.add([]);
      for (var row = 0; row < rows; row++) {
        grid[col].add(randomColor());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: _getTiles(),
        ),
      ),
    );
  }

  List<Widget> _getTiles() {
    final newTiles = <Positioned>[];
    for (var col = 0; col < columns; col++) {
      for (var row = 0; row < rows; row++) {
        newTiles.add(
          Positioned(
            top: _getTopAnchorForColumn(col),
            left: _getleftAnchorForRow(row),
            key: ValueKey('$col,$row'),
            child: Tile(
              height: tileSize,
              width: tileSize,
              padding: spacing,
              color: grid[col][row],
              getColorForDirection: (direction) {
                try {
                  switch (direction) {
                    case Direction.up:
                      return grid[col - 1][row];
                    case Direction.down:
                      return grid[col + 1][row];
                    case Direction.left:
                      return grid[col][row - 1];
                    case Direction.right:
                      return grid[col][row + 1];
                  }
                } catch (_) {
                  return Colors.transparent;
                }
              },
              onNewSlideDirection: (direction) {
                //   try {
                //     String? key;

                //     switch (direction) {
                //       case Direction.up:
                //         key = '${col - 1},$row';
                //         break;
                //       case Direction.down:
                //         key = '${col + 1},$row';
                //         break;
                //       case Direction.left:
                //         key = '$col,${row - 1}';
                //         break;
                //       case Direction.right:
                //         key = '$col,${row + 1}';
                //         break;
                //       case null:
                //         for (final element in newTiles) {
                //           (element.child as Tile).setSlideDirection(direction);
                //         }
                //         break;
                //     }
                //     if (key?.isNotEmpty ?? false) {
                //       final slideTargetKey = ValueKey(key!);
                //       final slideSenderKey = ValueKey('$col,$row');

                //       for (final element in newTiles) {
                //         if (element.key == slideTargetKey) {
                //           (element.child as Tile)
                //               .setSlideDirection(direction?.opposite());
                //         } else if (element.key != slideSenderKey) {
                //           (element.child as Tile).setSlideDirection(null);
                //         }
                //       }
                //     }
                //   } catch (_) {}
              },
            ),
          ),
        );
      }
    }
    return newTiles;
  }

  double _getTopAnchorForColumn(int col) =>
      spacing + (col * (tileSize + spacing));
  double _getleftAnchorForRow(int row) =>
      spacing + (row * (tileSize + spacing));
}
