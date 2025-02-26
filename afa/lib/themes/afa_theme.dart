import 'package:flutter/material.dart';

Color _customColor= const Color(0xFF49149F);

List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.yellow,
  Colors.orange,
  Colors.green,
  Colors.pink
  ];

class AfaTheme {

  final int selectedColor;

  AfaTheme({this.selectedColor=1}) : assert(selectedColor>=0 && selectedColor<_colorThemes.length,"color index must be between 0 and ${_colorThemes.length - 1}");

  ThemeData theme(){
    return ThemeData(
      useMaterial3: false,
      colorSchemeSeed: _colorThemes[selectedColor]
    );

  }

}