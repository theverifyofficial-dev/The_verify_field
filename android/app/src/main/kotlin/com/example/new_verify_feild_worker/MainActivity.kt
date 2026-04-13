package com.example.new_verify_feild_worker

import android.graphics.BitmapFactory
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val OCR_CHANNEL = "com.verify.app/ocr"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            OCR_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "recognizeText") {
                val imagePath = call.argument<String>("imagePath")
                if (imagePath == null) {
                    result.error("NO_PATH", "No image path provided", null)
                    return@setMethodCallHandler
                }
                try {
                    val bitmap = BitmapFactory.decodeFile(imagePath)
                    if (bitmap == null) {
                        result.error("INVALID_IMAGE", "Could not decode image", null)
                        return@setMethodCallHandler
                    }
                    val image = InputImage.fromBitmap(bitmap, 0)
                    val recognizer = TextRecognition.getClient(
                        TextRecognizerOptions.DEFAULT_OPTIONS
                    )
                    recognizer.process(image)
                        .addOnSuccessListener { visionText ->
                            result.success(visionText.text)
                        }
                        .addOnFailureListener { e ->
                            result.error("OCR_ERROR", e.message, null)
                        }
                } catch (e: Exception) {
                    result.error("OCR_EXCEPTION", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}