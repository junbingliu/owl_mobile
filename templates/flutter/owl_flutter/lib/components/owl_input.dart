import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/owl_statefulcomponent.dart';
import '../utils/json_util.dart';
import '../utils/uitools.dart';

class OwlInput extends OwlStatefulComponent {
  OwlInput(
      {Key key,
      node,
      pageCss,
      appCss,
      model,
      componentModel,
      parentNode,
      parentWidget,
      cacheContext})
      : super(
            key: key,
            node: node,
            pageCss: pageCss,
            appCss: appCss,
            model: model,
            componentModel: componentModel,
            parentNode: parentNode,
            parentWidget: parentWidget,
            cacheContext: cacheContext);

  @override
  OwlInputState createState() {
    return new OwlInputState();
  }
}

class OwlInputState extends State<OwlInput> {
  TextEditingController editingController;
  String paddingLeft;
  String paddingRight;
  String paddingTop;
  String paddingBottom;
  String fontSize;
  String color;
  String placeholder;
  bool enabled = true;
  bool obscureText = false;
  TextStyle hintTextStyle = null;

  Color cssColor;

  @override
  void initState() {
    String disabled = getAttr(widget.node, 'disabled');
    placeholder = getAttr(widget.node, 'placeholder');

    if (disabled == 'true') {
      enabled = false;
    }
    List rules = getNodeCssRules(widget.node, widget.pageCss);

    paddingLeft = getRuleValue(rules, "padding-left");
    paddingRight = getRuleValue(rules, "padding-right");
    paddingTop = getRuleValue(rules, "padding-top");
    paddingBottom = getRuleValue(rules, "padding-bottom");
    fontSize = getRuleValue(rules, "font-size");
    color = getRuleValue(rules, 'color');
    cssColor = fromCssColor(color);

    var hintTextColor = getRuleValue(rules, 'hint-text-color');
    if (hintTextStyle != null) {
      hintTextStyle = TextStyle(color: fromCssColor(hintTextColor));
    }

    String type = getAttr(widget.node, 'type');
    if (type != null) {
      type = type.toLowerCase();
      if (type == 'password') {
        obscureText = true;
      }
    }

    ///设置事件处理程序
    String initValue = getAttr(widget.node, 'value');
    String name = getAttr(widget.node, 'name');
    String key = getAttr(widget.node, 'key');
    if (key == null) {
      key = name;
    }
    editingController = new TextEditingController();
    this.editingController.text = widget.renderText(initValue);
    String bindinput = getAttr(widget.node, 'bindinput');
    if (bindinput != null) {
      Function(dynamic) f = widget.model.pageJs[bindinput];
      this.editingController.addListener(() {
        var e = {
          "detail": {"value": editingController.text}
        };
        f(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: this.editingController,
        obscureText: obscureText,
        style: DefaultTextStyle.of(context)
            .style
            .merge(TextStyle(color: cssColor, fontSize: lp(fontSize, null))),
        decoration: InputDecoration(
            border: InputBorder.none,
            enabled: enabled,
            hintText: placeholder,
            hintStyle: hintTextStyle,
            contentPadding: EdgeInsets.only(
                left: lp(paddingLeft, 0.0),
                right: lp(paddingRight, 0.0),
                top: lp(paddingTop, 0.0),
                bottom: lp(paddingBottom, 0.0))));
  }
}
