import 'package:flutter/material.dart';

class BusProvider extends ChangeNotifier {
  double _busProgress = 0.0;
  double get busProgress => _busProgress;

  AnimationController? _controller;

  /// Reinicia la posición del autobús a la izquierda.
  void resetPosition() {
    _busProgress = 0.0;
    notifyListeners();
  }

  /// Inicia la animación con un nuevo `AnimationController`.
  /// Va actualizando busProgress de 0.0 a 1.0.
  void startAnimation(TickerProvider vsync) {
    stopAnimation(); // Asegura que no quede otro controller vivo

    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        _busProgress = _controller!.value; 
        notifyListeners();
      });

    // Repite indefinidamente de 0 a 1
    _controller!.repeat();
  }

  /// Detiene la animación y libera recursos.
  void stopAnimation() {
    _controller?.dispose();
    _controller = null;
  }
}