import 'package:eve_helper/modules/module_input_slot.dart';
import 'package:eve_helper/modules/module_slot.dart';
import 'package:flutter/widgets.dart';

class ModuleOutputSlot<T> extends ModuleSlot<T> {
  List<ModuleInputSlot<T>> _to = [];

  ModuleOutputSlot({@required String name, @required T value, @required module}) : super(name: name, value: value, module: module);

  @override
  bool connect(ModuleSlot slot) {
    if (slot == null || _to.contains(slot)) return false;
    if (slot.runtimeType != typeOf<ModuleInputSlot<T>>()) return false;
    _to.add(slot);
    slot.connect(this);
    return true;
  }

  @override
  bool disconnect(ModuleSlot slot) {
    if (slot == null || !_to.contains(slot)) return false;
    _to.remove(slot);
    slot.disconnect(this);
    return true;
  }

  @override
  void setValue (T value) {
    super.setValue(value);
    _to.forEach((e) => e.setValue(value));
  }
}