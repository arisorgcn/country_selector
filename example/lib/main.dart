import 'package:country_selector/aris_country_localizations.dart';
import 'package:country_selector/country_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Selector Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        ArisCountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: MyHomePage(title: 'Country Selector Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: ArisCountrySelector(
            listPageTitle: '选择国家和地区',
            listPageCancelButtonText: '取消',
            listPageSearchHint: '搜索',
            onSelected: (params) {
              print(params.toString());
            },
            // initialSelection: '中国',
            favorite: ['CN', '香港', '台湾', '澳门'],
          ),
        ));
  }
}
