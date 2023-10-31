import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension Styles on Widget {
  Widget buildBorderAround({required BuildContext context}) {
    return sizedBox(
      height: 120,
    )
        .container(
            decoration: BoxDecoration(
                border: Border.all(
          width: 1,
          color: Theme.of(context).dividerColor,
        )))
        .padding(const EdgeInsets.symmetric(horizontal: 20));
  }

  SizedBox sizedBox({double? width, double? height}) {
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget card() {
    return Card(
      child: this,
    );
  }

  Widget center() {
    return Center(child: this);
  }

  Widget padding([EdgeInsets defaultValue = const EdgeInsets.all(20)]) {
    return Padding(
      padding: defaultValue,
      child: this,
    );
  }

  Flexible flexible([int defaultValue = 1, FlexFit fit = FlexFit.tight]) {
    return Flexible(
      flex: defaultValue,
      fit: fit,
      child: this,
    );
  }

  Widget container({
    Color? color,
    BoxConstraints? constraints,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding,
      decoration: decoration,
      color: color,
      constraints: constraints,
      child: this,
    );
  }

  Widget singleChildScrollView() {
    return SingleChildScrollView(
      child: this,
    );
  }
}

extension Layouts on List<Widget> {
  Widget column([
    MainAxisAlignment mainDefault = MainAxisAlignment.center,
    CrossAxisAlignment crossDefault = CrossAxisAlignment.center,
  ]) {
    return Column(
      mainAxisAlignment: mainDefault,
      crossAxisAlignment: crossDefault,
      children: this,
    );
  }

  Row row([MainAxisAlignment defaultValue = MainAxisAlignment.center]) {
    return Row(
      mainAxisAlignment: defaultValue,
      children: this,
    );
  }

  Widget listView({
    Axis scrollDirection = Axis.vertical,
  }) {
    return ListView(
      scrollDirection: scrollDirection,
      children: this,
    );
  }

  Widget stack({
    AlignmentDirectional alignment = AlignmentDirectional.topEnd,
  }) {
    return Stack(
      alignment: alignment,
      children: this,
    );
  }
}

extension Actions on Widget {
  Widget notificationListener<T extends Notification>({
    bool Function(T)? onNotification,
  }) {
    return NotificationListener<T>(
      onNotification: onNotification,
      child: this,
    );
  }

  InkWell inkWell({GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: this,
    );
  }
}

extension NumberExtension on int {
  bool andOperation(int otherNumber) {
    return this & otherNumber > 0;
  }
}
