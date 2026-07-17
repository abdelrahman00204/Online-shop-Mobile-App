import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageToggleButton extends StatefulWidget {
  final Function(bool isArabic) onLanguageChanged;

  const LanguageToggleButton({super.key, required this.onLanguageChanged});

  @override
  State<LanguageToggleButton> createState() => _LanguageToggleButtonState();
}

class _LanguageToggleButtonState extends State<LanguageToggleButton> {
  // false = English (Left), true = Arabic (Right)
  late bool _isArabic; // CHANGED: no longer hardcoded, set in initState

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isArabic =
        context.locale.languageCode ==
        'ar'; // NEW: keep in sync if locale changes while widget is alive
  }

  @override
  Widget build(BuildContext context) {
    
    const double width = 60.0;
    const double height = 30.0;
    const double padding = 4.0;
    const double toggleWidth = (width / 2) - padding;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isArabic = !_isArabic;
        });
        widget.onLanguageChanged(_isArabic);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Stack(
          children: [
            // Animated Sliding Background Slider
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              left: _isArabic ? toggleWidth + padding : padding,
              top: padding,
              child: Container(
                width: toggleWidth,
                height: height - (padding * 2),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 75, 165, 77),
                  borderRadius: BorderRadius.circular(21.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Text Labels Overlay
            _isArabic
                ? Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'عر',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'En',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'En',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'عر',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            // Active Text Color Overlay (Fixes contrast over the moving slider)
            _isArabic
                ? Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: _isArabic
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                            child: const Text('عر'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: _isArabic
                                  ? Colors.transparent
                                  : Colors.white,
                            ),
                            child: const Text('En'),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: _isArabic
                                  ? Colors.transparent
                                  : Colors.white,
                            ),
                            child: const Text('En'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: _isArabic
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                            child: const Text('عر'),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
