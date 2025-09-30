import 'package:flutter/material.dart';
import 'dart:math' as math;
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
            colors: [Color(0xFF0E1D35), Color(0xFF091225)],
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
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF12253F), Color(0xFF0A1835)],
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
                              size: const Size(115, 115),
                              painter: CurrencyExchangePainter(),
                            ),
                          ),
                          Center(
                            child: AnimatedBuilder(
                              animation: _planeRotation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _planeRotation.value,
                                  child: const Icon(Icons.flight, color: Colors.white, size: 50),
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
                    child: ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        colors: [Colors.white, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(rect),
                      blendMode: BlendMode.srcIn,
                      child: const Text(
                        'Flip Cash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
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
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double baseRadius = size.width * 0.35;

    // Ana gradient halka
    final Rect ringRect = Rect.fromCircle(center: center, radius: baseRadius);
    final SweepGradient sweep = SweepGradient(
  colors: const [
    Colors.white,
    Colors.lightBlueAccent,
    Colors.lightBlue,
    Colors.white, 
  ],
  stops: const [0.0, 0.6, 0.8, 1.0], 
  transform: GradientRotation(-math.pi / 2), 
);
    final Paint ringPaint = Paint()
      ..shader = sweep.createShader(ringRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(ringRect, 0, 6.28318, false, ringPaint);

    // İnce iç halka (parlaklık)
    final Paint innerRing = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, baseRadius * 0.82, innerRing);

    // Noktalı yörünge
    final double dotsRadius = baseRadius * 1.05;
    final Paint dotPaint = Paint()..color = Colors.white.withOpacity(0.25);
    for (int i = 0; i < 28; i++) {
      final double angle = (6.28318 / 28) * i;
      final Offset p = Offset(
        center.dx + dotsRadius * math.cos(angle),
        center.dy + dotsRadius * math.sin(angle),
      );
      canvas.drawCircle(p, 1.7, dotPaint);
    }

    // İki yönlü düzenli dairesel ok (simetrik)
    final Paint arrowPaint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final double arcRadius = baseRadius * 0.78;
    final Rect arcRect = Rect.fromCircle(center: center, radius: arcRadius);

    // 1. Yay: saat yönünde (negatif sweep) — sol alt -> sağ üst
    final double start1 = -math.pi * 0.25; // -45°
    final double sweep1 = -math.pi * 0.9;  // ~-162°
    final Path arc1 = Path()..addArc(arcRect, start1, sweep1);
    canvas.drawPath(arc1, arrowPaint);
    final double endAngle1 = start1 + sweep1;
    final Offset endPt1 = Offset(
      center.dx + arcRadius * math.cos(endAngle1),
      center.dy + arcRadius * math.sin(endAngle1),
    );
    // Saat yönünde gittiğimiz için teğet açısı endAngle - 90°
    _drawArrowHead(canvas, endPt1.dx, endPt1.dy, endAngle1 - math.pi / 2, arrowPaint.color);

    // 2. Yay: yine saat yönünde — sağ alt -> sol üst (karşı simetrik)
    final double start2 = math.pi * 0.75;  // 135°
    final double sweep2 = -math.pi * 0.9;  // ~-162°
    final Path arc2 = Path()..addArc(arcRect, start2, sweep2);
    canvas.drawPath(arc2, arrowPaint);
    final double endAngle2 = start2 + sweep2;
    final Offset endPt2 = Offset(
      center.dx + arcRadius * math.cos(endAngle2),
      center.dy + arcRadius * math.sin(endAngle2),
    );
    _drawArrowHead(canvas, endPt2.dx, endPt2.dy, endAngle2 - math.pi / 2, arrowPaint.color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void _drawArrowHead(Canvas canvas, double x, double y, double angle, Color color) {
  final Path head = Path();
  const double size = 6.0;
  // Küçük bir üçgen ok ucu
  head.moveTo(x, y);
  head.lineTo(x - size * math.cos(angle - 0.4), y - size * math.sin(angle - 0.4));
  head.lineTo(x - size * math.cos(angle + 0.4), y - size * math.sin(angle + 0.4));
  head.close();
  final Paint p = Paint()..color = color..style = PaintingStyle.fill;
  canvas.drawPath(head, p);
}
