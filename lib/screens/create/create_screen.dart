import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/scroller.dart';
import '../../providers/scroller_providers.dart';
import 'widgets/color_picker.dart';
import 'widgets/led_grid_painter.dart';

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
      backgroundColor: const Color(0xFF1A1A2E), // 深色背景，匹配設計稿
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
              // 預覽卡片 - 紫色背景
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

              // 文字輸入區域 - 根據Figma設計，沒有計數器
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
                            _buildStyleTab(),
                            _buildEffectTab(),
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

  Widget _buildStyleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 字體大小
          const Text('Size', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [20, 40, 60, 80, 100].map((size) {
                final isSelected = _fontSize == size;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _fontSize = size;
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.purple : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.purple : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$size',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // 字體選擇
          const Text('Fonts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFontOption('Roboto', 'Aa'),
                _buildFontOption('Arial', 'Aa'),
                _buildFontOption('Times New Roman', 'Aa'),
                _buildFontOption('Courier New', 'Aa'),
                _buildFontOption('Georgia', 'Aa'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 文字顏色
          const Text('Text Color', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          ColorPicker(
            currentColor: _textColor,
            onColorSelected: (color) {
              setState(() {
                _textColor = color;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEffectTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 方向按鈕
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDirectionButton(ScrollDirection.right, Icons.arrow_forward),
              _buildDirectionButton(ScrollDirection.left, Icons.arrow_back),
              _buildDirectionButton(ScrollDirection.up, Icons.arrow_upward),
              _buildDirectionButton(ScrollDirection.down, Icons.arrow_downward),
            ],
          ),
          const SizedBox(height: 32),

          // 速度按鈕
          const Text('Speed Scroll', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpeedButton(0, "0"),
              _buildSpeedButton(3, "0.5x"),
              _buildSpeedButton(5, "1x"),
              _buildSpeedButton(8, "5x"),
              _buildSpeedButton(10, "10x"),
            ],
          ),
          const SizedBox(height: 32),

          // LED背景選項
          const Text('Led background', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLedBackgroundButton(false, "Off"),
              const SizedBox(width: 16),
              _buildLedBackgroundButton(true, "On"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFontOption(String fontName, String sample) {
    final isSelected = _fontFamily == fontName;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _fontFamily = fontName;
          });
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.purple : Colors.grey.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              sample,
              style: TextStyle(
                fontFamily: fontName,
                color: isSelected ? Colors.purple : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionButton(ScrollDirection dir, IconData icon) {
    final isSelected = _direction == dir;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: isSelected ? Colors.purple.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _direction = dir;
            });
          },
          child: Center(
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedButton(int spd, String label) {
    final isSelected = _speed == spd;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: isSelected ? Colors.purple.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _speed = spd;
            });
          },
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLedBackgroundButton(bool isOn, String label) {
    final isSelected = isOn == _ledBackgroundOn;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: isSelected ? Colors.purple.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _ledBackgroundOn = isOn;
            });
          },
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}