import 'package:eve_helper/modules/module_output_slot.dart';
import 'package:eve_helper/modules/module_slot.dart';
import 'package:flutter/widgets.dart';

class ModuleInputSlot<T> extends ModuleSlot<T> {
  ModuleOutputSlot<T> _source;

  ModuleInputSlot({@required name, @required T value, @required module}) : super(name: name, value: value, module: module);

  @override
  bool connect(ModuleSlot slot) {
    if (slot == null || _source == slot) return false;
    if (slot.runtimeType != typeOf<ModuleOutputSlot<T>>()) return false;
    _source = slot;
    slot.connect(this);
    return true;
  }

  @override
  bool disconnect(ModuleSlot slot) {
    if (slot == null || _source != slot) return false;
    _source = null;
    slot.disconnect(this);
    return true;
  }
}