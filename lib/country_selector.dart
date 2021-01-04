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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'aris_country_code_item.dart';
import 'aris_country_list_page.dart';
import 'aris_country_params.dart';
import 'constants/country_codes.dart';

///
/// main widget
/// @author Aris Hu created at 2020-12-14
///
class ArisCountrySelector extends StatefulWidget {
  /// the title of the list page
  final String listPageTitle;

  /// use center title
  final bool titleCentered;

  /// the text of cancel page in list page
  final String listPageCancelButtonText;

  /// the hint text of search
  final String listPageSearchHint;

  /// appbar theme of list page
  final AppBarTheme listPageAppBarTheme;

  /// text theme of list page
  final TextTheme listPageTextTheme;

  /// index bar theme
  final TextTheme listPageIndexBarTheme;

  /// theme of list page body
  final Color listBodyBackground;

  /// the button text style
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
    this.titleCentered = true,
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
    @required final AppBarTheme listPageAppBarTheme,
    @required final TextTheme listPageTextTheme,
    @required final TextTheme listPageIndexBarTheme,
    this.listBodyBackground = Colors.white,
  })  : this.listPageAppBarTheme = AppBarTheme(
          brightness: listPageAppBarTheme.brightness ?? Brightness.dark,
          color: listPageAppBarTheme.color ?? Colors.blue,
          iconTheme: listPageAppBarTheme.iconTheme != null
              ? listPageAppBarTheme.iconTheme.copyWith(
                  color: listPageAppBarTheme.iconTheme.color ?? Colors.black87,
                  size: listPageAppBarTheme.iconTheme.size ?? 20,
                )
              : IconThemeData(color: Colors.black87, size: 20),
          actionsIconTheme: listPageAppBarTheme.actionsIconTheme ?? IconThemeData(color: Colors.black87, size: 20),
          textTheme: listPageAppBarTheme.textTheme != null
              ? listPageAppBarTheme.textTheme.copyWith(
                  headline5: listPageAppBarTheme.textTheme.headline5 != null
                      ? listPageAppBarTheme.textTheme.headline5.copyWith(
                          color: listPageAppBarTheme.textTheme.headline5.color ?? Colors.black87,
                          fontSize: listPageAppBarTheme.textTheme.headline5.fontSize ?? 16,
                          fontWeight: listPageAppBarTheme.textTheme.headline5.fontWeight ?? FontWeight.bold,
                        )
                      : TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                  headline6: listPageAppBarTheme.textTheme.headline6 != null
                      ? listPageAppBarTheme.textTheme.headline6.copyWith(
                          color: listPageAppBarTheme.textTheme.headline6.color ?? Colors.black87,
                          fontSize: listPageAppBarTheme.textTheme.headline6.fontSize ?? 14,
                          fontWeight: listPageAppBarTheme.textTheme.headline6.fontWeight ?? FontWeight.bold,
                        )
                      : TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                  button: listPageAppBarTheme.textTheme.button != null
                      ? listPageAppBarTheme.textTheme.button.copyWith(
                          color: listPageAppBarTheme.textTheme.button.color ?? Colors.black87,
                          fontSize: listPageAppBarTheme.textTheme.button.fontSize ?? 14,
                          fontWeight: listPageAppBarTheme.textTheme.button.fontWeight ?? FontWeight.bold,
                        )
                      : TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                )
              : TextTheme(
                  headline5: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
                  headline6: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                  button: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                ),
        ),
        this.listPageTextTheme = TextTheme(
          // country text style
          subtitle1: listPageTextTheme.subtitle1 != null
              ? listPageTextTheme.subtitle1.copyWith(
                  color: listPageTextTheme.subtitle1.color ?? Colors.black87,
                  fontSize: listPageTextTheme.subtitle1.fontSize ?? 16,
                  fontWeight: listPageTextTheme.subtitle1.fontWeight ?? FontWeight.normal,
                )
              : TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
          // index tag style
          button: listPageTextTheme.button != null
              ? listPageTextTheme.button.copyWith(
                  color: listPageTextTheme.button.color ?? Colors.black87,
                  fontSize: listPageTextTheme.button.fontSize ?? 16,
                  fontWeight: listPageTextTheme.button.fontWeight ?? FontWeight.bold,
                )
              : TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          // right dial code style
          subtitle2: listPageIndexBarTheme.subtitle2 != null
              ? listPageIndexBarTheme.subtitle2.copyWith(
                  color: listPageTextTheme.subtitle2.color ?? Color(0xFF888888),
                  fontSize: listPageTextTheme.subtitle2.fontSize ?? 12,
                  fontWeight: listPageTextTheme.subtitle2.fontWeight ?? FontWeight.normal,
                )
              : TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
        ),
        this.listPageIndexBarTheme = TextTheme(
          // long press background color
          headline6: TextStyle(
            color: listPageAppBarTheme.color ?? Colors.blue,
          ),

          // button style
          button: listPageIndexBarTheme?.button != null
              ? listPageIndexBarTheme.button.copyWith(
                  fontSize: listPageIndexBarTheme.button.fontSize ?? 12,
                  color: listPageIndexBarTheme.button.color ?? Colors.black87,
                  fontWeight: listPageIndexBarTheme.button.fontWeight ?? FontWeight.normal,
                )
              : TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
        ),
        super(key: key);

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
  String sysLocaleCountryCode;

  _ArisCountrySelectorState(this.elements);

  @override
  void initState() {
    super.initState();
    sysLocaleCountryCode =
        Platform.localeName.substring(Platform.localeName.lastIndexOf(RegExp('_')) + 1).toUpperCase();
    print("sysLocaleCountryCode: $sysLocaleCountryCode");

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
                    e.dialCode.substring(1) == f.toUpperCase() ||
                    e.name.toUpperCase() == f.toUpperCase(),
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

    // when initialized, should fire this event to the user
    // https://github.com/arisorgcn/country_selector/issues/1
    widget.onSelected(ArisCountryParams(selectedItem: selectedItem));
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
      elements.firstWhere((e) => e.code.toUpperCase().startsWith(sysLocaleCountryCode), orElse: () => elements[0]);

  @override
  Widget build(BuildContext context) {
    Widget _widget;

    _widget = FlatButton(
      onPressed: _jumpToListPage,
      highlightColor: Colors.transparent,
      padding: widget.padding,
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
                // Icon(Icons.arrow_drop_down),
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
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: ArisCountryListPage(
              widget.listPageTitle,
              widget.listPageCancelButtonText,
              selectedItem,
              elements,
              favoriteElements,
              searchHint: widget.listPageSearchHint,
              bodyBackgroundColor: widget.listBodyBackground,
              appBarTheme: widget.listPageAppBarTheme,
              textTheme: widget.listPageTextTheme,
              indexBarTheme: widget.listPageIndexBarTheme,
            ))).then(
      (e) => _updateSelectedItem(e),
    );
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
