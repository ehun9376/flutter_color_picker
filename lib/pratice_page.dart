import 'dart:async';
import 'dart:math';
import 'package:color_picker/extension.dart';
import 'package:color_picker/helper/snackbar_helper.dart';
import 'package:color_picker/model/app_model.dart';
import 'package:color_picker/setting_page.dart';
import 'package:color_picker/simple_widget/simple_button.dart';
import 'package:color_picker/simple_widget/simple_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonModel {
  Color? backgroundColor;
  bool? isCorrect = false;
  ButtonModel({this.backgroundColor, this.isCorrect});
}

class PraticePageViewmodel extends ChangeNotifier {
  var point = 0;

  List<ButtonModel> buttonModels = [];

  resetAll() {
    point = 0;
  }

  List<ButtonModel> getRandomColorList() {
    Random random = Random();

    int baseRed = random.nextInt(256);
    int baseGreen = random.nextInt(256);
    int baseBlue = random.nextInt(256);

    ButtonModel sameColor = ButtonModel(
        backgroundColor: Color.fromRGBO(baseRed, baseGreen, baseBlue, 1),
        isCorrect: false);

    int offsetRed = baseRed + random.nextInt(20) - 10;
    int offsetGreen = baseGreen + random.nextInt(20) - 10;
    int offsetBlue = baseBlue + random.nextInt(20) - 10;

    ButtonModel color4 = ButtonModel(
        backgroundColor: Color.fromRGBO(offsetRed, offsetGreen, offsetBlue, 1),
        isCorrect: true);
    var list = [sameColor, sameColor, sameColor, color4];
    list.shuffle(random);

    return list;
  }
}

class PraticePage extends StatefulWidget {
  const PraticePage({super.key});

  @override
  State<PraticePage> createState() => _PraticePageState();
}

class _PraticePageState extends State<PraticePage> {
  final PraticePageViewmodel viewModel = PraticePageViewmodel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.buttonModels = viewModel.getRandomColorList();
  }

  @override
  Widget build(BuildContext context) {
    var appModel = context.read<AppModel>();

    var row1 = Selector<PraticePageViewmodel, List<ButtonModel>>(
        builder: (context, value, child) {
          return Wrap(
            children: value.map((e) => createButton(model: e)).toList(),
          );
        },
        selector: (p0, p1) => p1.buttonModels);

    Wrap(
      children: [
        createButton(model: ButtonModel(backgroundColor: Colors.black)),
        createButton(model: ButtonModel(backgroundColor: Colors.blue)),
        createButton(model: ButtonModel(backgroundColor: Colors.blue)),
        createButton(model: ButtonModel(backgroundColor: Colors.blue)),
      ],
    );

    var startButton = SimpleButton(
      buttontitle: "Start",
      fontSize: 20,
      fontWeight: FontWeight.bold,
      buttonAction: () {
        if (appModel.life < 0) {
          //TODO: - < 0
          appModel.saveData(addLife: -1);
          viewModel.resetAll();
        } else {
          showAppSnackBar("沒有訓練次數，請至設定頁購買", context);
        }
      },
    );

    var pointText = SimpleText(
      text: "5/10",
    );

    var questionText = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SimpleText(
          text: "第1題",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          align: TextAlign.left,
        ).padding(),
      ],
    );

    final lostLifeLabel = Selector<AppModel, int>(
        selector: (p0, p1) => p1.life,
        builder: (context, lostLife, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SimpleText(
                text: "剩餘訓練次數：$lostLife次",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                align: TextAlign.left,
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
                questionText,
                row1,
                const SizedBox(
                  height: 50,
                ),
                startButton,
                pointText
              ],
            ).singleChildScrollView()); // replace this with your desired widget
      },
    );
  }

  Widget createButton(
      {required ButtonModel model,
      required Function(bool isCorrect) buttonAction}) {
    // get screen size
    var size = MediaQuery.of(context).size;

    return SimpleButton(
        buttonMiniSize: Size(size.width / 2, size.width / 2),
        backgroundColor: model.backgroundColor,
        buttontitle: "點我",
        buttonAction: () {
          buttonAction(model.isCorrect ?? false);
        });
  }
}
