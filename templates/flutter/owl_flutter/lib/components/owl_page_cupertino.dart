import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../builders/owl_component_builder.dart';
import '../components/owl_componet.dart';
import '../owl_generated/owl_app.dart';
import '../utils/owl.dart';

class OwlPageCupertino extends OwlComponent {
  OwlPageCupertino(
      {Key key,
      node,
      pageCss,
      appCss,
      pageJson,
      model,
      componentModel,
      parentNode,
      parentWidget,
      this.bottomBar,
      cacheContext})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            pageJson: pageJson,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);

  final Widget bottomBar;

  CupertinoNavigationBar buildAppBar(BuildContext context) {
    OwlApp app = Owl.getApplication();
    String title = null;

    if (pageJson != null) {
      title = pageJson['navigationBarTitleText'];
    }

    if (title == null) {
      if (app.appJson['window'] != null &&
          app.appJson['window']['navigationBarTitleText'] != null) {
        title = app.appJson['window']['navigationBarTitleText'];
      }
    }
    if (title == null) {
      title = 'owlmobile';
    }
    String backgroundColor;
    if (app.appJson['window'] != null) {
      backgroundColor = app.appJson['window']['navigationBarBackgroundColor'];
    }
    if (pageJson['navigationBarBackgroundColor'] != null) {
      backgroundColor = pageJson['navigationBarBackgroundColor'];
    }

    String navigationBarTextStyle =
        app.appJson['window']['navigationBarTextStyle'];
    if (pageJson['navigationBarTextStyle'] != null) {
      navigationBarTextStyle = pageJson['navigationBarTextStyle'];
    }

    Color titleColor = fromCssColor("#000000");
    if (navigationBarTextStyle == 'white') {
      titleColor = fromCssColor("#ffffff");
    }

    return CupertinoNavigationBar(
        leading: CupertinoButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: new Text(title,
            style: TextStyle(
                color: titleColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        backgroundColor: fromCssColor(backgroundColor));
  }

  Widget buildBody() {
    var children = node['view']['children'];

    var fixednodes = [];
    var nonFixedNodes = [];
    for (var i = 0; i < children.length; i++) {
      Map<String, dynamic> child = children[i];
      var nodeName = child.keys.first;

      var position = getRuleValueEx(child[nodeName]['rules'], 'position');

      if (position == 'fixed') {
        fixednodes.add(child);
      } else {
        nonFixedNodes.add(child);
      }
    }
    if (fixednodes.length == 0) {
//      print('fixednodes.lengt=0');
      return ListView(
          children: OwlComponentBuilder.buildList(
              node: node,
              pageCss: pageCss,
              appCss: appCss,
              model: model,
              componentModel: componentModel,
              parentNode: node,
              parentWidget: this,
              cacheContext: cacheContext));
    } else {
//      print('fixednodes.lengt!=0');
      List<Widget> childWidgets = [];
      List<Widget> fixedWidgets = [];
      for (var i = 0; i < nonFixedNodes.length; i++) {
        var childNode = nonFixedNodes[i];
        childWidgets.addAll(OwlComponentBuilder.buildList(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: node,
            parentWidget: this,
            cacheContext: cacheContext));
      }

      for (var i = 0; i < fixednodes.length; i++) {
        var childNode = fixednodes[i];
        fixedWidgets.addAll(OwlComponentBuilder.buildList(
            node: childNode,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: node,
            parentWidget: this,
            cacheContext: cacheContext));
      }

      List<Widget> stackChildren = [ListView(children: childWidgets)];
      stackChildren.addAll(fixedWidgets);
      return Stack(children: stackChildren);
    }
  }

  Future<void> _refresh() {
    var onPullDownRefresh = model.pageJs['onPullDownRefresh'];
    if (onPullDownRefresh != null) {
      return Future(onPullDownRefresh);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
        navigationBar: buildAppBar(context),
        child: RefreshIndicator(onRefresh: _refresh, child: buildBody()),
        backgroundColor: Color(0xffffffff));
  }
}
