import 'dart:convert';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

/// Convert numbers to words (Indian system: crore, lakh, thousand, hundred)
String numberToWords(int number) {
  if (number == 0) return 'ZERO';

  final units = [
    '',
    'ONE',
    'TWO',
    'THREE',
    'FOUR',
    'FIVE',
    'SIX',
    'SEVEN',
    'EIGHT',
    'NINE',
    'TEN',
    'ELEVEN',
    'TWELVE',
    'THIRTEEN',
    'FOURTEEN',
    'FIFTEEN',
    'SIXTEEN',
    'SEVENTEEN',
    'EIGHTEEN',
    'NINETEEN'
  ];
  final tens = [
    '',
    '',
    'TWENTY',
    'THIRTY',
    'FORTY',
    'FIFTY',
    'SIXTY',
    'SEVENTY',
    'EIGHTY',
    'NINETY'
  ];

  String twoDigit(int n) {
    if (n < 20) return units[n];
    final t = tens[n ~/ 10];
    final u = n % 10;
    return t + (u != 0 ? ' ' + units[u] : '');
  }

  String threeDigit(int n) {
    if (n == 0) return '';
    if (n < 100) return twoDigit(n);
    final h = n ~/ 100;
    final rem = n % 100;
    return units[h] + ' HUNDRED' + (rem != 0 ? ' ' + twoDigit(rem) : '');
  }

  // Use a local copy so we don't mutate the parameter
  int n = number;
  final parts = <String>[];

  // Crores (1 crore = 1,00,00,000 = 10,000,000)
  if (n >= 10000000) {
    final cr = n ~/ 10000000;
    parts.add(threeDigit(cr) + ' CRORE');
    n = n % 10000000;
  }

  // Lakhs (1 lakh = 1,00,000)
  if (n >= 100000) {
    final lk = n ~/ 100000;
    parts.add(threeDigit(lk) + ' LAKH');
    n = n % 100000;
  }

  // Thousands
  if (n >= 1000) {
    final th = n ~/ 1000;
    parts.add(threeDigit(th) + ' THOUSAND');
    n = n % 1000;
  }

  // Remaining hundreds and tens
  if (n > 0) {
    parts.add(threeDigit(n));
  }

  return parts.where((s) => s.trim().isNotEmpty).join(' ').trim();
}

/// Format amount as in your template: "Rs. 8000 /- (EIGHT THOUSAND RUPEES)"
String formatAmount(String? amount) {
  if (amount == null || amount.toString().trim().isEmpty) {
    return 'Rs. 0 /- ( ZERO RUPEES ) (static)';
  }
  final cleaned = amount.toString().replaceAll(',', '').trim();
  final intVal = int.tryParse(cleaned) ?? 0;
  final words = numberToWords(intVal);
  return 'Rs. $intVal /- ( $words RUPEES )';
}

/// Safe extraction: returns data[key] if present and not empty; otherwise returns fallback + ' (static)'
String safeString(Map<String, dynamic> data, String key, String fallback) {
  final v = data[key];
  if (v == null) return '$fallback (static)';
  final s = v.toString().trim();
  if (s.isEmpty) return '$fallback (static)';
  return s;
}

/// Parse date robustly; returns string in dd/MM/yyyy or fallback if parsing fails
String formatDateStr(dynamic dateVal, String fallback) {
  if (dateVal == null) return '$fallback (static)';
  try {
    String raw;
    if (dateVal is Map && dateVal.containsKey('date')) {
      raw = dateVal['date'].toString();
    } else {
      raw = dateVal.toString();
    }
    final dt = DateTime.parse(raw);
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yy = dt.year.toString();
    return '$dd/$mm/$yy';
  } catch (e) {
    final s = dateVal.toString();
    if (RegExp(r'\d{1,2}\/\d{1,2}\/\d{4}').hasMatch(s)) return s;
    return '$fallback (static)';
  }
}

DateTime addMonthsSafely(DateTime from, int monthsToAdd) {
  final targetMonth = from.month + monthsToAdd;
  final yearOffset = (targetMonth - 1) ~/ 12;
  final newYear = from.year + yearOffset;
  final newMonth = ((targetMonth - 1) % 12) + 1;

  // clamp day to the last day of the new month
  final lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
  final newDay = from.day <= lastDayOfNewMonth ? from.day : lastDayOfNewMonth;
  return DateTime(newYear, newMonth, newDay);
}

/// Label ID type automatically based on pattern (Aadhaar/PAN/Other)
String getIdLabel(String id) {
  if (RegExp(r'^\d{12}$').hasMatch(id)) return 'Aadhar Card No:';
  if (RegExp(r'^[A-Z]{5}\d{4}[A-Z]$').hasMatch(id)) return 'PAN No:';
  return 'ID No:';
}

/// Add correct ordinal suffix to a date (e.g., 1st, 2nd, 3rd, 4th)
String getDayWithSuffix(int day) {
  if (day >= 11 && day <= 13) return '${day}th';
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}

Future<File> generateFurnishedAgreementPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  // --- helper for clause formatting
  pw.Widget clause(String heading, List<pw.InlineSpan> spans) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 20),
      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: heading,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            ...spans,
          ],
        ),
      ),
    );
  }

  // --- Safe extracts
  final ownerName = safeString(data, 'owner_name', 'SWAVEN REALTY PRIVATE LIMITED');
  final ownerAadhaar = safeString(data, 'owner_addhar_no', '');
  final tenantName = safeString(data, 'tenant_name', 'PULKIT SATYARTHI');
  final tenantAadhaar = safeString(data, 'tenant_addhar_no', '482251509660');
  final tenantRelation = safeString(data, 'tenant_relation', 'S/O');
  final tenantRelationPerson = safeString(data, 'relation_person_name_tenant', '');
  final tenantPermAddress = safeString(data, 'permanent_address_tenant', 'JAWAHAR JYOTI BERI ...');
  final bhk = data['Bhk']?.toString() ?? '2BHK';
  final floor = data['floor']?.toString() ?? 'FLAT NO-10, 2ND FLOOR';
  final address = data['rented_address']?.toString() ?? 'KH NO-302, DHARAMPAL APARTMENT, VILLAGE SULTANPUR, MEHRAULI, NEW DELHI, DELHI, 110030';
  const companyName = 'SWAVEN REALTY PRIVATE LIMITED';
  const companyAddress = 'H NO-75, 2ND FLOOR, KH NO-365, VILLAGE SULTANPUR, SOUTH DELHI, DELHI-110030';

  final monthlyRentRaw = data['monthly_rent']?.toString() ?? '';
  final securityRaw = data['securitys']?.toString() ?? '';

  // --- Dates
  DateTime shiftingDate;
  try {
    shiftingDate = data['shifting_date'] != null
        ? DateTime.parse(data['shifting_date'].toString())
        : DateTime.now();
  } catch (_) {
    shiftingDate = DateTime.now();
  }

  final shiftingDateFormatted =
      '${shiftingDate.day.toString().padLeft(2, '0')}/${shiftingDate.month.toString().padLeft(2, '0')}/${shiftingDate.year}';
  final endDate = addMonthsSafely(shiftingDate, 11);
  final endDateFormatted =
      '${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}';
  final rentDueDay = getDayWithSuffix(shiftingDate.day);
  final currentDate = DateTime.now();
  final currentDateFormatted =
      '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}';

  // --- Styles
  final baseStyle = pw.TextStyle(fontSize: 11, height: 1.18);
  final boldStyle = pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, height: 1.18);
  final titleStyle = pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold);

  // --- Furniture parsing
  Map<String, dynamic> furnitureMap = {};
  try {
    final fData = data['furniture'];
    if (fData != null) {
      if (fData is String && fData.startsWith('{')) {
        furnitureMap = Map<String, dynamic>.from(json.decode(fData));
      } else if (fData is Map) {
        furnitureMap = Map<String, dynamic>.from(fData);
      }
    }
  } catch (_) {
    furnitureMap = {};
  }

  // ----- PAGE 1 -----
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 32, 28, 20),
      build: (context) => [
        pw.Center(child: pw.Text('FURNISHED RENT AGREEMENT', style: titleStyle)),
        pw.SizedBox(height: 10),

        pw.RichText(
          text: pw.TextSpan(
            style: baseStyle,
            children: [
              const pw.TextSpan(text: 'This Rent Agreement is made and executed on this '),
              pw.TextSpan(text: currentDateFormatted, style: boldStyle),
              const pw.TextSpan(text: ' by and Between:'),
            ],
          ),
        ),
        pw.SizedBox(height: 8),

        pw.Text('$companyName, Resident of $companyAddress (hereinafter called the FIRST PARTY/LANDLORD).',
            style: boldStyle),
        pw.SizedBox(height: 10),

        pw.Container(width: double.infinity, child: pw.Text('AND', textAlign: pw.TextAlign.center, style: boldStyle)),
        pw.SizedBox(height: 8),

        pw.Text(
          '$tenantName ${tenantRelation.isNotEmpty ? "($tenantRelation)" : ""} ${tenantRelationPerson.isNotEmpty ? tenantRelationPerson : ""} Resident $tenantPermAddress (hereinafter called the SECOND PARTY/TENANT).',
          style: boldStyle,
        ),
        pw.SizedBox(height: 10),

        pw.Text(
          'The expressions of both parties shall mean and include their respective legal heirs, successors, executors, administrators, representatives, and legal assigns.',
          style: baseStyle,
        ),
        pw.SizedBox(height: 10),

        pw.Text('WHEREAS the First Party agrees to let out the furnished premises situated at $bhk, $floor, $address.',
            style: boldStyle),
        pw.SizedBox(height: 12),

        pw.Text('FURNISHED ITEMS PROVIDED:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),


        if (furnitureMap.isNotEmpty)
          ...furnitureMap.entries.map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '', // clean bullet using Unicode
                    style: baseStyle,
                  ),
                  pw.TextSpan(
                    text: '${e.key} (${e.value})',
                    style: boldStyle, // make item bold as requested
                  ),
                ],
              ),
            ),
          ))
        else
          pw.Text('• No furnished items specified.', style: baseStyle),


        pw.SizedBox(height: 14),

        pw.Text(
          'And the Tenant has agreed to take on rent the said furnished property on the following terms and conditions:',
          style: baseStyle,
        ),
        pw.SizedBox(height: 12),

        pw.Text('NOW THIS RENT AGREEMENT WITNESSETH AS UNDER:',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),

        // Clauses with bold dynamic content
        clause('1. Tenancy Period:', [
          pw.TextSpan(
            text: ' 11 months',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          const pw.TextSpan(
            text: ' commencing from ',
            style: pw.TextStyle(fontSize: 11),
          ),
          pw.TextSpan(
            text: shiftingDateFormatted,
            style: boldStyle,
          ),
          const pw.TextSpan(
            text: ' to ',
            style: pw.TextStyle(fontSize: 11),
          ),
          pw.TextSpan(
            text: endDateFormatted,
            style: boldStyle,
          ),
          const pw.TextSpan(
            text: '.',
            style: pw.TextStyle(fontSize: 11),
          ),
        ]),


        clause('2. Rent:', [
          const pw.TextSpan(
              text:
              ' The Second Party has paid an advance rent of ',
              style: pw.TextStyle(fontSize: 11)),
          pw.TextSpan(text: formatAmount(monthlyRentRaw), style: boldStyle),
          const pw.TextSpan(
              text: '. The monthly rent shall be ',
              style: pw.TextStyle(fontSize: 11)),
          pw.TextSpan(text: formatAmount(monthlyRentRaw), style: boldStyle),
          const pw.TextSpan(
              text: ' and is payable in advance on or before the ',
              style: pw.TextStyle(fontSize: 11)),
          pw.TextSpan(text: '$rentDueDay day', style: boldStyle),
          const pw.TextSpan(text: ' of each calendar month.', style: pw.TextStyle(fontSize: 11)),
        ]),

        clause('3. Security Deposit:', [
          const pw.TextSpan(
              text: ' A security deposit of ', style: pw.TextStyle(fontSize: 11)),
          pw.TextSpan(text: formatAmount(securityRaw), style: boldStyle),
          const pw.TextSpan(
              text:
              ' is paid by the Second Party. This deposit is interest-free and shall be refundable after adjusting any dues for damages, furniture, rent, bills, and cleaning.',
              style: pw.TextStyle(fontSize: 11)),
        ]),

        clause('4. Usage:', [
          const pw.TextSpan(
              text:
              ' The premises and provided furniture/appliances shall be used for residential purposes only. '
                  'Use for business purposes is not permitted unless mutually agreed. Non-payment of rent leads to termination. '
                  'Refusal to vacate will result in legal action.',
              style: pw.TextStyle(fontSize: 11)),
        ]),

        clause('5. Furnished Items:', [
          const pw.TextSpan(
              text:
              ' The Second Party shall maintain all furniture and appliances in good condition. Any damage beyond normal wear and tear will be chargeable. '
                  'If any item stops functioning due to negligence or mishandling by the tenant, the cost of repair/replacement shall be borne by the tenant.',
              style: pw.TextStyle(fontSize: 11)),
        ]),

        clause('6. Vacating Premises:', [
          const pw.TextSpan(
            text:
            ' On tenancy end, the tenant shall return the flat and all furnished items in original condition. Rent increases by ',
            style: pw.TextStyle(fontSize: 11),
          ),
          pw.TextSpan(
            text: '10%',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          const pw.TextSpan(
            text: ' if renewed.',
            style: pw.TextStyle(fontSize: 11),
          ),
        ]),

        clause('7. Lock-in Period:', [
          const pw.TextSpan(
            text:
            ' Lease cannot be terminated within the first ',
            style: pw.TextStyle(fontSize: 11),
          ),
          pw.TextSpan(
            text: '11 months',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          const pw.TextSpan(
            text:
            '. Early termination will lead to forfeiture of the security deposit.',
            style: pw.TextStyle(fontSize: 11),
          ),
        ]),

      ],
    ),
  );

  // ----- PAGE 2 -----
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      build: (context) => [
        clause('8. Rent Default:', [
          const pw.TextSpan(
              text:
              ' If the Second Party fails to pay the rent on or before the due date, a late fee of 10% per day shall be payable '
                  'along with the outstanding rent. If the rent remains unpaid, the Owner reserves the right to take legal action against the Tenant. '
                  'In such a case, the security deposit shall be deemed non-refundable.',
              style: pw.TextStyle(fontSize: 11)),
        ]),

        clause('9. Theft/Damage to Furnished Items:', [
          const pw.TextSpan(
              text:
              ' The Second Party shall be fully responsible for any theft, loss, or damage to the furnished items provided by the First Party. '
                  'In case of any such incident, the Second Party must either repair, replace, or pay the cost of the item. '
                  'If the Second Party fails to pay the damage or theft cost, the First Party has the full right to take legal action against the Second Party '
                  'and recover the amount through legal means.',
              style: pw.TextStyle(fontSize: 11)),
        ]),

        pw.SizedBox(height: 18),
        pw.Text(
          'IN WITNESS WHEREOF, both the parties have signed this Deed of Agreement on the day, month and year first above written. '
              'That both the parties have read and understood the contents of this Agreement and have signed the same without any force or pressure from any side.',
          style: baseStyle,
        ),
        pw.SizedBox(height: 14),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('1', style: boldStyle),
              pw.SizedBox(height: 4),
              pw.Text('Name: $companyName', style: boldStyle),
              pw.Text('${getIdLabel(ownerAadhaar)} $ownerAadhaar', style: baseStyle),
              pw.SizedBox(height: 12),
              pw.Text('FIRST PARTY/OWNER', style: baseStyle),
            ]),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('2', style: boldStyle),
              pw.SizedBox(height: 4),
              pw.Text('Name: $tenantName', style: boldStyle),
              pw.Text('Aadhar Card No: $tenantAadhaar', style: baseStyle),
              pw.SizedBox(height: 12),
              pw.Text('SECOND PARTY/TENANT', style: baseStyle),
            ]),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text('WITNESS:-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('1 Name: ', style: baseStyle),
        pw.SizedBox(height: 6),
        pw.Text('2 Name: ', style: baseStyle),
      ],
    ),
  );

  // Save file
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/furnished_agreement_${data['id'] ?? DateTime.now().millisecondsSinceEpoch}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}
