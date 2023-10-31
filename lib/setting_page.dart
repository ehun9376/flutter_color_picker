import 'package:color_picker/extension.dart';
import 'package:color_picker/helper/snackbar_helper.dart';
import 'package:color_picker/model/app_model.dart';
import 'package:color_picker/simple_widget/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appModel = context.read<AppModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("設定"),
      ),
      body: Selector<AppModel, List<DataModel>>(
          selector: (p0, p1) => p1.dataModels,
          builder: (context, list, child) {
            List<DataModel> copyList = List.from(list);
            return ListView.builder(
              itemCount: copyList.length,
              itemBuilder: (BuildContext context, int index) {
                return createRow(copyList[index], () {
                  if (appModel.iapCenter?.buy(copyList[index].id) ?? false) {
                    showAppSnackBar("購買處理中", context);
                  } else {
                    showAppSnackBar("取得產品資料錯誤", context);
                  }
                });
              },
            );
          }),
    );
  }

  Widget createRow(DataModel model, Function buttonAction) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SimpleButton(
              buttontitle: "購買 ${model.title}",
              fontSize: 20,
              buttonIcon: Icons.shopping_cart,
              iconSize: 30,
              segmented: Segmented.leftToRight,
              imageTextSpace: 20,
              buttonAction: () {
                //TODO: - IAP
                buttonAction();
              },
            ),
          ],
        ),
        Container(
          color: Colors.grey[500],
          height: 2,
        )
      ],
    ).padding();
  }
}
