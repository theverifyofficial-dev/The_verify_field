import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

class ApkVersionScreen extends StatefulWidget {
  const ApkVersionScreen({super.key});

  @override
  State<ApkVersionScreen> createState() =>
      _ApkVersionScreenState();
}

class _ApkVersionScreenState extends State<ApkVersionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime? selectedDate;
  final TextEditingController dateController = TextEditingController();

  File? selectedFile;
  String? errorText;

  final int maxSize = 150 * 1024 * 1024; // 150MB

  Future<void> pickApk() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      if (file.lengthSync() > maxSize) {
        setState(() {
          errorText = "File size exceeds 150MB limit";
          selectedFile = null;
        });
        return;
      }

      setState(() {
        selectedFile = file;
        errorText = null;
      });
    }
  }

  void submit(String type) {
    if (!_formKey.currentState!.validate() || selectedFile == null) {
      setState(() {
        errorText = "All fields including APK file are required";
      });
      return;
    }

    // API call here
    print("Version: ${versionController.text}");
    print("Notes: ${notesController.text}");
    print("File: ${selectedFile!.path}");
    print("Type: $type");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            type == "publish" ? "Version Published!" : "Draft Saved!"),
      ),
    );
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
        "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        //surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        title: Image.asset(
          AppImages.transparent,height: 40,),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// App Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF232526), const Color(0xFF414345)]
                        : [const Color(0xFF4A00E0), const Color(0xFF8E2DE2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.purple.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(AppImages.logo),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "App Messenger Pro",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Current Live: 1.0.3",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Version Name
              TextFormField(
                controller: versionController,
                decoration: InputDecoration(
                  labelText: "Version Name",
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter version name" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Publish Date",
                  hintText: "Select publish date",
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onTap: pickDate,
                validator: (value) =>
                value!.isEmpty ? "Select publish date" : null,
              ),

              const SizedBox(height: 16),

              /// Release Notes
              TextFormField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Release Notes",
                  hintText: "Describe what's new...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter release notes" : null,
              ),

              const SizedBox(height: 20),

              /// APK Upload Box
              GestureDetector(
                onTap: pickApk,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    border: Border.all(
                      color: theme.dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(16),

                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.upload_file,
                          size: 50, color: Colors.blue),
                      const SizedBox(height: 10),
                      const Text("Upload APK",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 5),
                      const Text("Max Size: 150MB",
                          style: TextStyle(color: Colors.grey)),
                      if (selectedFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(selectedFile!.path.split('/').last,
                              style: const TextStyle(color: Colors.green)),
                        ),
                    ],
                  ),
                ),
              ),

              if (errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(errorText!,
                      style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 30),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => submit("draft"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        foregroundColor: theme.colorScheme.onSecondaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Save Draft"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => submit("publish"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Publish Version",style:
                        TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}