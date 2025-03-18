import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui'; // 用於模糊效果
import '../../providers/preview_mode_provider.dart';
import '../../providers/scroller_providers.dart';
import '../../models/scroller.dart';
import '../../utils/font_utils.dart'; // 引入字體工具類
import '../create/widgets/led_grid_painter.dart'; // 引入LED點陣效果

/// 預覽頁面
/// 提供全螢幕預覽當前編輯的Scroller
/// 展示實際的LED效果和動畫
/// 根據Figma設計實現模糊效果和滑動控制
class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> with SingleTickerProviderStateMixin {
  bool _isVertical = true;
  bool _showLedEffect = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  // 控制UI顯示的狀態
  bool _showControls = true; // 初始顯示控制元素
  final ScrollController _scrollController = ScrollController();
  bool _shouldBlurHeader = false;
  bool _shouldBlurFooter = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final scroller = ref.watch(currentScrollerProvider);
    if (scroller != null) {
      setState(() {
        _showLedEffect = scroller.ledBackgroundEnabled;
      });

      Future(() {
        if (mounted) {
          ref.read(ledEffectEnabledProvider.notifier).state = scroller.ledBackgroundEnabled;
        }
      });
    }

    if (scroller != null) {
      _updateAnimation();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimation();

      final scroller = ref.read(currentScrollerProvider);
      if (scroller != null) {
        setState(() {
          _showLedEffect = scroller.ledBackgroundEnabled;
        });
        ref.read(ledEffectEnabledProvider.notifier).state = scroller.ledBackgroundEnabled;
      }
    });

    _scrollController.addListener(_updateBlurStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_updateBlurStatus);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateBlurStatus() {
    final scroller = ref.read(currentScrollerProvider);
    if (scroller == null) return;

    if (_scrollController.hasClients) {
      final textLength = scroller.text.length;
      final threshold = 50;

      setState(() {
        if (textLength > threshold) {
          _shouldBlurHeader = _scrollController.offset > 10;
          _shouldBlurFooter = _scrollController.position.maxScrollExtent - _scrollController.offset > 10;
        } else {
          _shouldBlurHeader = false;
          _shouldBlurFooter = false;
        }
      });
    }
  }

  void _updateAnimation() {
    final scroller = ref.read(currentScrollerProvider);
    if (scroller == null) return;

    final speedFactor = scroller.speed;
    final duration = Duration(seconds: (15 / speedFactor).round());

    _controller.duration = duration;
    _controller.reset();
    _controller.repeat(reverse: false);

    switch (scroller.direction) {
      case ScrollDirection.left:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, -1.0),
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
        setState(() {
          _isVertical = false;
        });
        break;
      case ScrollDirection.right:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: const Offset(0.0, 1.0),
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
        setState(() {
          _isVertical = false;
        });
        break;
      case ScrollDirection.up:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, -1.0),
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
        setState(() {
          _isVertical = true;
        });
        break;
      case ScrollDirection.down:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: const Offset(0.0, 1.0),
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
        setState(() {
          _isVertical = true;
        });
        break;
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _saveScroller() {
    final scroller = ref.read(currentScrollerProvider);
    if (scroller == null) return;

    print('Saving scroller from preview screen:');
    print('- ID: ${scroller.id}');
    print('- Text: ${scroller.text}');
    print('- Font size: ${scroller.fontSize}');
    print('- Font family: ${scroller.fontFamily}');
    print('- Text color: ${scroller.textColor}');
    print('- Background color: ${scroller.backgroundColor}');
    print('- Direction: ${scroller.direction}');
    print('- Speed: ${scroller.speed}');
    print('- LED Background Enabled: ${scroller.ledBackgroundEnabled}');

    final mode = ref.read(previewModeProvider);
    final isNew = mode == PreviewMode.fromCreate;

    if (isNew) {
      print('Creating new scroller');
      ref.read(scrollersProvider.notifier).addScroller(scroller);
    } else {
      print('Updating existing scroller');
      ref.read(scrollersProvider.notifier).updateScroller(scroller);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isNew ? 'Scroller created' : 'Scroller updated'),
        backgroundColor: Colors.green,
      ),
    );

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final scroller = ref.watch(currentScrollerProvider);
    final previewMode = ref.watch(previewModeProvider);

    if (scroller == null) {
      return const Scaffold(
        body: Center(
          child: Text('No scroller to preview'),
        ),
      );
    }

    final backgroundColor = FontUtils.hexToColor(scroller.backgroundColor);
    final textColor = FontUtils.hexToColor(scroller.textColor);

    if (_showLedEffect != scroller.ledBackgroundEnabled) {
      setState(() {
        _showLedEffect = scroller.ledBackgroundEnabled;
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _showControls // 根據 _showControls 決定是否顯示 AppBar
          ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('View Full Screen'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            switch (previewMode) {
              case PreviewMode.fromCreate:
              case PreviewMode.fromEdit:
                context.go('/create');
                break;
              case PreviewMode.fromHome:
              default:
                context.go('/');
                break;
            }
          },
        ),
        flexibleSpace: _shouldBlurHeader
            ? ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        )
            : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
      )
          : null, // 全螢幕模式時隱藏 AppBar
      body: GestureDetector(
        onTap: _toggleControls, // 點擊切換全螢幕模式
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: backgroundColor,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Center(
                  child: _isVertical
                      ? _buildVerticalText(
                    context,
                    scroller.text,
                    textColor,
                    scroller.fontSize.toDouble(),
                    scroller.fontFamily,
                  )
                      : _buildHorizontalText(
                    scroller.text,
                    textColor,
                    scroller.fontSize.toDouble(),
                    scroller.fontFamily,
                  ),
                ),
              ),
            ),
            if (scroller.ledBackgroundEnabled)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: LedGridPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            if (_showControls) // 根據 _showControls 決定是否顯示底部控制欄
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomControls(context, previewMode),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalText(
      BuildContext context,
      String text,
      Color color,
      double fontSize,
      String fontFamily,
      ) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 使用FontUtils獲取字體樣式
    final textStyle = FontUtils.getGoogleFontStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: color,
      letterSpacing: 1.2,
      height: 1.2,
    );

    final TextPainter measurePainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final words = text.split(' ');
    final List<String> lines = [];
    String currentLine = '';

    for (final word in words) {
      final testLine = currentLine.isEmpty ? word : '$currentLine $word';
      measurePainter.text = TextSpan(text: testLine, style: textStyle);
      measurePainter.layout();

      if (measurePainter.width > screenWidth * 0.7) {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
          currentLine = word;
        } else {
          lines.add(word);
        }
      } else {
        currentLine = testLine;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return Container(
      width: screenWidth * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (String line in lines)
            Text(
              line,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalText(
      String text,
      Color color,
      double fontSize,
      String fontFamily,
      ) {
    return RotatedBox(
      quarterTurns: 1,
      child: Text(
        text,
        // 使用FontUtils獲取字體樣式
        style: FontUtils.getGoogleFontStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          color: color,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, PreviewMode mode) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        left: 16,
        right: 16,
        top: 8,
      ),
      decoration: BoxDecoration(
        color: _shouldBlurFooter
            ? Colors.transparent
            : Colors.black.withOpacity(0.4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: _shouldBlurFooter ? 5 : 0,
              sigmaY: _shouldBlurFooter ? 5 : 0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildButtonsForMode(mode),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtonsForMode(PreviewMode mode) {
    switch (mode) {
      case PreviewMode.fromCreate:
        return [
          ElevatedButton(
            onPressed: () => context.go('/create'),
            style: _buttonStyle(),
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: _saveScroller,
            style: _buttonStyle(),
            child: const Text('Save'),
          ),
        ];
      case PreviewMode.fromEdit:
        return [
          ElevatedButton(
            onPressed: () => context.go('/create'),
            style: _buttonStyle(),
            child: const Text('Edit'),
          ),
          ElevatedButton(
            onPressed: _saveScroller,
            style: _buttonStyle(),
            child: const Text('Update'),
          ),
        ];
      case PreviewMode.fromHome:
      default:
        return [
          ElevatedButton(
            onPressed: () => context.go('/'),
            style: _buttonStyle(),
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              final currentScroller = ref.read(currentScrollerProvider);
              if (currentScroller != null) {
                context.go('/create');
              }
            },
            style: _buttonStyle(),
            child: const Text('Edit'),
          ),
        ];
    }
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade800.withOpacity(0.7),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    );
  }
}