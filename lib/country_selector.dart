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

library country_selector;

import 'dart:io';

import 'package:country_selector/aris_country_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'aris_country_code_item.dart';
import 'aris_country_params.dart';
import 'constants/country_codes.dart';

///
/// main widget
/// @author Aris Hu created at 2020-12-14
///
class ArisCountrySelector extends StatefulWidget {
  /// the title of the list page
  final String listPageTitle;

  /// the text of cancel page in list page
  final String listPageCancelButtonText;

  /// the hint text of search
  final String listPageSearchHint;

  /// appbar theme of list page
  final AppBarTheme listPageAppBarTheme;

  /// text theme of list page
  final TextTheme listPageTextTheme;

  /// the text style
  final TextStyle textStyle;

  /// the text style when text overflows
  final TextOverflow textOverflow;

  /// the padding of button
  final EdgeInsetsGeometry padding;

  /// 初始值, 可以是国家代码,国家名称或国家手机区号, 'CN' or '中国' or '+86'
  final String initialSelection;

  /// 热门国家和地区
  final List<String> favorite;

  /// 文本是否左对齐
  final bool alignLeft;

  /// callback when user back from list page
  final Function(ArisCountryParams) onSelected;

  /// 选中的地区
  final Locale locale;

  /// 是否同时显示国家与地区代码
  final bool showCountryAndCode;

  /// 是否只显示国家
  final bool showCountryOnly;

  ArisCountrySelector({
    Key key,
    @required this.listPageTitle,
    @required this.listPageCancelButtonText,
    @required this.onSelected,
    this.listPageSearchHint = '',
    this.alignLeft = true,
    this.textStyle,
    this.textOverflow = TextOverflow.clip,
    this.padding = const EdgeInsets.all(0.0),
    this.initialSelection,
    this.favorite = const [],
    this.locale,
    this.showCountryAndCode = true,
    this.showCountryOnly = false,
    this.listPageAppBarTheme = const AppBarTheme(
        brightness: Brightness.light,
        color: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black87, size: 16),
        actionsIconTheme: IconThemeData(color: Colors.black87, size: 24),
        textTheme: TextTheme(
          headline5: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.normal),
          headline6: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
          subtitle1: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
          subtitle2: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Colors.black12, fontSize: 14, fontWeight: FontWeight.normal),
          caption: TextStyle(color: Colors.black12, fontSize: 12, fontWeight: FontWeight.normal),
          button: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),
        )),
    this.listPageTextTheme = const TextTheme(
      headline5: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.normal),
      headline6: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
      subtitle2: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(color: Colors.black12, fontSize: 14, fontWeight: FontWeight.normal),
      caption: TextStyle(color: Colors.black12, fontSize: 12, fontWeight: FontWeight.normal),
      button: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),
    ),
  }) : super(key: key);

  @override
  _ArisCountrySelectorState createState() {
    // json列表
    List<Map> jsonList = codes;

    /// 将json列表转成DemaCountryCodeItem列表
    List<ArisCountryCodeItem> elements =
        jsonList.map((countryJson) => ArisCountryCodeItem.fromJson(countryJson)).toList();

    return _ArisCountrySelectorState(elements);
  }
}

class _ArisCountrySelectorState extends State<ArisCountrySelector> {
  /// selected Item
  ArisCountryCodeItem selectedItem;

  /// all Country code items
  List<ArisCountryCodeItem> elements = [];

  /// favorite code items
  List<ArisCountryCodeItem> favoriteElements = [];

  ArisCountryParams callbackParams = ArisCountryParams();

  /// 系统默认地区代码
  final String sysLocaleCountryCode = Platform.localeName.substring(Platform.localeName.lastIndexOf(RegExp('_')) + 1);

  _ArisCountrySelectorState(this.elements);

  @override
  void initState() {
    super.initState();
    // 初始选择
    _initSelectedItem();

    // 初始化热门国家
    _initFavoriteItems();
  }

  /// 初始化热门国家和地区列表
  void _initFavoriteItems() {
    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhere(
                (f) =>
                    e.code.toUpperCase() == f.toUpperCase() ||
                    e.dialCode.contains(f.toUpperCase()) ||
                    e.name.toUpperCase().contains(RegExp(f.toUpperCase())),
                orElse: () => null) !=
            null)
        .toList();
  }

  /// 初始化 selectedItem
  void _initSelectedItem() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection) ||
              (e.name.toUpperCase() == widget.initialSelection.toUpperCase()),
          orElse: () => _initSelectedItemByLocale());
    } else {
      selectedItem = _initSelectedItemByLocale();
    }
  }

  /// 根据默认locale初始化selectedItem
  ArisCountryCodeItem _initSelectedItemByLocale() {
    var _selectedItem;
    Locale _locale = widget.locale;
    if (_locale != null) {
      // 如果指定了地区, 找出与locale相匹配的item
      if (supportedLanguageLocaleMap.containsKey(_locale.languageCode)) {
        _selectedItem = elements.firstWhere((e) => e.code.toUpperCase() == _locale.countryCode, orElse: () => null);
        if (_selectedItem != null) return _selectedItem;
      }
    }
    return _getSelectedItemWithDefaultLocale;
  }

  get _getSelectedItemWithDefaultLocale =>
      elements.firstWhere((e) => e.code.toUpperCase() == sysLocaleCountryCode, orElse: () => elements[0]);

  @override
  Widget build(BuildContext context) {
    Widget _widget;

    _widget = FlatButton(
      onPressed: _jumpToListPage,
      highlightColor: Colors.transparent,
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.showCountryAndCode
                      ? selectedItem.toLongString()
                      : (widget.showCountryOnly ? selectedItem.toCountryStringOnly() : selectedItem.toString()),
                  style: widget.textStyle ?? Theme.of(context).textTheme.button,
                  overflow: widget.textOverflow,
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          )
        ],
      ),
    );
    return _widget;
  }

  @override
  void didUpdateWidget(covariant ArisCountrySelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 当 initialSelection 不一致时, 更新selectedItem
    if (oldWidget.initialSelection != widget.initialSelection) {
      selectedItem = elements.firstWhere(
          (e) =>
              e.code.toUpperCase() == widget.initialSelection.toUpperCase() ||
              e.dialCode.toUpperCase() == widget.initialSelection.toUpperCase() ||
              e.name.toUpperCase() == widget.initialSelection.toUpperCase(),
          orElse: _getSelectedItemWithDefaultLocale);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.elements = elements.map((e) => e.localize(context)).toList();
  }

  _jumpToListPage() {
    if (Platform.isIOS) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ArisCountryListPage(
                    widget.listPageTitle,
                    widget.listPageCancelButtonText,
                    selectedItem,
                    elements,
                    favoriteElements,
                    searchHint: widget.listPageSearchHint,
                    appBarTheme: widget.listPageAppBarTheme,
                    textTheme: widget.listPageTextTheme,
                  ))).then((e) => _updateSelectedItem(e));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArisCountryListPage(
                    widget.listPageTitle,
                    widget.listPageCancelButtonText,
                    selectedItem,
                    elements,
                    favoriteElements,
                    searchHint: widget.listPageSearchHint,
                    appBarTheme: widget.listPageAppBarTheme,
                    textTheme: widget.listPageTextTheme,
                  ))).then((e) => _updateSelectedItem(e));
    }
  }

  void _updateSelectedItem(e) {
    if (e != null) {
      setState(() {
        selectedItem = e;
        callbackParams.selectedItem = selectedItem;
        widget.onSelected(callbackParams);
      });
    }
  }
}
