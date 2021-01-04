import 'package:country_selector/aris_country_localizations.dart';
import 'package:country_selector/constants/country_codes.dart';
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
      locale: defaultLocale,
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
            listPageTitle: 'Select Country and Region',
            listPageCancelButtonText: 'Cancel',
            listPageSearchHint: 'Search',
            initialSelection: 'US',
            listPageAppBarTheme: AppBarTheme(
                color: Colors.blue,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                textTheme: TextTheme(
                    headline5: TextStyle(
                      color: Colors.white,
                    ),
                    headline6: TextStyle(
                      color: Colors.white,
                    ),
                    button: TextStyle(
                      color: Colors.white,
                    ))),
            listPageTextTheme: TextTheme(),
            listPageIndexBarTheme: TextTheme(),
            onSelected: (params) {
              print(params.toString());
              // if you want to assign it to other variable, wrap it in below code
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   setState(() {
              //     this.variable = params;
              //   });
              // });
            },
            // use country short code or dial code
            favorite: ['86', 'HK', 'MO', 'TW'],
          ),
        ));
  }
}
