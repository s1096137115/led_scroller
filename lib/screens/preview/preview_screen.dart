import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scroller_providers.dart';
import '../../models/scroller.dart';

/// 預覽頁面
/// 提供全螢幕預覽當前編輯的Scroller
/// 展示實際的LED效果和動畫
class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> with SingleTickerProviderStateMixin {
  bool _isVertical = true;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    // Initialize with appropriate animation based on direction
    _updateAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateAnimation() {
    final scroller = ref.read(currentScrollerProvider);
    if (scroller == null) return;

    // Adjust the speed (1 is slowest, 10 is fastest)
    final speedFactor = scroller.speed / 5; // Normalize speed

    // Calculate the animation duration based on speed
    final duration = Duration(seconds: (15 / speedFactor).round());
    _controller.duration = duration;

    // Reset controller to apply new duration
    _controller.reset();
    _controller.repeat(reverse: false);

    // Set animation based on direction and orientation
    switch (scroller.direction) {
      case ScrollDirection.left:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(-1.0, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        break;
      case ScrollDirection.right:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: const Offset(1.0, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        break;
      case ScrollDirection.up:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, -1.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        break;
      case ScrollDirection.down:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: const Offset(0.0, 1.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scroller = ref.watch(currentScrollerProvider);

    if (scroller == null) {
      return const Scaffold(
        body: Center(
          child: Text('No scroller to preview'),
        ),
      );
    }

    final backgroundColor = Color(int.parse(scroller.backgroundColor.replaceAll('#', '0xFF')));
    final textColor = Color(int.parse(scroller.textColor.replaceAll('#', '0xFF')));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Preview'),
        actions: [
          // Toggle between vertical and horizontal view
          IconButton(
            icon: Icon(_isVertical ? Icons.swap_horiz : Icons.swap_vert),
            onPressed: () {
              setState(() {
                _isVertical = !_isVertical;
                // Update animation when orientation changes
                _updateAnimation();
              });
            },
          ),
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Toggle play/pause
            if (_controller.isAnimating) {
              _controller.stop();
            } else {
              _controller.repeat();
            }
          },
          child: Container(
            width: _isVertical ? 300 : double.infinity,
            height: _isVertical ? double.infinity : 300,
            color: backgroundColor,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Center(
                child: _isVertical
                    ? _buildVerticalText(scroller.text, textColor, scroller.fontSize.toDouble(), scroller.fontFamily)
                    : _buildHorizontalText(scroller.text, textColor, scroller.fontSize.toDouble(), scroller.fontFamily),
              ),
            ),
          ),
        ),
      ),
      // Optional LED effect overlay
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Toggle LED dot matrix effect
                  setState(() {
                    // In a real app, you'd implement a dot matrix effect here
                  });
                },
                child: const Text('LED Effect'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalText(String text, Color color, double fontSize, String fontFamily) {
    return RotatedBox(
      quarterTurns: 3, // Rotate to make text vertical
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: fontFamily,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHorizontalText(String text, Color color, double fontSize, String fontFamily) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        letterSpacing: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }
}