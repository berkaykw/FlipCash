import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flip_cash/screens/CurrencyConvertScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _planeController;
  late AnimationController _fadeController;

  late Animation<double> _logoScale;
  late Animation<double> _planeRotation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _planeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _planeRotation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _planeController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _startAnimation();
    _navigateAfterSplash();
  }

  // Splash sonrası yönlendirme
  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final savedCountryName = prefs.getString('countryName');
    final savedCountryFlag = prefs.getString('countryFlag');
    final savedBaseCurrency = prefs.getString('baseCurrency');
    final savedSpentCurrency = prefs.getString('spentCurrency');

    if (savedCountryName != null &&
        savedCountryFlag != null &&
        savedBaseCurrency != null &&
        savedSpentCurrency != null) {
      // Kaydedilmiş seçim varsa Convert ekranına git
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CurrencyConvertScreen(
            countryName: savedCountryName,
            countryFlag: savedCountryFlag,
            baseCurrency: savedBaseCurrency,
            spentCurrency: savedSpentCurrency,
          ),
        ),
      );
    } else {
      // Kaydedilmemişse seçim ekranına git
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _planeController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _planeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Color(0xFF1A2B4C), Color(0xFF0A1628)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ve Animasyon
              AnimatedBuilder(
                animation: _logoScale,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScale.value,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0F233A), Color(0xFF0A1835)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: CustomPaint(
                              size: const Size(100, 100),
                              painter: CurrencyExchangePainter(),
                            ),
                          ),
                          Center(
                            child: AnimatedBuilder(
                              animation: _planeRotation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _planeRotation.value,
                                  child: const Icon(Icons.flight, color: Colors.white, size: 40),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // App Title
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Text(
                      'Flip Cash',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyExchangePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    canvas.drawCircle(center, radius, paint);

    final textPainter1 = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter1.layout();
    textPainter1.paint(canvas, Offset(center.dx - radius * 1.8, center.dy - radius * 2));

    final textPainter2 = TextPainter(
      text: const TextSpan(
        text: '€',
        style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout();
    textPainter2.paint(canvas, Offset(center.dx + radius * 1.05, center.dy + radius * 0.6));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
