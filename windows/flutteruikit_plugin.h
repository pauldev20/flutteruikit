#ifndef FLUTTER_PLUGIN_FLUTTERUIKIT_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTERUIKIT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutteruikit {

class FlutteruikitPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutteruikitPlugin();

  virtual ~FlutteruikitPlugin();

  // Disallow copy and assign.
  FlutteruikitPlugin(const FlutteruikitPlugin&) = delete;
  FlutteruikitPlugin& operator=(const FlutteruikitPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutteruikit

#endif  // FLUTTER_PLUGIN_FLUTTERUIKIT_PLUGIN_H_
