import 'package:flutter/material.dart';

/// Sistema de navegação com transições animadas profissionais
/// 
/// Como usar:
/// 1. Importe este arquivo onde precisar navegar
/// 2. Use NavigationHelper.navigateTo() ao invés de Navigator.push()
/// 
/// Exemplo:
/// NavigationHelper.navigateTo(
///   context, 
///   TelaLogin(),
///   type: TransitionType.slideFromRight,
/// );

class NavigationHelper {
  /// Navega para uma nova tela com transição animada
  static Future<T?> navigateTo<T>(
    BuildContext context,
    Widget page, {
    TransitionType type = TransitionType.fadeSlide,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildTransition(type, animation, secondaryAnimation, child);
        },
      ),
    );
  }

  /// Substitui a tela atual (sem voltar)
  static Future<T?> replaceTo<T>(
    BuildContext context,
    Widget page, {
    TransitionType type = TransitionType.fadeSlide,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.of(context).pushReplacement<T, void>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildTransition(type, animation, secondaryAnimation, child);
        },
      ),
    );
  }

  /// Remove todas as telas e vai para uma nova
  static Future<T?> navigateAndRemoveAll<T>(
    BuildContext context,
    Widget page, {
    TransitionType type = TransitionType.fadeSlide,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _buildTransition(type, animation, secondaryAnimation, child);
        },
      ),
      (route) => false,
    );
  }

  static Widget _buildTransition(
    TransitionType type,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (type) {
      case TransitionType.fade:
        return _fadeTransition(animation, child);
      
      case TransitionType.fadeSlide:
        return _fadeSlideTransition(animation, child);
      
      case TransitionType.slideFromRight:
        return _slideFromRightTransition(animation, secondaryAnimation, child);
      
      case TransitionType.slideFromLeft:
        return _slideFromLeftTransition(animation, secondaryAnimation, child);
      
      case TransitionType.slideFromBottom:
        return _slideFromBottomTransition(animation, child);
      
      case TransitionType.scale:
        return _scaleTransition(animation, child);
      
      case TransitionType.fadeScale:
        return _fadeScaleTransition(animation, child);
      
      case TransitionType.rotation:
        return _rotationTransition(animation, child);
    }
  }

  // ========== TRANSIÇÕES ==========

  static Widget _fadeTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget _fadeSlideTransition(Animation<double> animation, Widget child) {
    var fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ));

    var slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }

  static Widget _slideFromRightTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Tela entrando da direita
    var slideIn = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ));

    // Tela anterior saindo para esquerda (parallax)
    var slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-0.3, 0.0),
    ).animate(CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInCubic,
    ));

    return Stack(
      children: [
        SlideTransition(
          position: slideOut,
          child: Container(),
        ),
        SlideTransition(
          position: slideIn,
          child: child,
        ),
      ],
    );
  }

  static Widget _slideFromLeftTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    var slideIn = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ));

    return SlideTransition(
      position: slideIn,
      child: child,
    );
  }

  static Widget _slideFromBottomTransition(
    Animation<double> animation,
    Widget child,
  ) {
    var slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }

  static Widget _scaleTransition(Animation<double> animation, Widget child) {
    var scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
    ));

    return ScaleTransition(
      scale: scaleAnimation,
      child: child,
    );
  }

  static Widget _fadeScaleTransition(Animation<double> animation, Widget child) {
    var fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    var scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }

  static Widget _rotationTransition(Animation<double> animation, Widget child) {
    var rotateAnimation = Tween<double>(
      begin: 0.05,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
    ));

    var fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: Transform.rotate(
        angle: rotateAnimation.value,
        child: child,
      ),
    );
  }
}

/// Tipos de transições disponíveis
enum TransitionType {
  /// Apenas fade simples
  fade,
  
  /// Fade + slide sutil (mais usado - elegante)
  fadeSlide,
  
  /// Slide da direita (estilo iOS)
  slideFromRight,
  
  /// Slide da esquerda
  slideFromLeft,
  
  /// Slide de baixo (modais)
  slideFromBottom,
  
  /// Escala com bounce
  scale,
  
  /// Fade + escala (para popups)
  fadeScale,
  
  /// Rotação sutil + fade
  rotation,
}
