import 'package:flutter/material.dart';
import '../../../models/scroller.dart';
import 'color_picker.dart';

/// Style 標籤內容組件
class StyleTab extends StatelessWidget {
  final int fontSize;
  final String fontFamily;
  final String textColor;
  final Function(int) onFontSizeChanged;
  final Function(String) onFontFamilyChanged;
  final Function(String) onTextColorChanged;

  const StyleTab({
    Key? key,
    required this.fontSize,
    required this.fontFamily,
    required this.textColor,
    required this.onFontSizeChanged,
    required this.onFontFamilyChanged,
    required this.onTextColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                final isSelected = fontSize == size;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => onFontSizeChanged(size),
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
            currentColor: textColor,
            onColorSelected: onTextColorChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFontOption(String fontName, String sample) {
    final isSelected = fontFamily == fontName;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => onFontFamilyChanged(fontName),
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
}

/// Effect 標籤內容組件
class EffectTab extends StatelessWidget {
  final ScrollDirection direction;
  final int speed;
  final bool ledBackgroundOn;
  final Function(ScrollDirection) onDirectionChanged;
  final Function(int) onSpeedChanged;
  final Function(bool) onLedBackgroundChanged;

  const EffectTab({
    Key? key,
    required this.direction,
    required this.speed,
    required this.ledBackgroundOn,
    required this.onDirectionChanged,
    required this.onSpeedChanged,
    required this.onLedBackgroundChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  Widget _buildDirectionButton(ScrollDirection dir, IconData icon) {
    final isSelected = direction == dir;

    return GestureDetector(
      onTap: () => onDirectionChanged(dir),
      child: Container(
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
    final isSelected = speed == spd;

    return GestureDetector(
      onTap: () => onSpeedChanged(spd),
      child: Container(
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
    final isSelected = isOn == ledBackgroundOn;

    return GestureDetector(
      onTap: () => onLedBackgroundChanged(isOn),
      child: Container(
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