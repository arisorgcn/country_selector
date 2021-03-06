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
import 'package:flutter/material.dart';

import 'aris_country_localizations.dart';
import 'constants/country_codes.dart';

///
/// CountryCodeItem Model
/// @author Aris Hu created at 2020-12-12
///
class ArisCountryCodeItem {
  /// 是不是tag
  final bool isTag;

  /// TAG名称
  final String tagName;

  /// 国家语言
  final String langCode;

  /// 语言变体标识
  final String scriptCode;

  /// 国家代码 (CN, IT,AF..)
  final String code;

  /// 国家名称
  String name;

  /// 国家名称英文
  String countryName;

  /// 国家名称拼音首字符
  String namePinyin;

  /// 国家名称首字母拼音
  String nameFirstWordPinyin;

  /// 电话区号 (+39,+93..)
  final String dialCode;

  ArisCountryCodeItem({
    this.isTag = false,
    this.tagName,
    this.langCode,
    this.scriptCode,
    this.code,
    this.name,
    this.countryName,
    this.namePinyin,
    this.nameFirstWordPinyin,
    this.dialCode,
  }) {
    if (this.isTag) {
      assert(tagName != null, 'tagName should not be null when isTag is set');
    }
  }

  factory ArisCountryCodeItem.fromCode(String isoCode) {
    final Map<String, String> jsonCode = codes.firstWhere(
      (item) => item['code'] == isoCode,
      orElse: () => null,
    );

    if (jsonCode == null) {
      return null;
    }
    return ArisCountryCodeItem.fromJson(jsonCode);
  }

  factory ArisCountryCodeItem.fromJson(Map<String, dynamic> json) {
    return ArisCountryCodeItem(
      name: json['name'],
      code: json['code'],
      dialCode: json['dialCode'],
      countryName: json['countryName'],
    );
  }

  /// get country name for specific locale
  ArisCountryCodeItem localize(BuildContext context) {
    return this..name = ArisCountryLocalizations.of(context)?.translate(this.code) ?? this.name;
  }

  /// to dialCode string only
  @override
  String toString() => "$dialCode";

  /// to long string
  String toLongString() {
    final String country = this.toCountryStringOnly();
    return "$country($dialCode)";
  }

  /// to country string only
  String toCountryStringOnly() {
    return '$name';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArisCountryCodeItem &&
          runtimeType == other.runtimeType &&
          isTag == other.isTag &&
          tagName == other.tagName &&
          langCode == other.langCode &&
          scriptCode == other.scriptCode &&
          code == other.code &&
          name == other.name &&
          countryName == other.countryName &&
          namePinyin == other.namePinyin &&
          nameFirstWordPinyin == other.nameFirstWordPinyin &&
          dialCode == other.dialCode;

  @override
  int get hashCode =>
      isTag.hashCode ^
      tagName.hashCode ^
      langCode.hashCode ^
      scriptCode.hashCode ^
      code.hashCode ^
      name.hashCode ^
      countryName.hashCode ^
      namePinyin.hashCode ^
      nameFirstWordPinyin.hashCode ^
      dialCode.hashCode;
}
