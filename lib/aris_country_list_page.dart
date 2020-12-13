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
import 'package:country_selector/constants/country_codes.dart';
import 'package:country_selector/widgets/widget_country_index_bar.dart';
import 'package:country_selector/widgets/widget_country_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

import 'aris_country_code_item.dart';

///
/// Country列表展示页
/// @author Aris Hu created at 2020-12-12
///
class ArisCountryListPage extends StatefulWidget {
  /// the appbar title
  final String navTitle;

  /// search bar cancel button text
  final String cancelButtonText;

  /// the hint of the search bar
  final String searchHint;

  /// the initialized item
  final ArisCountryCodeItem initialSelectedItem;

  /// all the country elements
  final List<ArisCountryCodeItem> elements;

  /// elements passed as favorite
  final List<ArisCountryCodeItem> favoriteElements;

  final Size size;

  /// style of search
  final TextStyle searchStyle;

  /// style of search hint text
  final TextStyle hintStyle;

  ArisCountryListPage(
    this.navTitle,
    this.cancelButtonText,
    this.initialSelectedItem,
    this.elements,
    this.favoriteElements, {
    Key key,
    this.size,
    this.searchStyle,
    this.hintStyle,
    this.searchHint = '',
  }) : super(key: key);

  @override
  _ArisCountryListPageState createState() => _ArisCountryListPageState();
}

class _ArisCountryListPageState extends State<ArisCountryListPage> {
  /// the handled source elements
  List<ArisCountryCodeItem> handledElements;

  /// the handled favorite elements
  List<ArisCountryCodeItem> handledFavoriteElements;

  /// alpha-items map
  Map<String, List<ArisCountryCodeItem>> filteredIndexedElementsMap;

  List<String> alphaList;

  /// this is useful for filtering purpose
  List<ArisCountryCodeItem> filteredElements;

  /// relative with search text field
  final FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  bool showSearch = false;

  /// get country code of initial selected item
  get countryCode => widget.initialSelectedItem.code;

  /// scroll controller for list view
  final ScrollController indexScrollController = ScrollController();

  bool disableIndexBar = false;

  @override
  void initState() {
    super.initState();
    handledElements = _initItemsList();
    handledFavoriteElements = _initFavoriteItemsList();
    _filterElements('');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ArisCountryListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _filterElements('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
      backgroundColor: Color(0xFFDDDDDD),
    );
  }

  Widget get _buildBody {
    return GestureDetector(
      onTap: _hideKeyboard,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: widget.size?.width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.symmetric(), borderRadius: BorderRadius.zero),
          child: _buildStack,
        ),
      ),
    );
  }

  Widget get _buildStack {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CountryList(filteredElements, _selectItem, indexScrollController),
        Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CountryIndexBar(
                indexScrollController,
                filteredElements,
                countryCode,
                alphaList,
                filteredIndexedElementsMap,
                indexBarDisabled: disableIndexBar,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildAppBar {
    return AppBar(
      leading: _buildLeading,
      automaticallyImplyLeading: false,
      title: _buildNavTitle,
      titleSpacing: 0.0,
      backgroundColor: Color(0xFFDDDDDD),
    );
  }

  /// 构建标题栏组件
  Widget get _buildNavTitle {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: showSearch ? _showSearch() : _showTitle(),
    );
  }

  /// 构建标题栏左边按钮部分
  Widget get _buildLeading {
    return !showSearch
        ? FlatButton(
            child: Icon(
              Icons.arrow_back_ios_outlined,
              size: 22.0,
              color: Colors.black87,
            ),
            onPressed: () => _selectItem(null),
          )
        : null;
  }

  Widget _showTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          widget.navTitle,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              showSearch = true;
              disableIndexBar = true;
              indexScrollController.jumpTo(0.0);
            });
          },
          child: Icon(Icons.search_outlined, size: 24, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _showSearch() {
    return GestureDetector(
      onTap: _hideKeyboard,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildConstrainedTextField,
              _buildSearchCancelButton,
            ],
          ),
        ),
      ),
    );
  }

  SizedBox get _buildSearchCancelButton {
    return SizedBox(
      width: 60,
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            showSearch = false;
            disableIndexBar = false;
          });
        },
        child: (widget.cancelButtonText == null || widget.cancelButtonText.isEmpty)
            ? Icon(
                Icons.rotate_left_outlined,
                size: 24,
                color: Colors.black87,
              )
            : Text(
                widget.cancelButtonText,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  ConstrainedBox get _buildConstrainedTextField {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 320,
        maxHeight: 38,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          shape: BoxShape.rectangle,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: TextField(
          focusNode: _textFieldFocusNode,
          autofocus: true,
          controller: _textEditingController,
          style: widget.searchStyle ??
              TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
          decoration: InputDecoration(
            hintText: widget.searchHint,
            hintStyle: widget.hintStyle,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
              size: 20,
            ),
            suffixIcon: _textEditingController.text.isNotEmpty
                ? InkWell(
                    onTap: () {
                      _textEditingController.clear();
                      _filterElements('');
                    },
                    child: Icon(
                      Icons.cancel_sharp,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(right: 12.0),
            focusColor: Color(0xFFF2F2F2),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),

          // 文本框内容变化
          onChanged: _filterElements,
        ),
      ),
    );
  }

  List<ArisCountryCodeItem> _initItemsList() {
    List<ArisCountryCodeItem> items = widget.elements;
    if (items.isEmpty) {
      return [];
    }
    List<ArisCountryCodeItem> _handledItems = [];
    List<String> alphaList;
    if (countryCode == localeChina.countryCode) {
      items.forEach((e) {
        e.namePinyin = PinyinHelper.getPinyin(e.name);
      });

      alphaList = _getSortedAlphaList(items);

      alphaList.forEach((alpha) {
        _handledItems.add(ArisCountryCodeItem(
          isTag: true,
          tagName: alpha,
          name: alpha,
          namePinyin: alpha,
        ));
        _handledItems.addAll(items.where((e) => e.namePinyin.characters.first.toUpperCase() == alpha));
      });
    } else {
      alphaList = _getSortedAlphaList(items);
      alphaList.forEach((alpha) {
        _handledItems.add(ArisCountryCodeItem(
          isTag: true,
          tagName: alpha,
          name: alpha,
          namePinyin: alpha,
        ));
        _handledItems.addAll(items.where((e) => e.name.characters.first.toUpperCase() == alpha));
      });
    }

    this.alphaList = alphaList;

    return List.unmodifiable(_handledItems);
  }

  List<String> _getSortedAlphaList(List<ArisCountryCodeItem> items) {
    List<String> sortedAlphaList = [];
    // 提取出名称的首字母列表
    Set<String> alphasSet = {};
    items.map((e) {
      if (countryCode == localeChina.countryCode) {
        return e.namePinyin.characters.first.toUpperCase();
      } else {
        return e.code.characters.first.toUpperCase();
      }
    }).forEach((e) {
      if (!alphasSet.contains(e)) {
        alphasSet.add(e);
      }
    });
    sortedAlphaList = List.from(alphasSet);
    sortedAlphaList.sort((a, b) => a.toString().compareTo(b.toString()));
    return sortedAlphaList;
  }

  /// 初始化热门城市
  List<ArisCountryCodeItem> _initFavoriteItemsList() {
    List<ArisCountryCodeItem> _favoriteItems = [];
    // 将热门地区添加进去
    if (widget.favoriteElements.isNotEmpty) {
      _favoriteItems
          .add(ArisCountryCodeItem(isTag: true, tagName: 'favorite', name: 'favorite', namePinyin: 'favorite'));
      _favoriteItems.addAll(widget.favoriteElements.map((e) {
        if (countryCode == localeChina.countryCode) {
          e.namePinyin = PinyinHelper.getShortPinyin(e.name);
        }
        return e;
      }).toList());
    }
    return _favoriteItems;
  }

  /// 设置选中的Item
  void _selectItem(ArisCountryCodeItem e) {
    Navigator.pop(context, e);
  }

  /// 重置搜索
  List<ArisCountryCodeItem> _resetFilter() {
    List<ArisCountryCodeItem> _filteredElements = [];
    _filteredElements.addAll(handledFavoriteElements);
    _filteredElements.addAll(handledElements);
    return _filteredElements;
  }

  /// 过滤
  void _filterElements(String s) {
    s = s.toUpperCase();

    List<ArisCountryCodeItem> filteredElements = [];
    if (s == null || s.isEmpty) {
      filteredElements = _resetFilter();
    } else {
      if (countryCode == localeChina.countryCode) {
        filteredElements = handledElements.where((e) {
          if (e.isTag) {
            if (e.tagName == 'favorite') {
              return true;
            }
            return e.tagName.toUpperCase() == s.characters.first.toUpperCase();
          }

          // print(e.toLongString());
          return e.name.toUpperCase().contains(s) || e.namePinyin.toUpperCase().contains(s);
        }).toList();
      } else {
        filteredElements = handledElements.where((e) {
          if (e.isTag) {
            return e.tagName.toUpperCase().contains(s);
          }
          return e.code.toUpperCase().contains(s) || e.dialCode.contains(s) || e.name.toUpperCase().contains(s);
        }).toList();
      }
    }

    setState(() {
      this.filteredIndexedElementsMap = _filteredIndexedElementsMap(filteredElements);
      this.filteredElements = filteredElements;
    });
  }

  Map<String, List<ArisCountryCodeItem>> _filteredIndexedElementsMap(List<ArisCountryCodeItem> filteredElements) {
    Map<String, List<ArisCountryCodeItem>> _indexedElementsMap = {};
    filteredElements.forEach((e) {
      String alpha;

      if (countryCode == localeChina.countryCode) {
        if (!e.isTag) {
          alpha = e.namePinyin.characters.first.toUpperCase();
          if (!_indexedElementsMap.containsKey(alpha)) {
            _indexedElementsMap.update(alpha, (list) {
              list.add(e);
              return list;
            }, ifAbsent: () => []);
          } else {
            _indexedElementsMap.update(alpha, (list) {
              list.add(e);
              return list;
            });
          }
        } else {
          if (e.tagName != 'favorite') {
            _indexedElementsMap.update(e.tagName, (list) {
              list.add(e);
              return list;
            }, ifAbsent: () => []);
          } else {
            _indexedElementsMap.putIfAbsent(
                e.tagName, () => widget.favoriteElements.where((f) => f.tagName == null).toList());
          }
        }
      } else {
        if (!e.isTag) {
          alpha = e.code.characters.first.toUpperCase();
          if (!_indexedElementsMap.containsKey(alpha)) {
            _indexedElementsMap.update(alpha, (list) {
              list.add(e);
              return list;
            }, ifAbsent: () => []);
          } else {
            _indexedElementsMap.update(alpha, (list) {
              list.add(e);
              return list;
            });
          }
        } else {
          if (e.tagName != 'favorite') {
            _indexedElementsMap.update(e.tagName, (list) {
              list.add(e);
              return list;
            }, ifAbsent: () => []);
          } else {
            _indexedElementsMap.putIfAbsent(
                e.tagName, () => widget.favoriteElements.where((f) => f.tagName == null).toList());
          }
        }
      }
    });
    return _indexedElementsMap;
  }

  /// hide keyboard
  _hideKeyboard() {
    _textFieldFocusNode.unfocus();
  }
}