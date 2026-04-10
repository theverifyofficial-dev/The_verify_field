import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        OcrPlugin.register(with: registrar(forPlugin: "OcrPlugin")!)  // ← SIRF YEH LINE ADD KARO
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}