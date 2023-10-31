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
  int _thisGameLife = 3;
  int get thisGameLife => _thisGameLife;
  set thisGameLife(int value) {
    _thisGameLife = value;
    notifyListeners();
  }

  int _point = 0;
  int get point => _point;
  set point(int value) {
    _point = value;
    notifyListeners();
  }

  int _question = 1;
  int get question => _question;
  set question(int value) {
    _question = value;
    notifyListeners();
  }

  bool _playing = false;
  bool get playing => _playing;
  set playing(bool value) {
    _playing = value;
    notifyListeners();
  }

  List<ButtonModel> buttonModels = [];

  resetAll() {
    point = 0;
    question = 1;
    playing = false;
    thisGameLife = 3;
    buttonModels = getRandomColorList();
  }

  List<ButtonModel> getRandomColorList() {
    Random random = Random();

    int baseRed = random.nextInt(256);
    int baseGreen = random.nextInt(256);
    int baseBlue = random.nextInt(256);

    ButtonModel sameColor = ButtonModel(
        backgroundColor: Color.fromRGBO(baseRed, baseGreen, baseBlue, 1),
        isCorrect: false);

    int offsetRed = baseRed + random.nextInt(10) - 5;
    int offsetGreen = baseGreen + random.nextInt(10) - 5;
    int offsetBlue = baseBlue + random.nextInt(10) - 10;

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
            children: value
                .map((e) => createButton(
                    model: e,
                    buttonAction: (bool isCorrect) {
                      if (viewModel.playing == false) {
                        showAppSnackBar("請先點擊開始測驗", context);
                        return;
                      }

                      if (isCorrect) {
                        viewModel.question += 1;
                        viewModel.point += 1;
                      } else {
                        viewModel.thisGameLife -= 1;
                        viewModel.question++;
                      }

                      if (viewModel.question >= 10 ||
                          viewModel.thisGameLife <= 0) {
                        showAppSnackBar(
                            "訓練結束 得分是${viewModel.point}/10", context);
                        viewModel.resetAll();
                        return;
                      } else {
                        viewModel.buttonModels = viewModel.getRandomColorList();
                      }
                    }))
                .toList(),
          );
        },
        selector: (p0, p1) => p1.buttonModels);

    var startButton = Selector<PraticePageViewmodel, bool>(
      builder: (context, value, child) {
        return SimpleButton(
          buttontitle: value ? "結束" : "開始測驗",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          buttonAction: () {
            if (viewModel.playing) {
              viewModel.resetAll();
              return;
            }

            if (appModel.life > 0) {
              //TODO: - < 0
              appModel.saveData(addLife: -1);
              viewModel.resetAll();
              viewModel.playing = !viewModel.playing;
            } else {
              showSingelAlert(
                  barrierDismissible: false,
                  context: context,
                  message: "沒有訓練次數，請至設定頁購買",
                  confirmAction: () {
                    //GOTO SettingPage
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ));
                  });
            }
          },
        );
      },
      selector: (p0, p1) => p1.playing,
    );

    var pointText = Selector<PraticePageViewmodel, int>(
      builder: (context, value, child) {
        return SimpleText(
          text: "目前分數：${viewModel.point}",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          align: TextAlign.left,
        ).padding();
      },
      selector: (p0, p1) => p1.point,
    );

    var questionText = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Selector<PraticePageViewmodel, int>(
          builder: (context, value, child) {
            return SimpleText(
              text: "第$value/10題",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              align: TextAlign.left,
            ).padding().flexible();
          },
          selector: (p0, p1) => p1.question,
        ),
        Selector<PraticePageViewmodel, int>(
          builder: (context, value, child) {
            return SimpleText(
              text: "剩餘生命$value/3",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              align: TextAlign.right,
            ).padding().flexible();
          },
          selector: (p0, p1) => p1.thisGameLife,
        ),
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

void showSingelAlert(
    {required BuildContext context,
    String? message,
    String confirmButtonTitle = "確定",
    bool barrierDismissible = true,
    bool pop = true,
    Function()? confirmAction}) {
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: 200,
              maxWidth: MediaQuery.of(context).size.width - 50,
              maxHeight: MediaQuery.of(context).size.width - 50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SimpleText(
                  text: message ?? "",
                  fontSize: 18,
                  textColor: Colors.black,
                ).padding(),
                SimpleButton(
                  buttontitle: confirmButtonTitle,
                  cornerRadius: 15,
                  buttonMiniSize: const Size(130, 45),
                  backgroundColor: Colors.black,
                  titleColor: Colors.white,
                  buttonAction: () {
                    if (pop) {
                      Navigator.of(context).pop();
                    }
                    if (confirmAction != null) {
                      confirmAction();
                    }
                  },
                ).padding()
              ],
            ),
          ).singleChildScrollView(),
        ),
      );
    },
  );
}
