import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Google Maps SDK key, used by the Network Map screen (google_maps_flutter).
        GMSServices.provideAPIKey("AIzaSyA8OTUHZIiHav1_7-vXerKRoL5BfQckFAo")
        GeneratedPluginRegistrant.register(with: self)
        OcrPlugin.register(with: registrar(forPlugin: "OcrPlugin")!)  // ← SIRF YEH LINE ADD KARO
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}