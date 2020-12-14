# country_selector

A flutter package for country and code selection

You can use this widget to get region code and this widget allows you to filter
the country code items by app bar search bar or the right side index bar.
Currently, this package only support language as flollows:
    Locale('zh', 'CN'),     // Chinese Simplified
    Locale('en'),           // English
    Locale('es'),           // Spain
    Locale('ko'),           // Korea

## Preview

![preview](/assets/images/country_selector_1.gif)


## Guide

### Step1

add **supportedLocales** and **ArisCountryLocalizations.delegate** to localizationsDelegates config

```dart
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
```

### Step 2 Use the widget

```dart

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
            listPageTitle: 'Country/Region',
            listPageCancelButtonText: 'Cancel',
            listPageSearchHint: 'Search',
            onSelected: (params) {
              print(params.toString());
            },
            // initialSelection: '中国',
            favorite: ['China', 'HongKong', 'Taiwan', 'MapCao'],
          ),
        ));
  }
}