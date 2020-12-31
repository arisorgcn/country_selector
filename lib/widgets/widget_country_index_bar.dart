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

  final TextTheme textTheme;

  CountryIndexBar(
    this.indexScrollController,
    this.filteredElements,
    this.countryCode,
    this.alphaList,
    this.filteredIndexedElementsMap, {
    this.indexBarDisabled,
    this.textTheme,
  });

  @override
  _CountryIndexBarState createState() => _CountryIndexBarState(alphaList);
}

class _CountryIndexBarState extends State<CountryIndexBar> {
  List<Widget> alphaItems;

  List<String> alphas;

  _CountryIndexBarState(this.alphas);

  @override
  void initState() {
    super.initState();
    _updateAlphaList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 30.0,
        height: 460,
        child: ListView.builder(
          clipBehavior: Clip.hardEdge,
          physics: NeverScrollableScrollPhysics(),
          itemCount: alphaItems.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Container(
                height: 16,
                child: alphaItems[index],
              ),
              onTap: () {
                if (!widget.indexBarDisabled) {
                  double offset = 30.0 * index;
                  for (int i = 0; i < index; i++) {
                    offset += widget.filteredIndexedElementsMap.entries
                            .firstWhere((e) => e.key.toUpperCase() == alphas[i].toUpperCase())
                            .value
                            .length *
                        46.0;
                  }

                  widget.indexScrollController.jumpTo(offset);
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CountryIndexBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filteredElements.length != widget.filteredElements.length ||
        oldWidget.indexBarDisabled != widget.indexBarDisabled) {
      _updateAlphaItems();
    }
  }

  /// 更新索引列表组件
  void _updateAlphaItems() {
    List<Widget> alphaItems = [];
    alphas.forEach((alpha) {
      if (alpha == 'favorite') {
        alphaItems.add(Center(
          child: Icon(
            Icons.star_outline,
            color: widget.textTheme.caption.color ?? Colors.black87,
            size: widget.textTheme.caption.fontSize ?? 12,
          ),
        ));
      } else {
        alphaItems.add(Center(
          child: Text(
            alpha,
            style: TextStyle(
              color: widget.textTheme.caption.color ?? Colors.black87,
              fontSize: widget.textTheme.caption.fontSize ?? 12,
            ),
          ),
        ));
      }
    });
    setState(() {
      this.alphaItems = alphaItems;
    });
  }

  void _updateAlphaList() {
    alphas.insert(0, 'favorite');
    setState(() {
      _updateAlphaItems();
    });
  }
}
