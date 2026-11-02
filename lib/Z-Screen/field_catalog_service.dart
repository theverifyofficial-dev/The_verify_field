import 'dart:convert';
import 'package:http/http.dart' as http;

/// Field Catalog ("Share my catalog") feature -- 2026-10-28.
///
/// One shared backend call, used from two places:
///  - Profile page's "Share my catalog" button (shares the field worker's
///    whole catalog link + a ready-made `share_text`).
///  - A property/flat Detail page's "Share" button (shares just this one
///    property, by appending "&p=<P_id>" to the same catalog `url`).
///
/// The backend app key is NEVER hardcoded here -- per the user's explicit
/// instruction, it is compiled in at build time via
/// `--dart-define=FIELD_CATALOG_APP_KEY=<the real key>` and falls back to
/// an empty string if that flag wasn't passed. An empty key is treated as
/// a build-configuration problem (shown to the user as a friendly error),
/// never sent to the API as a literal empty `key=` param.
const String fieldCatalogAppKey =
    String.fromEnvironment('FIELD_CATALOG_APP_KEY');

const String _fieldCatalogEndpoint =
    'https://verifyrealestateandservices.in/Second%20PHP%20FILE/field_catalog/catalog_link.php';

/// Parsed result of calling the Field Catalog API once. Either [success]
/// is true and [url]/[shareText] are populated, or it's false and
/// [errorMessage] is the message to show the user (the API's own
/// `message` field on an error response, or a generic fallback if the
/// call failed before even reaching a parseable response).
class FieldCatalogResult {
  final bool success;
  final String? name;
  final int? count;
  final String? url;
  final String? shareText;
  final String? errorMessage;

  const FieldCatalogResult._({
    required this.success,
    this.name,
    this.count,
    this.url,
    this.shareText,
    this.errorMessage,
  });

  factory FieldCatalogResult.success({
    String? name,
    int? count,
    required String url,
    required String shareText,
  }) =>
      FieldCatalogResult._(
        success: true,
        name: name,
        count: count,
        url: url,
        shareText: shareText,
      );

  factory FieldCatalogResult.failure(String message) =>
      FieldCatalogResult._(success: false, errorMessage: message);
}

/// Calls the one Field Catalog endpoint for [workerNumber] (the field
/// worker's own 10-digit number -- callers should read this from
/// `SharedPreferences`'s existing `'number'` key, the same one every other
/// screen in this app already uses) and returns a parsed
/// [FieldCatalogResult]. Never throws -- any network/parse failure comes
/// back as `FieldCatalogResult.failure(...)` instead.
Future<FieldCatalogResult> fetchFieldCatalogLink(String workerNumber) async {
  if (fieldCatalogAppKey.isEmpty) {
    print('FieldCatalog: FIELD_CATALOG_APP_KEY is empty -- was --dart-define passed at build/run time?');
    return FieldCatalogResult.failure(
      'Catalog sharing is not configured for this app build. Please contact support.',
    );
  }

  final uri = Uri.parse(
    '$_fieldCatalogEndpoint'
    '?key=${Uri.encodeQueryComponent(fieldCatalogAppKey)}'
    '&number=${Uri.encodeQueryComponent(workerNumber)}',
  );

  print('FieldCatalog: calling $uri');

  try {
    final response = await http.get(uri);
    print('FieldCatalog: status ${response.statusCode}, body: ${response.body}');

    final decoded = jsonDecode(response.body);

    if (decoded is Map && decoded['status'] == 'success') {
      return FieldCatalogResult.success(
        name: decoded['name']?.toString(),
        count: int.tryParse(decoded['count']?.toString() ?? ''),
        url: decoded['url']?.toString() ?? '',
        shareText: decoded['share_text']?.toString() ?? '',
      );
    }

    final message = (decoded is Map ? decoded['message']?.toString() : null);
    print('FieldCatalog: API returned an error -- $message');
    return FieldCatalogResult.failure(
      (message != null && message.trim().isNotEmpty)
          ? message
          : 'Something went wrong. Please try again.',
    );
  } catch (e) {
    print('FieldCatalog: exception while calling the API -- $e');
    return FieldCatalogResult.failure(
      'Unable to reach the server. Please check your connection and try again.',
    );
  }
}
