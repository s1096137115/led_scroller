import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/scroller.dart';
import '../../providers/scroller_providers.dart';
import 'widgets/color_picker.dart';
import 'widgets/led_grid_painter.dart';
import 'widgets/tab_widgets.dart';

/// 建立/編輯Scroller頁面
/// 提供完整的Scroller設定界面，包含樣式和效果設定
/// 支援預覽和儲存功能
/// 根據Figma設計風格進行調整
class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _textController = TextEditingController();
  int _fontSize = 40;
  String _fontFamily = 'Roboto';
  String _textColor = '#FFFFFF';
  String _backgroundColor = '#9C27B0';
  ScrollDirection _direction = ScrollDirection.left;
  int _speed = 5;

  // LED背景開關狀態
  bool _ledBackgroundOn = false;

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
    } else {
      // 如果是新建，設置初始文字
      _textController.text = "Happy New Year !!!!";
    }
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

    final scroller = _isEditing
        ? ref.read(currentScrollerProvider)!.copyWith(
      text: _textController.text,
      fontSize: _fontSize,
      fontFamily: _fontFamily,
      textColor: _textColor,
      backgroundColor: _backgroundColor,
      direction: _direction,
      speed: _speed,
    )
        : Scroller.create(
      text: _textController.text,
      fontSize: _fontSize,
      fontFamily: _fontFamily,
      textColor: _textColor,
      backgroundColor: _backgroundColor,
      direction: _direction,
      speed: _speed,
    );

    if (_isEditing) {
      ref.read(scrollersProvider.notifier).updateScroller(scroller);
    } else {
      ref.read(scrollersProvider.notifier).addScroller(scroller);
    }

    context.pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Scroller updated' : 'Scroller created'),
        backgroundColor: Colors.green,
      ),
    );
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
          onPressed: () => context.pop(),
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
                  color: Color(int.parse(_backgroundColor.replaceAll('#', '0xFF'))),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // LED效果網格(當LED背景開啟時顯示)
                    if (_ledBackgroundOn)
                      Opacity(
                        opacity: 0.4,
                        child: CustomPaint(
                          painter: LedGridPainter(Color(int.parse(_backgroundColor.replaceAll('#', '0xFF')))),
                          size: Size.infinite,
                        ),
                      ),
                    // 文字內容
                    Center(
                      child: Text(
                        _textController.text.isEmpty ? 'Happy New Year !!!!' : _textController.text,
                        style: TextStyle(
                          fontSize: _fontSize.toDouble(),
                          fontFamily: _fontFamily,
                          color: Color(int.parse(_textColor.replaceAll('#', '0xFF'))),
                        ),
                        textAlign: TextAlign.center,
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
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
                    border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
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
                        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFF333355)),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            StyleTab(
                              fontSize: _fontSize,
                              fontFamily: _fontFamily,
                              textColor: _textColor,
                              onFontSizeChanged: (size) => setState(() => _fontSize = size),
                              onFontFamilyChanged: (family) => setState(() => _fontFamily = family),
                              onTextColorChanged: (color) => setState(() => _textColor = color),
                            ),
                            EffectTab(
                              direction: _direction,
                              speed: _speed,
                              ledBackgroundOn: _ledBackgroundOn,
                              onDirectionChanged: (dir) => setState(() => _direction = dir),
                              onSpeedChanged: (spd) => setState(() => _speed = spd),
                              onLedBackgroundChanged: (isOn) => setState(() => _ledBackgroundOn = isOn),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 底部按鈕
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final previewScroller = Scroller.create(
                          text: _textController.text.isEmpty ? 'Preview Text' : _textController.text,
                          fontSize: _fontSize,
                          fontFamily: _fontFamily,
                          textColor: _textColor,
                          backgroundColor: _backgroundColor,
                          direction: _direction,
                          speed: _speed,
                        );
                        ref.read(currentScrollerProvider.notifier).state = previewScroller;
                        context.push('/preview');
                      },
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
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 16),
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
}