import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui'; // 用於模糊效果
import '../../providers/scroller_providers.dart';
import '../../models/scroller.dart';
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
  bool _showControls = true;
  final ScrollController _scrollController = ScrollController();
  bool _shouldBlurHeader = false;
  bool _shouldBlurFooter = false;

  // 監聽LED效果狀態變化
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showLedEffect = ref.watch(ledEffectEnabledProvider);

    // 確保當 currentScroller 變化時也更新動畫
    final scroller = ref.watch(currentScrollerProvider);
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

    // 初始化適當的動畫方向
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimation(); // 確保動畫在初始化時立即更新
    });

    // 添加滾動監聽器來判斷是否需要模糊效果
    _scrollController.addListener(_updateBlurStatus);

    // 從Provider獲取LED效果狀態
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showLedEffect = ref.read(ledEffectEnabledProvider);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_updateBlurStatus);
    _scrollController.dispose();
    super.dispose();
  }

  // 根據滾動位置更新模糊狀態
  void _updateBlurStatus() {
    final scroller = ref.read(currentScrollerProvider);
    if (scroller == null) return;

    if (_scrollController.hasClients) {
      final textLength = scroller.text.length;
      final threshold = 50; // 假設超過50個字符時需要模糊效果

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

    // 調整速度 (1是最慢, 10是最快)
    final speedFactor = scroller.speed / 5; // 標準化速度

    // 根據速度計算動畫持續時間
    final duration = Duration(seconds: (15 / speedFactor).round());

    // 重設控制器以應用新的持續時間
    _controller.duration = duration;
    _controller.reset();
    _controller.repeat(reverse: false);

    // 根據方向和排列設置動畫
    switch (scroller.direction) {
      case ScrollDirection.left:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(-1.0, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        setState(() {
          _isVertical = false; // 確保水平顯示
        });
        break;
      case ScrollDirection.right:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: const Offset(1.0, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        setState(() {
          _isVertical = false; // 確保水平顯示
        });
        break;
      case ScrollDirection.up:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, -1.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        setState(() {
          _isVertical = true; // 確保垂直顯示
        });
        break;
      case ScrollDirection.down:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: const Offset(0.0, 1.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        setState(() {
          _isVertical = true; // 確保垂直顯示
        });
        break;
    }
  }

  // 切換控制界面顯示
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  // 從Provider更新LED效果狀態
  void _updateLedEffectState() {
    setState(() {
      _showLedEffect = ref.read(ledEffectEnabledProvider);
    });
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
      extendBodyBehindAppBar: true,
      appBar: _showControls ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('View Full Screen'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'), // 使用go而不是pop
        ),
        flexibleSpace: _shouldBlurHeader ? ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ) : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
      ) : null,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // 主內容區域
            Container(
              width: double.infinity,
              height: double.infinity,
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

            // LED點陣效果
            if (_showLedEffect)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: LedGridPainter(),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),

            // 底部控制欄
            if (_showControls)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomControls(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalText(String text, Color color, double fontSize, String fontFamily) {
    return RotatedBox(
      quarterTurns: 3, // 旋轉使文字垂直
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: fontFamily,
          letterSpacing: 1.2,
          height: 1.2, // 改善行高
          fontWeight: FontWeight.w500, // 稍微加粗以提高清晰度
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

  // 底部控制按鈕
  Widget _buildBottomControls(BuildContext context) {
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
            children: [
              ElevatedButton(
                onPressed: () => context.go('/'), // 使用go替代pop
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 使用go替代push
                  context.go('/create');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}