import 'package:flet/flet.dart';

import 'flet_decimal_input.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "flet_decimal_input":
      return FletDecimalInputControl(
        parent: args.parent,
        control: args.control,
        backend: args.backend
      );
    default:
      return null;
  }
};

void ensureInitialized() {
  // nothing to initialize
}
