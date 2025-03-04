import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/scroller.dart';
import '../../providers/scroller_providers.dart';
import 'widgets/color_picker.dart';

/// 建立/編輯Scroller頁面
/// 提供完整的Scroller設定界面，包含樣式和效果設定
/// 支援預覽和儲存功能
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
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit LED Scroller' : 'Create LED Scroller'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveScroller,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Style'),
            Tab(text: 'Effect'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStyleTab(),
          _buildEffectTab(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
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
                  child: const Text('Preview'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _saveScroller,
                  child: const Text('Save'),
                ),
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
          // Preview card
          Card(
            margin: const EdgeInsets.only(bottom: 24.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(int.parse(_backgroundColor.replaceAll('#', '0xFF'))),
              ),
              child: Text(
                _textController.text.isEmpty ? 'Sample Text' : _textController.text,
                style: TextStyle(
                  fontSize: _fontSize.toDouble(),
                  fontFamily: _fontFamily,
                  color: Color(int.parse(_textColor.replaceAll('#', '0xFF'))),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Text input
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Text',
              border: OutlineInputBorder(),
              hintText: 'Enter text to display',
            ),
            maxLength: 100,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),

          // Font size
          const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [20, 40, 60, 80, 100].map((size) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text('$size'),
                    selected: _fontSize == size,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _fontSize = size;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Font family
          const Text('Fonts', style: TextStyle(fontWeight: FontWeight.bold)),
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

          // Color picker
          const Text('Text Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ColorPicker(
            currentColor: _textColor,
            onColorSelected: (color) {
              setState(() {
                _textColor = color;
              });
            },
          ),
          const SizedBox(height: 24),

          const Text('Background Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ColorPicker(
            currentColor: _backgroundColor,
            onColorSelected: (color) {
              setState(() {
                _backgroundColor = color;
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
          // Direction
          const Text('Direction', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDirectionButton(ScrollDirection.left, Icons.arrow_back),
              _buildDirectionButton(ScrollDirection.right, Icons.arrow_forward),
              _buildDirectionButton(ScrollDirection.up, Icons.arrow_upward),
              _buildDirectionButton(ScrollDirection.down, Icons.arrow_downward),
            ],
          ),
          const SizedBox(height: 24),

          // Speed
          const Text('Speed', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Slider(
            value: _speed.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: _speed.toString(),
            onChanged: (value) {
              setState(() {
                _speed = value.toInt();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Slow'),
              Text('Fast'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFontOption(String fontFamily, String sample) {
    final isSelected = _fontFamily == fontFamily;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _fontFamily = fontFamily;
          });
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              sample,
              style: TextStyle(
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionButton(ScrollDirection direction, IconData icon) {
    final isSelected = _direction == direction;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _direction = direction;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceVariant,
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurfaceVariant,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon),
    );
  }
}