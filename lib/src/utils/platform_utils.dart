import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DevicePlatform {
  /// Android: <https://www.android.com/>
  android,

  /// Fuchsia: <https://fuchsia.dev/fuchsia-src/concepts>
  fuchsia,

  /// iOS: <https://www.apple.com/ios/>
  iOS,

  /// Linux: <https://www.linux.org>
  linux,

  /// macOS: <https://www.apple.com/macos>
  macOS,

  /// Windows: <https://www.windows.com>
  windows,

  /// Web
  web,

  /// Use this to specify you want to use the default device platform
  device,
}

class PlatformUtils {
  static DevicePlatform detectPlatform(BuildContext context) {
    if (kIsWeb) return DevicePlatform.web;

    final platform = Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.android:
        return DevicePlatform.android;
      case TargetPlatform.fuchsia:
        return DevicePlatform.fuchsia;
      case TargetPlatform.iOS:
        return DevicePlatform.iOS;
      case TargetPlatform.linux:
        return DevicePlatform.linux;
      case TargetPlatform.macOS:
        return DevicePlatform.macOS;
      case TargetPlatform.windows:
        return DevicePlatform.windows;
    }
  }

  static bool languageIsRTL(BuildContext context) {
    const rtlLanguages = [
      "ar",
      "arc",
      "dv",
      "fa",
      "ha",
      "he",
      "khw",
      "ks",
      "ku",
      "ps",
      "ur",
      "yi",

      // Primary RTL Languages
      "ar", // Arabic
      "fa", // Persian (Farsi)
      "he", // Hebrew
      "ps", // Pashto
      "ur", // Urdu
      "yi", // Yiddish

      // Other commonly cited RTL languages/scripts
      "arc", // Aramaic (modern and classical Syriac script)
      "ckb", // Kurdish (Sorani, which uses Arabic script)
      "dv", // Divehi (Maldivian) - uses the Thaana script
      "ha", // Hausa (when written in Ajami/Arabic script)
      "khw", // Khowar (uses a modified Urdu script)
      "ks", // Kashmiri (often uses Perso-Arabic script)
      "ku", // Kurdish (covers Sorani and others)
      "mly", // Malay (when written in Jawi/Arabic script)
      "sd", // Sindhi (often uses Perso-Arabic script)
      "syr", // Syriac
      "ug", // Uyghur (uses Perso-Arabic script
    ];
    final language = Localizations.localeOf(context).languageCode.toLowerCase();

    return rtlLanguages.contains(language);
  }


}
