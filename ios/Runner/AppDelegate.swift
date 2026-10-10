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
        // TODO: replace with a real Maps SDK for iOS key from Google Cloud Console
        // before building/running the Network Map feature, or the map will render blank.
        GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
        GeneratedPluginRegistrant.register(with: self)
        OcrPlugin.register(with: registrar(forPlugin: "OcrPlugin")!)  // ← SIRF YEH LINE ADD KARO
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}