import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui'; // 用於模糊效果
import '../../providers/preview_mode_provider.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 從當前 Scroller 獲取 LED 效果狀態
    final scroller = ref.watch(currentScrollerProvider);
    if (scroller != null) {
      setState(() {
        _showLedEffect = scroller.ledBackgroundEnabled;
      });

      // 使用 Future 延遲更新 Provider，避免在構建期間修改
      Future(() {
        // 確保組件仍然掛載
        if (mounted) {
          // 同步全局 LED 效果狀態 (用於界面一致性)
          ref.read(ledEffectEnabledProvider.notifier).state = scroller.ledBackgroundEnabled;
        }
      });
    }

    // 確保當 currentScroller 變化時也更新動畫
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

      // 從當前 Scroller 獲取 LED 效果狀態
      final scroller = ref.read(currentScrollerProvider);
      if (scroller != null) {
        setState(() {
          _showLedEffect = scroller.ledBackgroundEnabled;
        });

        // 使用 addPostFrameCallback 確保在構建完成後更新
        // 同步全局 LED 效果狀態 (用於界面一致性)
        ref.read(ledEffectEnabledProvider.notifier).state = scroller.ledBackgroundEnabled;
      }
    });

    // 添加滾動監聽器來判斷是否需要模糊效果
    _scrollController.addListener(_updateBlurStatus);
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

  // 保存當前 Scroller
  void _saveScroller() {
    final scroller = ref.read(currentScrollerProvider);
    if (scroller == null) return;

    // 輸出調試信息
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

    // 保存或更新 Scroller
    final mode = ref.read(previewModeProvider);
    final isNew = mode == PreviewMode.fromCreate;

    if (isNew) {
      print('Creating new scroller');
      ref.read(scrollersProvider.notifier).addScroller(scroller);
    } else {
      print('Updating existing scroller');
      ref.read(scrollersProvider.notifier).updateScroller(scroller);
    }

    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isNew ? 'Scroller created' : 'Scroller updated'),
        backgroundColor: Colors.green,
      ),
    );

    // 導航到首頁
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

    final backgroundColor = Color(int.parse(scroller.backgroundColor.replaceAll('#', '0xFF')));
    final textColor = Color(int.parse(scroller.textColor.replaceAll('#', '0xFF')));

    // 確保 _showLedEffect 與 scroller.ledBackgroundEnabled 同步
    if (_showLedEffect != scroller.ledBackgroundEnabled) {
      setState(() {
        _showLedEffect = scroller.ledBackgroundEnabled;
      });
    }

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
          onPressed: () {
            // 根據預覽模式決定返回行為
            switch (previewMode) {
              case PreviewMode.fromCreate:
              case PreviewMode.fromEdit:
                context.go('/create'); // 返回創建/編輯頁面
                break;
              case PreviewMode.fromHome:
              default:
                context.go('/'); // 返回首頁
                break;
            }
          },
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

            // LED點陣效果 - 使用 scroller 的 ledBackgroundEnabled 屬性
            if (scroller.ledBackgroundEnabled)
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
                child: _buildBottomControls(context, previewMode),
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

  // 底部控制按鈕 - 根據預覽模式顯示不同的按鈕
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

  // 根據預覽模式構建不同的按鈕組合
  List<Widget> _buildButtonsForMode(PreviewMode mode) {
    switch (mode) {
      case PreviewMode.fromCreate:
      // 來自創建頁面 - 顯示編輯和保存按鈕
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
      // 來自編輯頁面 - 顯示編輯和更新按鈕
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
      // 來自首頁 - 顯示返回和編輯按鈕
        return [
          ElevatedButton(
            onPressed: () => context.go('/'),
            style: _buttonStyle(),
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/create'),
            style: _buttonStyle(),
            child: const Text('Edit'),
          ),
        ];
    }
  }

  // 按鈕樣式提取為方法以減少重複代碼
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