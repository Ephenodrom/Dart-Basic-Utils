import 'package:flutter/widgets.dart';

extension ResponsiveOnWidget on Widget {
  /// Wrap `this` with `Padding` Widget with `EdgeInsets.all()` attribute.
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  /// Wrap `this` with `Padding` Widget with `EdgeInsets.symmetric()` attribute.
  /// By default, both `horizontal` and `vertical` properties has `0` as value.
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  /// Wrap `this` with `Padding` Widget with `EdgeInsets.only()` attribute.
  /// By default, all properties has `0` as value: `top`, `bottom`, `left` and `right`.
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  /// Wrap `this` with `Padding` Widget with `EdgeInsets.zero` attribute.
  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);

  /// Wrap `this` with `Container` Widget and sets `margin` with `EdgeInsets.all()`.
  Widget marginAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  /// Wrap `this` with `Container` Widget and sets `margin` with `EdgeInsets.symmetric()`.
  /// By default, both `horizontal` and `vertical` properties has `0` as value.
  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
          margin:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  /// Wrap `this` with `Container` Widget and sets `margin` with `EdgeInsets.only()`.
  /// By default, all properties has `0` as value: `top`, `bottom`, `left` and `right`.
  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
          margin: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  /// Wrap `this` with `Container` Widget and sets `margin` with `EdgeInsets.zero`.
  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);

  /// Wrap `this` with `Visibility` Widget.
  Widget visibility(bool visible) => Visibility(visible: visible, child: this);

  /// This wrap a `Widget` with `Flexible`. It receives as parameters:
  /// `int flex` and `FlexFit fit`. By default, the values are:
  /// `flex = 1`;
  /// `fit = FlexFit.loose`;
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, child: this, fit: fit);

  /// This wrap a `Widget` with `Expanded`. It receives as parameter only `int flex`.
  /// By default, `flex = 1`;
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);
}
