#include "include/flutteruikit/flutteruikit_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutteruikit_plugin.h"

void FlutteruikitPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutteruikit::FlutteruikitPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
