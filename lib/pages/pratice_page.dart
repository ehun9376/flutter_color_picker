import 'dart:async';
import 'package:color_picker/extension.dart';
import 'package:color_picker/helper/snackbar_helper.dart';
import 'package:color_picker/model/app_model.dart';
import 'package:color_picker/setting_page.dart';
import 'package:color_picker/simple_widget/simple_button.dart';
import 'package:color_picker/simple_widget/simple_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PraticePageViewmodel extends ChangeNotifier {}

class PraticePage extends StatefulWidget {
  const PraticePage({super.key});

  @override
  State<PraticePage> createState() => _PraticePageState();
}

class _PraticePageState extends State<PraticePage> {
  final PraticePageViewmodel viewModel = PraticePageViewmodel();

  @override
  Widget build(BuildContext context) {
    var appModel = context.read<AppModel>();
    final lostLifeLabel = Selector<AppModel, int>(
        selector: (p0, p1) => p1.life,
        builder: (context, lostLife, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SimpleText(
                text: "剩餘訓練次數：$lostLife次",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                align: TextAlign.right,
              ).padding(),
            ],
          );
        });

    return ChangeNotifierProvider<PraticePageViewmodel>.value(
      value: viewModel,
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("顏色敏感度訓練"),
              actions: [
                SimpleButton(
                  buttonIcon: Icons.settings,
                  borderColor: Colors.transparent,
                  iconColor: Colors.black,
                  buttonAction: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ));
                  },
                )
              ],
            ),
            body: Column(
              children: [
                lostLifeLabel,
              ],
            ).singleChildScrollView()); // replace this with your desired widget
      },
    );
  }
}
