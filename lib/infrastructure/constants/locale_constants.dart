import 'dart:ui';

class LocaleConstants {
  static const Locale enUS = Locale('en', 'US');
  static const Locale viVN = Locale('vi', 'VN');
  static const Locale jaJP = Locale('ja', 'JP');
  static const Locale zhCN = Locale('zh', 'CN');
  static const Locale koKR = Locale('ko', 'KR');
  static const Locale frFR = Locale('fr', 'FR');
  static const Locale esES = Locale('es', 'ES');
  static const Locale ptBR = Locale('pt', 'BR');

  static const Locale fallback = enUS;

  static const List<Locale> all = [
    enUS, viVN, jaJP, zhCN, koKR, frFR, esES, ptBR,
  ];
}
