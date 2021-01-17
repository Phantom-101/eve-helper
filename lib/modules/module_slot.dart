import 'package:eve_helper/modules/module.dart';
import 'package:flutter/widgets.dart';

class ModuleSlot<T> {
  String name;
  @protected ValueNotifier<T> vn;
  @protected Module module;

  ModuleSlot({@required this.name, @required T value, @required this.module}) {
    vn = ValueNotifier<T>(value);
  }

  bool connect(ModuleSlot slot) {
    return false;
  }

  bool disconnect (ModuleSlot slot) {
    return false;
  }

  T getValue () {
    return vn.value;
  }

  ValueNotifier<T> getVN () {
    return vn;
  }

  void setValue(T value) {
    vn.value = value;
  }

  Type typeOf<T>() => T;
}