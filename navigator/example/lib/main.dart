import 'package:flutter/material.dart';
import 'package:navigator/navigator.dart';

final navigationPaths = [
  NamedPath(
    pathName: LaunchScreen.routeName,
    builder: (_, settings) {
      final redirectionPathName = getValueIfTypeMatched<String>(
        settings.arguments,
      );

      return LaunchScreen(
        routePath: redirectionPathName,
        reRoutePath: MyHomePage.routeName,
      );
    },
  ),
  NamedPath(
    pathName: MyHomePage.routeName,
    builder: (_, __) => const MyHomePage(title: 'Flutter Demo Home Page'),
  ),
  NavigationPath(
    matcher: (route) =>
        route?.name?.startsWith('${SomeOtherPage.routeName}/') ?? false,
    builder: (_, settings) {
      return const SomeOtherPage();
    },
  ),
];

final navigator = RouterConfiguration(paths: navigationPaths);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigator.navigatorKey,
      onGenerateRoute: navigator.onGenerateRoute,
      onUnknownRoute: navigator.onUnknownRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const String routeName = '/home';

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SomeOtherPage.routeName + '/WORLD');
          },
          child: const Text('GO SOMEWHERE'),
        ),
      ),
    );
  }
}

class LaunchScreen extends StatefulWidget {
  static const String routeName = '/';

  const LaunchScreen({
    Key? key,
    this.routePath,
    required this.reRoutePath,
  }) : super(key: key);

  final String? routePath;
  final String reRoutePath;

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  void _load() async {
    // ..
    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.of(context).pushNamedAndRemoveUntil(
      widget.routePath ?? widget.reRoutePath,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 150,
        ),
      ),
    );
  }
}

class SomeOtherPage extends StatelessWidget {
  static const String routeName = '/some_other';

  const SomeOtherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)?.settings;
    final name = settings?.name;
    final use = name?.replaceFirst('$routeName/', '') ?? 'World';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Some other page'),
      ),
      body: Center(
        child: Text('HELLO $use'),
      ),
    );
  }
}
