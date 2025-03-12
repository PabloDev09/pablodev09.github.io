import 'package:afa/logic/controllers/afa_gif_controller.dart';
import 'package:afa/logic/providers/bus_provider.dart';
import 'package:afa/logic/providers/loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  final Widget child;
  const LoadingScreen({super.key, required this.child});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  bool _isLoading = false;

  // Controlador del GIF (opcional)
  late AfaGifController _gifController;

  // Controlador y animación para el fade out
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Ajusta este valor si tu GIF tiene varios frames
  final int frameCount = 1;

  @override
  void initState() {
    super.initState();

    // Inicializamos el controlador para el GIF
    _gifController = AfaGifController(
      vsync: this,
      frameCount: frameCount,
      fps: 30,
    );

    // Controlador y animación para el fade out
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _gifController.animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkLoadingState();
  }

  void _checkLoadingState() {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: true);
    final busProvider = Provider.of<BusProvider>(context, listen: false);

    if (loadingProvider.isScreenChange) {
      _fadeController.reset();
      setState(() => _isLoading = true);
      busProvider.resetPosition();
      busProvider.startAnimation(this);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _fadeController.forward();
          loadingProvider.isScreenChange = false;
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() => _isLoading = false);
              busProvider.stopAnimation();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF063970), Color(0xFF66B3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Logo y CircularProgressIndicator centrados
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6,
                      ),
                    ],
                  ),
                ),
                // Autobús animado siempre pegado al fondo
                Consumer<BusProvider>(
                  builder: (context, busProvider, child) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final screenHeight = MediaQuery.of(context).size.height;
                    // El ancho del autobús será el menor entre 25% del ancho y 30% del alto
                    final busWidth = (screenWidth * 0.25).clamp(0.0, screenHeight * 0.3);
                    // Calculamos la posición horizontal (animada)
                    final xPos = -busWidth + busProvider.busProgress * (screenWidth + busWidth);

                    return Positioned(
                      bottom: 0, // Siempre pegado abajo
                      left: xPos,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          width: busWidth,
                          height: busWidth,
                          child: AnimatedBuilder(
                            animation: _gifController.animationController,
                            builder: (context, child) {
                              final spriteSheetWidth = busWidth * frameCount;
                              return ClipRect(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: 1 / frameCount,
                                  child: Image.asset(
                                    'assets/images/autobus-unscreen.gif',
                                    width: spriteSheetWidth,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : widget.child;
  }
}
