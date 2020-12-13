////////////////////////////////////////////////////////////////////////////////////////////////////
//  Copyright www.aris.org.cn JamesTaylor
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////////
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// Localization class
/// @author Aris Hu created at 2020-12-12
///
class ArisCountryLocalizations {
  final Locale locale;

  ArisCountryLocalizations(this.locale);

  /// 获取指定类型下面的国际化文件
  static ArisCountryLocalizations of(BuildContext context) {
    return Localizations.of<ArisCountryLocalizations>(context, ArisCountryLocalizations);
  }

  static const LocalizationsDelegate<ArisCountryLocalizations> delegate = _ArisCountryLocalizationsDelegate();

  /// 国际化字符串
  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    print('locale.languageCode: ${locale.toString()}');
    String jsonString = await rootBundle.loadString('packages/country_selector/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _ArisCountryLocalizationsDelegate extends LocalizationsDelegate<ArisCountryLocalizations> {
  const _ArisCountryLocalizationsDelegate();

  /// 是否支持选中的语言
  @override
  bool isSupported(Locale locale) {
    return [
      'zh',
      'en',
      'es',
      'ko',
    ].contains(locale.languageCode);
  }

  @override
  Future<ArisCountryLocalizations> load(Locale locale) async {
    ArisCountryLocalizations localizations = new ArisCountryLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<ArisCountryLocalizations> old) => false;
}
