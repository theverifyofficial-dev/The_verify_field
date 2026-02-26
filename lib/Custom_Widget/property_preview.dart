import 'package:flutter/material.dart';

class PropertyPreview extends StatefulWidget {
  final String ImageUrl;

  const PropertyPreview({super.key, required this.ImageUrl});

  @override
  State<PropertyPreview> createState() => _PropertyPreviewState();
}

class _PropertyPreviewState extends State<PropertyPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(widget.ImageUrl,
            errorBuilder: (_, __, ___) =>
             Icon(Icons.image_rounded, color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey,size: 40,),),
        ),
      ),
    );
  }

}
