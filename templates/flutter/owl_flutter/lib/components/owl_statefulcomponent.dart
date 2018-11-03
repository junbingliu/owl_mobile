import 'package:flutter/material.dart';
import 'package:reflected_mustache/mustache.dart';

import '../model/ScreenModel.dart';

abstract class OwlStatefulComponent extends StatefulWidget {
  OwlStatefulComponent(
      {Key key,
      this.node,
      this.pageCss,
      this.appCss,
      this.pageJson,
      this.model,
      this.componentModel,
      this.parentNode,
      this.parentWidget,
      this.cacheContext})
      : super(key: key);

  final Map<String, dynamic> node;
  final Map<String, dynamic> pageCss;
  final Map<String, dynamic> appCss;
  final Map<String, dynamic> pageJson;
  final ScreenModel model;
  final Map componentModel;

  final Map<String, dynamic> parentNode;
  final Widget parentWidget;
  Map<dynamic, List<Widget>> cacheContext;

  String renderText(String text, {bool escape = false}) {
    if (text == null) {
      return null;
    }
    if (!escape) {
      text = "{" + text + "}";
    }
    Template template = new Template(text);
    if (componentModel != null) {
      if (componentModel['includedScreenModel'] == true) {
        //do nothing
      } else {
        var screenModel = model.pageJs['data'];
        screenModel.forEach((k, v) {
          if (!componentModel.containsKey(k)) {
            componentModel[k] = v;
          }
        });
        componentModel['includedScreenModel'] = true;
      }
      return template.renderString(componentModel);
    } else {
      var pageJs = model.pageJs;
      return template.renderString(pageJs['data']);
    }
  }
}
