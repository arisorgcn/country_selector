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

import '../aris_country_code_item.dart';

///
/// 索引组件
/// @author Aris Hu created at 2020-12-13
///
class CountryIndexBar extends StatefulWidget {
  final List<ArisCountryCodeItem> filteredElements;

  final ScrollController indexScrollController;

  final List<String> alphaList;

  final Map<String, List<ArisCountryCodeItem>> filteredIndexedElementsMap;

  final String countryCode;

  /// whether or not index bar should be disabled
  final bool indexBarDisabled;

  /// text theme
  final TextTheme indexBarTheme;

  CountryIndexBar(
    this.indexScrollController,
    this.filteredElements,
    this.countryCode,
    this.alphaList,
    this.filteredIndexedElementsMap, {
    this.indexBarDisabled,
    this.indexBarTheme,
  });

  @override
  _CountryIndexBarState createState() => _CountryIndexBarState(alphaList);
}

class _CountryIndexBarState extends State<CountryIndexBar> {
  List<String> alphas;

  _CountryIndexBarState(this.alphas);

  int selectedIndex = -1;
  int longPressedIndex = -1;

  @override
  void initState() {
    super.initState();
    _updateAlphaList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 18.0,
        height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top * 2),
        child: ListView.builder(
          clipBehavior: Clip.hardEdge,
          physics: NeverScrollableScrollPhysics(),
          itemCount: alphas.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: () {
                setState(() {
                  this.selectedIndex = index;
                  this.longPressedIndex = index;
                });
              },
              onLongPressEnd: (e) {
                setState(() {
                  this.longPressedIndex = -1;
                });
              },
              child: Container(
                height: 18,
                decoration: longPressedIndex == index
                    ? BoxDecoration(
                        color: widget.indexBarTheme.headline6.color,
                        borderRadius: BorderRadius.circular(60.0),
                        border: Border(),
                      )
                    : null,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: InkWell(
                      focusColor: selectedIndex != index ? Colors.transparent : widget.indexBarTheme.headline6.color,
                      splashColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(60.0),
                      onTap: () {
                        setState(() {
                          this.selectedIndex = index;
                        });

                        if (!widget.indexBarDisabled) {
                          double offset = 30.0 * index;
                          for (int i = 0; i < index; i++) {
                            offset += widget.filteredIndexedElementsMap.entries
                                    .lastWhere((e) => e.key.toUpperCase() == alphas[i].toUpperCase())
                                    .value
                                    .length *
                                44.0;
                          }

                          widget.indexScrollController.jumpTo(offset);
                        }
                      },
                      child: alphas[index] == 'favorite'
                          ? Icon(Icons.star_outline,
                              color: selectedIndex != index
                                  ? widget.indexBarTheme.button.color
                                  : (longPressedIndex == index ? Colors.white : widget.indexBarTheme.headline6.color),
                              size: widget.indexBarTheme.button.fontSize)
                          : Text(
                              alphas[index],
                              style: TextStyle(
                                  color: selectedIndex != index
                                      ? widget.indexBarTheme.button.color
                                      : (longPressedIndex == index
                                          ? Colors.white
                                          : widget.indexBarTheme.headline6.color),
                                  fontSize: widget.indexBarTheme.button.fontSize,
                                  fontWeight: selectedIndex != index ? FontWeight.normal : FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateAlphaList() {
    alphas.insert(0, 'favorite');
  }
}
