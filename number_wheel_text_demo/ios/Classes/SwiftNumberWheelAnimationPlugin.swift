import Flutter
import UIKit

public class SwiftNumberWheelAnimationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "number_wheel_animation", binaryMessenger: registrar.messenger())
    let instance = SwiftNumberWheelAnimationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
