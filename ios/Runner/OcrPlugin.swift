 import Flutter
import UIKit
import Vision

public class OcrPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.verify.app/ocr",
            binaryMessenger: registrar.messenger()
        )
        let instance = OcrPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard call.method == "recognizeText",
              let args = call.arguments as? [String: Any],
              let imagePath = args["imagePath"] as? String else {
            result(FlutterMethodNotImplemented)
            return
        }

        recognizeText(imagePath: imagePath, result: result)
    }

    private func recognizeText(imagePath: String, result: @escaping FlutterResult) {
        guard let image = UIImage(contentsOfFile: imagePath),
              let cgImage = image.cgImage else {
            result(FlutterError(code: "INVALID_IMAGE",
                                message: "Could not load image from path",
                                details: imagePath))
            return
        }

        let request = VNRecognizeTextRequest { (req, error) in
            if let error = error {
                result(FlutterError(code: "OCR_ERROR",
                                    message: error.localizedDescription,
                                    details: nil))
                return
            }

            let observations = req.results as? [VNRecognizedTextObservation] ?? []
            let lines = observations.compactMap { obs in
                obs.topCandidates(1).first?.string
            }
            let fullText = lines.joined(separator: "\n")
            result(fullText)
        }

        // Use accurate recognition for Aadhaar cards
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                result(FlutterError(code: "OCR_FAILED",
                                    message: error.localizedDescription,
                                    details: nil))
            }
        }
    }
}
