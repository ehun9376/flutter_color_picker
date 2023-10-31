import 'package:color_picker/model/app_model.dart';
import 'package:color_picker/pratice_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  var appModel = AppModel();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider<AppModel>.value(
    value: appModel,
    builder: (context, child) {
      return const MyApp();
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appModel = context.read<AppModel>();
    appModel.getData();
    appModel.saveData();
    return const PraticePage();
  }
}
