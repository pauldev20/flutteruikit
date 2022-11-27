//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutteruikit/flutteruikit_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutteruikit_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutteruikitPlugin");
  flutteruikit_plugin_register_with_registrar(flutteruikit_registrar);
}
