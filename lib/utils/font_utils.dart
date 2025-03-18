import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 字體工具類
/// 提供統一的GoogleFonts字體處理
/// 確保應用中所有頁面使用一致的字體
class FontUtils {
  /// 獲取Google Fonts風格
  /// 根據字體名稱返回對應的GoogleFonts字體樣式
  static TextStyle getGoogleFontStyle({
    required String fontFamily,
    required double fontSize,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    final baseStyle = TextStyle(
      fontSize: fontSize,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

    // 直接使用GoogleFonts的專用方法
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

  /// 從十六進制字符串轉換顏色
  static Color hexToColor(String hexString) {
    return Color(int.parse(hexString.replaceAll('#', '0xFF')));
  }
}