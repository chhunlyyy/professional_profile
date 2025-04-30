import 'package:flutter/material.dart';
import 'package:professional_profiles/core/helper/navigator.dart';
import 'package:professional_profiles/features/profiles/presentation/screen/profiles_screen.dart';
import 'package:professional_profiles/features/splash/presentaion/widget/app_name_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  void _initAnimationController() {
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    //
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    //
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    //
    _controller.forward();
  }

  Future<void> _navigateToProfilesScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        pushReplacement(context, const ProfilesScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //
    _initAnimationController();
    //
    _navigateToProfilesScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: const AppNameWidget(),
              ),
            );
          },
        ),
      ),
    );
  }
}
