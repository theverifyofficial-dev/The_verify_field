import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/* -------------------- AMOUNT HELPERS -------------------- */

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

int parseIndianAmount(String input) {
  String value = input.toUpperCase().replaceAll(',', '').trim();

  if (value.contains('LAC') || value.contains('LAKH')) {
    final numberPart = value.split(RegExp(r'LAC|LAKH'))[0].trim();
    final numVal = double.tryParse(numberPart) ?? 0;
    return (numVal * 100000).toInt();
  }

  if (value.contains('CR') || value.contains('CRORE')) {
    final numberPart = value.split(RegExp(r'CR|CRORE'))[0].trim();
    final numVal = double.tryParse(numberPart) ?? 0;
    return (numVal * 10000000).toInt();
  }

  return int.tryParse(value) ?? 0;
}

String formatAmount(String? amount) {
  if (amount == null || amount.toString().trim().isEmpty) {
    return 'Rs. 0 /- ( ZERO RUPEES )';
  }

  final intVal = parseIndianAmount(amount);
  final words = numberToWords(intVal);

  return 'Rs. $intVal /- ( $words RUPEES )';
}

String maskAadhaar(String v) {
  final d = v.replaceAll(RegExp(r'\D'), '');
  if (d.length < 4) return v;
  return 'X' * (d.length - 3) + d.substring(d.length - 3);
}

DateTime add11Months(DateTime d) {
  final m = d.month + 11;
  final y = d.year + ((m - 1) ~/ 12);
  final nm = ((m - 1) % 12) + 1;
  return DateTime(y, nm, d.day);
}

/* -------------------- PDF GENERATOR -------------------- */

Future<File> generateCommercialAgreementPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  final bool hide = data['is_agreement_hide']?.toString() == '1';

  final ownerName = data['owner_name'];
  final ownerRelation = data['owner_relation'];
  final ownerRelationPerson = data['relation_person_name_owner'];
  final ownerAddress = data['parmanent_addresss_owner'];
  final ownerAadhaar = hide ? maskAadhaar(data['owner_addhar_no']) : data['owner_addhar_no'];

  final tenantName = data['tenant_name'];
  final tenantRelation = data['tenant_relation'];
  final tenantRelationPerson = data['relation_person_name_tenant'];
  final tenantAddress = data['permanent_address_tenant'];
  final tenantAadhaar = hide ? maskAadhaar(data['tenant_addhar_no']) : data['tenant_addhar_no'];

  final propertyAddress = '${data['floor']}, ${data['rented_address']}';

  final monthlyRentRaw = data['monthly_rent']?.toString() ?? '';
  final customMeterUnit = data['custom_meter_unit']?.toString().trim() ?? '';
  final securityRaw = data['securitys']?.toString() ?? '';



  final rawCompanyName = data['company_name']?.toString().trim() ?? '';
  final rawGstType = data['gst_type']?.toString().trim() ?? '';
  final rawGstNo = data['gst_no']?.toString().trim() ?? '';


  final DateTime startDate = DateTime.parse(data['shifting_date'].toString());
  final DateTime fullDate =
  DateTime.parse(data['current_dates'].toString());

  final String formattedDate =
  DateFormat('dd-MM-yyyy').format(fullDate);
  final DateTime endDate = add11Months(startDate);

  pw.TextSpan getMeterClause(Map<String, dynamic>? data) {
    final customMeterUnit =
        data?["custom_meter_unit"]?.toString().trim() ?? '';

    final String meterValue =
    customMeterUnit.isNotEmpty
        ? "${customMeterUnit} per unit"
        : "commercial unit";

    return pw.TextSpan(
      children: [
        pw.TextSpan(
          text:
          "The Director is solely responsible for the timely payment of all electricity, water, internet, and other service charges used on the premises. The electricity charges shall be payable at the rate of ",
          style: pw.TextStyle(fontSize: 11),
        ),
        pw.TextSpan(
          text: meterValue,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.TextSpan(
          text: ", based on actual consumption.",
          style: pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }


  List<Map<String, dynamic>> additionalTenants = [];
  try {
    final res = await http.get(Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/show_api_for_addtional_tenant.php?agreement_id=${data['id']}',
    ));
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      additionalTenants = List<Map<String, dynamic>>.from(decoded['data'] ?? []);
    }
  } catch (_) {}

  pw.TextStyle base = pw.TextStyle(fontSize: 11);
  pw.TextStyle bold = pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);
  pw.TextStyle title = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold);

  pw.Widget clause(String h, String b) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.RichText(
      text: pw.TextSpan(children: [
        pw.TextSpan(text: '$h ', style: bold),
        pw.TextSpan(text: b, style: base),
      ]),
    ),
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      footer: (c) => pw.Center(child: pw.Text('Page ${c.pageNumber} of ${c.pagesCount}', style: pw.TextStyle(fontSize: 9))),
      build: (_) => [

        pw.Center(child: pw.Text('Leave & License', style: title)),
        pw.SizedBox(height: 12),

        pw.RichText(
          text: pw.TextSpan(
            children: [

              pw.TextSpan(
                text: 'This Leave & License is made and executed at New Delhi on this ',
                style: base,
              ),

              pw.TextSpan(
                text:
                '$formattedDate',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.TextSpan(
                text: '. By & Between.',
                style: base,
              ),
            ],
          ),
        ),


        pw.SizedBox(height: 8),

        pw.Text(
          '$ownerName, $ownerRelation $ownerRelationPerson, residing at $ownerAddress, '
              'hereinafter referred to as the "LANDLORD/FIRST PARTY".',
          style: bold,
        ),

        pw.SizedBox(height: 10),
        pw.Text('                                                                            AND', style: bold),

        pw.SizedBox(height: 10),


          pw.Text(
            rawCompanyName,
            style: pw.TextStyle     (fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        if(rawGstNo.isNotEmpty)
        pw.Text(
          '$rawGstType No. : $rawGstNo',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),

        pw.SizedBox(height: 6),

        pw.Text(
          '1. $tenantName, $tenantRelation $tenantRelationPerson, residing at $tenantAddress',
          style: bold,
        ),
        pw.SizedBox(height: 6),

        ...additionalTenants.asMap().entries.map((e) {
          final t = e.value;
          return pw.Text(
            '${e.key + 2}. ${t['tenant_name']}, residing at $tenantAddress',
            style: bold,
          );
        }),

        pw.SizedBox(height: 6),
        pw.Text(
          'All the above-named persons are hereinafter collectively referred to as the "DIRECTOR/SECOND PARTY".',
          style: base,
        ),

        pw.SizedBox(height: 10),
        pw.Text('WHEREAS:', style: bold),

        pw.RichText(
          text: pw.TextSpan(
            style: base,
            children: [
              pw.TextSpan(
                text: '1. The Landlord is the absolute owner and in possession of the property situated at ',
              ),
              pw.TextSpan(
                text: propertyAddress,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.TextSpan(
                text: ', hereinafter referred to as the "PREMISES".',
              ),
            ],
          ),
        ),


        pw.RichText(
          text: pw.TextSpan(
            style: base,
            children: [
              pw.TextSpan(
                text: '2. The Director has approached the Landlord to take the Premises on rent for ',
              ),
              pw.TextSpan(
                text: 'commercial purposes',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.TextSpan(
                text:
                ', and the Landlord has agreed to grant the said Premises on Leave & License basis on the terms and conditions set forth hereinafter.',
              ),
            ],
          ),
        ),


        pw.SizedBox(height: 12),
        pw.Text('TERMS & CONDITIONS OF LEAVE & LICENSE', style: bold),
        pw.SizedBox(height: 10),

        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.RichText(
            text: pw.TextSpan(
              style: base,
              children: [
                pw.TextSpan(
                  text: '1. TENANCY TIME PERIOD & RENEWAL HIKE: ',
                  style: bold,
                ),
                pw.TextSpan(
                  text:
                  'This agreement is valid for a fixed period of 11 (Eleven) months, starting from ',
                ),
                pw.TextSpan(
                  text:
                  '${startDate.day}/${startDate.month}/${startDate.year}',
                  style: bold,
                ),
                pw.TextSpan(text: ' and ending on '),
                pw.TextSpan(
                  text:
                  '${endDate.day}/${endDate.month}/${endDate.year}',
                  style: bold,
                ),
                pw.TextSpan(
                  text:
                  '. If both parties mutually agree to renew this agreement after this term, the monthly rent will automatically increase by ',
                ),
                pw.TextSpan(
                  text: '10% (Ten Percent)',
                  style: bold,
                ),
                pw.TextSpan(
                  text:
                  ' of the current rent amount. A fresh written agreement must be signed for every renewal.',
                ),
              ],
            ),
          ),
        ),


        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.RichText(
            text: pw.TextSpan(
              style: base,
              children: [
                pw.TextSpan(
                  text: '2. MONTHLY RENT PAYMENT: ',
                  style: bold,
                ),
                pw.TextSpan(text: 'The Director agrees to pay a monthly rent of '),
                pw.TextSpan(
                  text: formatAmount(monthlyRentRaw),
                  style: bold,
                ),
                pw.TextSpan(
                  text:
                  ' to the Landlord as consideration for the use of the premises. This payment must be made in advance on or before the 10th day of every English calendar month through an agreed mode (Cash/Cheque/Digital Transfer).',
                ),
              ],
            ),
          ),
        ),

        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.RichText(
            text: pw.TextSpan(
              style: base,
              children: [
                pw.TextSpan(
                  text: '3. SECURITY DEPOSIT: ',
                  style: bold,
                ),
                pw.TextSpan(text: 'The Director has paid an interest-free security deposit of '),
                pw.TextSpan(
                  text: formatAmount(securityRaw),
                  style: bold,
                ),
                pw.TextSpan(
                  text:
                  ' to the Landlord. This total amount will be returned to the Director only after they have moved out and handed over the keys, minus any deductions for unpaid utility bills or necessary repair costs for damages caused by the Director during their stay.',
                ),
              ],
            ),
          ),
        ),


        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.RichText(
            text: pw.TextSpan(
              style: base,
              children: [
                pw.TextSpan(
                  text: '4. UTILITY BILL RESPONSIBILITY: ',
                  style: bold,
                ),
                getMeterClause(data),
              ],
            ),
          ),
        ),


        clause('5. MAINTENANCE OF PUBLIC ORDER:',
            'The Director must ensure that their business operations do not cause any noise, environmental pollution, or physical obstruction to public paths. '
                'The Director is responsible for ensuring that the trade does not cause any annoyance or danger to the neighbors or the general public.'),

        clause('Legal Note:',
            'Causing such disturbances is a "Public Nuisance" punishable under BNS Chapter XV (Sections 270 to 299).'),

        clause('6. SAFETY & PERSONAL INJURY:',
            'The Landlord shall not be held liable for any injury, loss of life, or incidents of self-harm (including suicide or attempted suicide) that may occur on the property involving the Director, their staff, or their guests. '
                'The Director is entirely responsible for the workplace safety and well-being of their own staff and customers.'),

        clause('7. THEFT & FIRE DAMAGE REPAIRS:',
            'The Landlord is not responsible for any items stolen from the premises or for fire damage to the Director\'s goods or cash. '
                'In the event of a fire, any damage caused to the building structure or the Landlord\'s fixtures must be repaired and paid for by the Director at their own cost before they vacate the property.'),

        clause('8. PROHIBITION OF ILLEGAL ACTIVITIES:',
            'The Director shall not use the property for any activity that is forbidden by law, nor shall they store any hazardous, explosive, or illegal substances on the premises.'),

        clause('Legal Note:',
            'Using a property for "Organized Crime" or illegal storage carries severe penalties under BNS Section 111.'),

        clause('9. PROPERTY AS COLLATERAL:',
            'The Director is strictly forbidden from using the leased property or this agreement as a guarantee/collateral to obtain a bank loan or any other financial assistance.'),

        clause('Legal Note:',
            'Pretending to be the property owner to gain financial benefits is "Cheating by Personation" under BNS Section 319.'),

        clause('10. ENVIRONMENTAL LIABILITY & SEALING:',
            'The Director must not perform any act that harms the environment. If the Director\'s business breaks environmental laws, the Director is 100% responsible. '
                'If the property is sealed due to the Director\'s actions, the Director must pay all costs to unseal it and cover the Landlord\'s losses.'),

        clause('Legal Note:',
            'Water and air pollution are criminal offenses under BNS Sections 279 and 280 respectively.'),

        clause('11. LATE PAYMENT & BOUNCED CHEQUES:',
            'If rent is not paid by the due date, a 5% late fee will be applied to the outstanding amount. '
                'Additionally, if a rent cheque bounces, the Director must pay a 5% daily penalty until the amount is fully cleared.'),

        clause('Legal Note:',
            'Bouncing a cheque is a crime under Section 138 of the NI Act. Fraudulent intent to occupy without paying is "Cheating" under BNS Section 318.'),

        clause('12. BUSINESS LICENSES & WORKER CONDUCT:',
            'The Director is 100% responsible for obtaining all required government licenses and documents for their specific trade. '
                'Any wrongdoing or illegal act by a worker will be the Director\'s responsibility, not the Owner\'s.'),

        clause('13. PROHIBITION OF SUBLETTING:',
            'The Director is strictly prohibited from renting out any part of this property to another person (subletting) or transferring the lease to a third party without the Landlord\'s prior written permission.'),

        clause('Legal Note:',
            'Doing this without consent is "Criminal Breach of Trust" under BNS Section 316.'),

        clause('14. STRUCTURAL CHANGES & PERMISSIONS:',
            'The Director is strictly forbidden from making any structural changes without prior written permission from the Owner.'),

        clause('Legal Note:',
            'Unauthorized alterations constitute "Mischief" under BNS Section 324.'),

        clause('15. TAX & LOAN RESPONSIBILITY:',
            'The Director is solely responsible for managing and paying all business-related taxes, including GST and Income Tax.'),

        clause('16. POLICE VERIFICATION REQUIREMENT:',
            'The Directors must complete the Police Verification process before moving in.'),

        clause('Legal Note:',
            'Failure to comply is a violation under BNS Section 223.'),

        clause('17. EARLY TERMINATION NOTICE:',
            'If either party wishes to end this agreement before the term is over, they must give at least one month\'s written notice.'),

        clause('18. MOVING OUT & REPAIRING DAMAGE:',
            'Upon moving out, the Director must return the property in the same condition it was received.'),

        clause('Legal Note:',
            'Refusing to vacate after the term ends is Criminal Trespass under BNS Section 329.'),

        clause('19. ILLEGAL ACTS & FRAUD COMPLICITY:',
            'Any illegal or fraudulent act committed on the property is solely the Director\'s responsibility.'),

        clause('20. ENCROACHMENT OF PROPERTY:',
            'The Director must strictly stay within the boundaries of the rented premises.'),

        clause('21. PROHIBITION OF ILLEGAL POSSESSION AND LAND GRABBING:',
            'Any attempt to claim ownership or refuse to leave after the agreement ends will be treated as Illegal Possession under BNS Section 318 and 329.'),

        clause('22. DIGITAL PROOF & CHATS:',
            'Digital communications, including WhatsApp chats and emails, will be considered valid proof of communication.'),

        clause('Legal Note:',
            'Recognized under Section 63 of the Bharatiya Sakshya Adhiniyam (BSA), 2023.'),

        clause('23. LEGAL JURISDICTION:',
            'Any dispute shall be handled exclusively by the Courts of New Delhi.'),


        pw.SizedBox(height: 30),

        pw.SizedBox(height: 30),
        pw.Text('IN WITNESS WHEREOF, the Landlord and the Directors have signed this Agreement.', style: base),
        pw.SizedBox(height: 30),

        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [

            /// LANDLORD
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('LANDLORD', style: bold),
                pw.SizedBox(height: 10),
                pw.Text('Name: $ownerName'),
                pw.Text('Aadhaar No: $ownerAadhaar'),
                pw.SizedBox(height: 30),
                pw.Text('Signature: _____________________'),

              ],
            ),

            /// TENANT 1
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Director 1', style: bold),
                pw.SizedBox(height: 10),
                pw.Text('Name: $tenantName'),
                pw.Text('Aadhaar No: $tenantAadhaar'),
                pw.SizedBox(height: 30),
                pw.Text('Signature: _____________________'),

                ...additionalTenants.asMap().entries.map((entry) {
                  final index = entry.key; // 0-based
                  final t = entry.value;

                  final aadhaar =
                  hide ? maskAadhaar(t['tenant_aadhar_no']) : t['tenant_aadhar_no'];

                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 25),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 10),
                        pw.Text('Director ${index + 2}', style: bold), // 🔥 starts from 2
                        pw.SizedBox(height: 10),
                        pw.Text('Name: ${t['tenant_name']}'),
                        pw.Text('Aadhaar No: $aadhaar'),
                        pw.SizedBox(height: 30),
                        pw.Text('Signature: _____________________'),
                      ],
                    ),
                  );
                }),


                pw.SizedBox(height: 10),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 10),


        pw.Text('WITNESSES:', style: bold),
        pw.SizedBox(height: 15),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('1. WITNESS ONE'),
                pw.SizedBox(height: 30),
                pw.Text('Signature: _____________________'),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('2. WITNESS TWO'),
                pw.SizedBox(height: 30),
                pw.Text('Signature: _____________________'),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/commercial_agreement_${data['id']}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}
