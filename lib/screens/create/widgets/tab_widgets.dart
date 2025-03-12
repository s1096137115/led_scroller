import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/scroller.dart';
import 'wheel_color_picker.dart';

/// Style 標籤內容組件
class StyleTab extends StatelessWidget {
  final int fontSize;
  final String fontFamily;
  final String textColor;
  final String backgroundColor;
  final Function(int) onFontSizeChanged;
  final Function(String) onFontFamilyChanged;
  final Function(String) onTextColorChanged;
  final Function(String) onBackgroundColorChanged;

  const StyleTab({
    Key? key,
    required this.fontSize,
    required this.fontFamily,
    required this.textColor,
    required this.backgroundColor,
    required this.onFontSizeChanged,
    required this.onFontFamilyChanged,
    required this.onTextColorChanged,
    required this.onBackgroundColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 字體大小選擇
            const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16, // 統一間距為16
              runSpacing: 16, // 統一行間距為16
              children: [20, 40, 60, 80, 100].map((size) {
                return _buildSizeBox(context, size);
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 字體選擇
            const Text('Fonts', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16, // 統一間距為16
              runSpacing: 16, // 統一行間距為16
              children: [
                _buildFontBox(context, 'Abhaya Libre', 'Aa'),
                _buildFontBox(context, 'ABeeZee', 'Aa'),
                _buildFontBox(context, 'Aclonica', 'Aa'),
                _buildFontBox(context, 'Oswald', 'Aa'),
                _buildFontBox(context, 'Pacifico', 'Aa'), // 替換 Agbalumo
                _buildFontBox(context, 'Alfa Slab One', 'Aa'),
                _buildFontBox(context, 'Roboto', 'Aa'),
                _buildFontBox(context, 'Lato', 'Aa'),
                _buildFontBox(context, 'Bangers', 'Aa'),
                _buildFontBox(context, 'Bungee Inline', 'Aa'),
              ],
            ),
            const SizedBox(height: 24),

            // 文字顏色
            const Text('Text Color', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                LedColorPicker(
                  currentColor: textColor,
                  onColorSelected: onTextColorChanged,
                  isTextColor: true,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 背景顏色
            const Text('Background Color', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                LedColorPicker(
                  currentColor: backgroundColor,
                  onColorSelected: onBackgroundColorChanged,
                  isTextColor: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeBox(BuildContext context, int size) {
    final bool isSelected = fontSize == size;
    return GestureDetector(
      onTap: () => onFontSizeChanged(size),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade600,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            '$size',
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFontBox(BuildContext context, String fontFamily, String sample) {
    final bool isSelected = this.fontFamily == fontFamily;
    return GestureDetector(
      onTap: () => onFontFamilyChanged(fontFamily),
      child: Container(
        width: 50, // 50x50的框
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade600,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            sample, // 'Aa'
            style: _getGoogleFontStyle(
                fontFamily,
                16,
                isSelected ? Colors.white : Colors.grey.shade400
            ),
          ),
        ),
      ),
    );
  }

  // 直接使用GoogleFonts的專用方法
  TextStyle _getGoogleFontStyle(String fontFamily, double fontSize, Color color) {
    final TextStyle baseStyle = TextStyle(
      fontSize: fontSize,
      color: color,
    );

    // 使用直接的方法而不是getFont
    switch (fontFamily) {
      case 'Abhaya Libre':
        return GoogleFonts.abhayaLibre(textStyle: baseStyle);
      case 'ABeeZee':
        return GoogleFonts.aBeeZee(textStyle: baseStyle);
      case 'Aclonica':
        return GoogleFonts.aclonica(textStyle: baseStyle);
      case 'Oswald':
        return GoogleFonts.oswald(textStyle: baseStyle);
      case 'Pacifico':
        return GoogleFonts.pacifico(textStyle: baseStyle);
      case 'Alfa Slab One':
        return GoogleFonts.alfaSlabOne(textStyle: baseStyle);
      case 'Roboto':
        return GoogleFonts.roboto(textStyle: baseStyle);
      case 'Lato':
        return GoogleFonts.lato(textStyle: baseStyle);
      case 'Bangers':
        return GoogleFonts.bangers(textStyle: baseStyle);
      case 'Bungee Inline':
        return GoogleFonts.bungeeInline(textStyle: baseStyle);
      default:
        return GoogleFonts.roboto(textStyle: baseStyle); // 備用字體
    }
  }
}

/// Effect標籤內容
/// 處理滾動方向、速度和特效設定
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 滾動方向
            const Text('Direction', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDirectionButton(context, ScrollDirection.left, Icons.arrow_back),
                _buildDirectionButton(context, ScrollDirection.right, Icons.arrow_forward),
                _buildDirectionButton(context, ScrollDirection.up, Icons.arrow_upward),
                _buildDirectionButton(context, ScrollDirection.down, Icons.arrow_downward),
              ],
            ),
            const SizedBox(height: 24),

            // 滾動速度
            const Text('Speed', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Slow'),
                Expanded(
                  child: Slider(
                    value: speed.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: speed.toString(),
                    onChanged: (value) => onSpeedChanged(value.toInt()),
                  ),
                ),
                const Text('Fast'),
              ],
            ),
            const SizedBox(height: 24),

            // LED背景效果
            const Text('LED Effect', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('LED Background'),
              value: ledBackgroundOn,
              onChanged: onLedBackgroundChanged,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionButton(BuildContext context, ScrollDirection dir, IconData icon) {
    final bool isSelected = direction == dir;
    return GestureDetector(
      onTap: () => onDirectionChanged(dir),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade600,
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey.shade400,
            size: 30,
          ),
        ),
      ),
    );
  }
}