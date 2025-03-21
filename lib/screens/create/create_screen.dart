import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/scroller.dart';
import '../../providers/preview_mode_provider.dart';
import '../../providers/scroller_providers.dart';
import '../../utils/font_utils.dart';
import 'widgets/led_grid_painter.dart';
import 'widgets/tab_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// 建立/編輯Scroller頁面
/// 提供完整的Scroller設定界面，包含樣式和效果設定
/// 支援預覽和儲存功能
/// 根據Figma設計風格進行調整
class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _textController = TextEditingController();
  int _fontSize = 40;
  String _fontFamily = 'Roboto';
  String _textColor = '#FFFFFF';
  String _backgroundColor = '#9C27B0';
  ScrollDirection _direction = ScrollDirection.left;
  int _speed = 5;

  // LED背景開關狀態
  bool _ledBackgroundEnabled = true;

  // 判斷是否處於編輯模式
  bool get _isEditing => ref.read(currentScrollerProvider) != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize with current scroller if editing
    final currentScroller = ref.read(currentScrollerProvider);
    if (currentScroller != null) {
      _textController.text = currentScroller.text;
      _fontSize = currentScroller.fontSize;
      _fontFamily = currentScroller.fontFamily;
      _textColor = currentScroller.textColor;
      _backgroundColor = currentScroller.backgroundColor;
      _direction = currentScroller.direction;
      _speed = currentScroller.speed;
      // 從 Scroller 模型中獲取 LED 背景狀態
      _ledBackgroundEnabled = currentScroller.ledBackgroundEnabled;
    } else {
      // 如果是新建，設置初始文字
      _textController.text = "Happy New Year !!!!";
    }

    // 使用 addPostFrameCallback 在構建完成後更新 Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 同步全局 LED 效果狀態 (用於界面一致性)
      ref.read(ledEffectEnabledProvider.notifier).state = _ledBackgroundEnabled;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _saveScroller() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text')),
      );
      return;
    }

    // 輸出當前狀態信息
    print('Current state in CreateScreen:');
    print('- Text: ${_textController.text}');
    print('- Font size: $_fontSize');
    print('- Font family: $_fontFamily');
    print('- Text color: $_textColor');
    print('- Background color: $_backgroundColor');
    print('- Direction: $_direction');
    print('- Speed: $_speed');
    print('- LED Background Enabled: $_ledBackgroundEnabled');

    final scroller = _isEditing
        ? ref.read(currentScrollerProvider)!.copyWith(
      text: _textController.text,
      fontSize: _fontSize,
      fontFamily: _fontFamily,
      textColor: _textColor,
      backgroundColor: _backgroundColor,
      direction: _direction,
      speed: _speed,
      ledBackgroundEnabled: _ledBackgroundEnabled, // 保存 LED 背景狀態
    )
        : Scroller.create(
      text: _textController.text,
      fontSize: _fontSize,
      fontFamily: _fontFamily,
      textColor: _textColor,
      backgroundColor: _backgroundColor,
      direction: _direction,
      speed: _speed,
      ledBackgroundEnabled: _ledBackgroundEnabled, // 保存 LED 背景狀態
    );

    // 輸出將要保存的 Scroller 信息
    print('Scroller to be saved:');
    print('- ID: ${scroller.id}');
    print('- Text: ${scroller.text}');
    print('- Font size: ${scroller.fontSize}');
    print('- Font family: ${scroller.fontFamily}');
    print('- Text color: ${scroller.textColor}');
    print('- Background color: ${scroller.backgroundColor}');
    print('- Direction: ${scroller.direction}');
    print('- Speed: ${scroller.speed}');
    print('- LED Background Enabled: ${scroller.ledBackgroundEnabled}');

    if (_isEditing) {
      print('Updating existing scroller');
      ref.read(scrollersProvider.notifier).updateScroller(scroller);
    } else {
      print('Creating new scroller');
      ref.read(scrollersProvider.notifier).addScroller(scroller);
    }

    // 使用 go 替代 pop
    context.go('/');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Scroller updated' : 'Scroller created'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showPreview() {
    final currentScroller = ref.read(currentScrollerProvider);

    // 創建或更新臨時預覽用的Scroller
    final previewScroller = currentScroller == null
        ? Scroller.create(
      text: _textController.text.isEmpty
          ? 'Preview Text'
          : _textController.text,
      fontSize: _fontSize,
      fontFamily: _fontFamily,
      textColor: _textColor,
      backgroundColor: _backgroundColor,
      direction: _direction,
      speed: _speed,
      ledBackgroundEnabled: _ledBackgroundEnabled, // 包含 LED 背景狀態
    )
        : currentScroller.copyWith(
      text: _textController.text,
      fontSize: _fontSize,
      fontFamily: _fontFamily,
      textColor: _textColor,
      backgroundColor: _backgroundColor,
      direction: _direction,
      speed: _speed,
      ledBackgroundEnabled: _ledBackgroundEnabled, // 包含 LED 背景狀態
    );

    // 更新當前的Scroller提供者
    ref.read(currentScrollerProvider.notifier).state = previewScroller;

    // 確保預覽頁面使用當前的LED效果設置 - 這是在按鈕事件中所以可以安全更新
    ref.read(ledEffectEnabledProvider.notifier).state = _ledBackgroundEnabled;

    // 設置預覽模式
    ref.read(previewModeProvider.notifier).state =
    _isEditing ? PreviewMode.fromEdit : PreviewMode.fromCreate;

    // 統一使用 go 導航到預覽頁面
    context.go('/preview');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Led Scroller' : 'Create Led Scroller'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveScroller,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 預覽卡片
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Color(
                      int.parse(_backgroundColor.replaceAll('#', '0xFF'))),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // 原有的背景和文字
                    Container(
                      color: Color(
                          int.parse(_backgroundColor.replaceAll('#', '0xFF'))),
                      child: Center(
                        child: Text(
                          _textController.text.isEmpty ? 'Happy New Year !!!!' : _textController.text,
                          style: _getFontStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // LED遮罩
                    if (_ledBackgroundEnabled)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: LedGridPainter(),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // 文字輸入區域
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2A2A3E),
                  hintText: 'Enter text',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20.0),
                ),
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
              ),

              // 標籤頁區域
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF24243D),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.purple.withOpacity(0.3), width: 1),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Style'),
                          Tab(text: 'Effect'),
                        ],
                        indicatorColor: Colors.purple.shade400,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.purple.shade400,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                          height: 1, thickness: 1, color: Color(0xFF333355)),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            StyleTab(
                              fontSize: _fontSize,
                              fontFamily: _fontFamily,
                              textColor: _textColor,
                              backgroundColor: _backgroundColor,
                              // 新增背景顏色
                              onFontSizeChanged: (size) =>
                                  setState(() => _fontSize = size),
                              onFontFamilyChanged: (family) =>
                                  setState(() => _fontFamily = family),
                              onTextColorChanged: (color) =>
                                  setState(() => _textColor = color),
                              onBackgroundColorChanged: (color) => setState(
                                      () => _backgroundColor = color), // 新增背景顏色更改處理
                            ),
                            EffectTab(
                              direction: _direction,
                              speed: _speed,
                              ledBackgroundOn: _ledBackgroundEnabled, // 使用本地狀態
                              onDirectionChanged: (dir) =>
                                  setState(() => _direction = dir),
                              onSpeedChanged: (spd) =>
                                  setState(() => _speed = spd),
                              onLedBackgroundChanged: (isOn) {
                                setState(() => _ledBackgroundEnabled = isOn);

                                // 可以安全地在用戶操作回調中更新 Provider
                                ref.read(ledEffectEnabledProvider.notifier).state = isOn;
                                print('LED background changed to: $isOn');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 底部按鈕 - 更新文字以符合當前模式
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showPreview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF31314F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'View Full Screen',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveScroller,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF31314F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isEditing ? 'Update' : 'Save', // 根據模式調整按鈕文本
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getFontStyle() {
    return FontUtils.getGoogleFontStyle(
      fontFamily: _fontFamily,
      fontSize: _fontSize.toDouble(),
      color: Color(int.parse(_textColor.replaceAll('#', '0xFF'))),
    );
  }
}