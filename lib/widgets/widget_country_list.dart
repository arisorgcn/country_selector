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
/// Country list widget
/// @author Aris Hu created at 2020-12-13
///
class CountryList extends StatefulWidget {
  /// 要显示的列表
  final List<ArisCountryCodeItem> filteredElements;

  final WidgetBuilder emptySearchBuilder;

  final Function onSelected;

  final ScrollController indexScrollController;

  final TextTheme textTheme;

  CountryList(this.filteredElements, this.onSelected, this.indexScrollController,
      {Key key, this.emptySearchBuilder, this.textTheme})
      : super(key: key);

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  @override
  void didUpdateWidget(covariant CountryList oldWidget) {
    return super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filteredElements.isEmpty) {
      return _buildEmptySearchWidget(context);
    }
    return Padding(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        controller: widget.indexScrollController,
        shrinkWrap: false,
        cacheExtent: 48.0,
        clipBehavior: Clip.hardEdge,
        itemBuilder: _buildItem,
        separatorBuilder: _buildSeparator,
        itemCount: widget.filteredElements.length,
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    var currentItem = widget.filteredElements[index];
    // 如果是标记
    if (currentItem.isTag) {
      return Container(
        padding: EdgeInsets.only(left: 14.0),
        // color: Color(0xFFFFFFFF),
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              currentItem.tagName == 'favorite'
                  ? Icon(
                      Icons.star_outline,
                      size: widget.textTheme.button.fontSize ?? 14,
                      color: widget.textTheme.button.color ?? Colors.black87,
                    )
                  : Text(currentItem.tagName,
                      style: TextStyle(
                        color: widget.textTheme.subtitle1.color ?? Colors.black87,
                        fontWeight: widget.textTheme.subtitle1.fontWeight ?? FontWeight.bold,
                        fontSize: widget.textTheme.subtitle1.fontSize ?? 14,
                      )),
            ],
          ),
        ),
      );
    }
    // 不是标记返回分隔符
    return SizedBox.shrink();
  }

  Widget _buildItem(BuildContext context, int index) {
    var currentItem = widget.filteredElements[index];
    if (!currentItem.isTag) {
      return Container(
        padding: EdgeInsets.only(right: 12.0),
        height: 46,
        child: FlatButton(
          onPressed: () => widget.onSelected(currentItem),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                currentItem.name,
                style: TextStyle(
                  color: widget.textTheme.subtitle1.color ?? Colors.black87,
                  fontSize: widget.textTheme.subtitle1.fontSize ?? 14,
                ),
              ),
              Text(
                currentItem.dialCode,
                style: TextStyle(
                  color: widget.textTheme.subtitle2.color ?? Color(0xFF888888),
                  fontSize: widget.textTheme.subtitle2.fontSize ?? 14,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder(context);
    }
    return Center(
      child: Text(
        'No country found',
        style: TextStyle(color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
