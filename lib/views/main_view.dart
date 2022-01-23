import 'package:color_slider/views/tile.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Tile(
        color: Colors.red,
      ),
    );
  }
}
