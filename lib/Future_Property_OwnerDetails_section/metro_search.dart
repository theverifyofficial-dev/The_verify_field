import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class MetroField extends StatefulWidget {
  final String? initialValue;
  final Function(String name, String? lat, String? lon) onSelected;
  const MetroField({super.key, this.initialValue, required this.onSelected});

  @override
  State<MetroField> createState() => _MetroFieldState();
}

class _MetroFieldState extends State<MetroField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
  }

  Future<List<Map<String, dynamic>>> _fetchMetroNames(String pattern) async {
    if (pattern.length < 2) return [];
    final url = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Metro_name/metro_name.php?q=$pattern');

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return _normalizeItems(data);
      }
    } catch (_) {}
    return [];
  }

  List<Map<String, dynamic>> _normalizeItems(dynamic json) {
    if (json is List) return List<Map<String, dynamic>>.from(json);
    if (json is Map<String, dynamic>) {
      if (json['items'] is List)
        return List<Map<String, dynamic>>.from(json['items']);
      if (json['results'] is List)
        return List<Map<String, dynamic>>.from(json['results']);
      for (final value in json.values) {
        if (value is List) return List<Map<String, dynamic>>.from(value);
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Map<String, dynamic>>(
      suggestionsCallback: (pattern) => _fetchMetroNames(pattern),
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: _controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Metro Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (val) =>
          val == null || val.isEmpty ? 'Please select metro name' : null,
        );
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion['name'] ?? ''),
          subtitle: suggestion['line'] != null
              ? Text(suggestion['line'], style: const TextStyle(fontSize: 12))
              : null,
        );
      },
      onSelected: (suggestion) {
        final name = suggestion['name'] ?? '';
        final lat = suggestion['lat']?.toString();
        final lon = suggestion['lon']?.toString();
        _controller.text = name;
        widget.onSelected(name, lat, lon);
      },
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No metro found', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
