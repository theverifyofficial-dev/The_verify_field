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

  String words = '';

  if (number >= 10000000) {
    final cr = number ~/ 10000000;
    words += threeDigit(cr) + ' CRORE ';
    number %= 10000000;
  }
  if (number >= 100000) {
    final lk = number ~/ 100000;
    words += threeDigit(lk) + ' LAKH ';
    number %= 100000;
  }
  if (number >= 1000) {
    final th = number ~/ 1000;
    words += threeDigit(th) + ' THOUSAND ';
    number %= 1000;
  }
  if (number > 0) {
    words += threeDigit(number);
  }

  return words.trim();
}

/// Format amount as in your template: "Rs. 8000 /- (EIGHT THOUSAND RUPEES)"
String formatAmount(String? amount) {
  if (amount == null || amount.toString().trim().isEmpty) return 'Rs. 0 /- ( ZERO RUPEES ) (static)';
  // remove commas, spaces
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
    // if it's already in a dd/mm/yyyy-like string, return it
    final s = dateVal.toString();
    if (RegExp(r'\d{1,2}\/\d{1,2}\/\d{4}').hasMatch(s)) return s;
    return '$fallback (static)';
  }
}

Future<File> generateAgreementPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  // dynamic-safe reads (use fallback with (static) if missing)
  final ownerName = safeString(data, 'owner_name', 'PAWAN');
  final ownerRelation = safeString(data, 'owner_relation', 'S/O');
  final ownerRelationPerson = safeString(data, 'relation_person_name_owner', 'QWERTY');
  final ownerAddress = safeString(data, 'parmanent_addresss_owner', 'DEMO ADDRESS');
  final ownerAadhar = safeString(data, 'owner_addhar_no', '297374997337');

  final tenantName = safeString(data, 'tenant_name', 'DEMO TENANT');
  final tenantRelation = safeString(data, 'tenant_relation', 'S/O');
  final tenantRelationPerson = safeString(data, 'relation_person_name_tenant', 'PAWAN');
  final tenantPermAddress = safeString(data, 'permanent_address_tenant', 'DEMO TENANT ADDRESS');
  final tenantMobile = safeString(data, 'tenant_mobile_no', '0000000000');
  final tenantAadhar = safeString(data, 'tenant_addhar_no', '100288377394');

  final rentedAddress = safeString(data, 'rented_address', '2 BHK 18 ACCHANAK');

  final monthlyRentRaw = data['monthly_rent']?.toString() ?? '';
  final maintenanceRaw = data['maintaince']?.toString() ?? '';
  final securityRaw = data['securitys']?.toString() ?? '';
  final installmentSecurityRaw = data['installment_security_amount']?.toString() ?? '';

  final shiftingDateStr = formatDateStr(data['shifting_date'], '23/09/2025');
  // compute end date by parsing shifting date when possible
  DateTime shiftingDate;
  try {
    if (data['shifting_date'] is Map && data['shifting_date']['date'] != null) {
      shiftingDate = DateTime.parse(data['shifting_date']['date'].toString());
    } else {
      shiftingDate = DateTime.parse(data['shifting_date'].toString());
    }
  } catch (_) {
    shiftingDate = DateTime(2025, 9, 23); // fallback static
  }
  final endDate = DateTime(shiftingDate.year, shiftingDate.month + 11, shiftingDate.day);
  final shiftingDateFormatted = '${shiftingDate.day.toString().padLeft(2, '0')}/${shiftingDate.month.toString().padLeft(2, '0')}/${shiftingDate.year}';
  final endDateFormatted = '${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}';

  // Page styles
  final baseStyle = pw.TextStyle(fontSize: 11);
  final boldStyle = pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);
  final titleStyle = pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold);

  // helper to create clause lines with optional bold span(s)
  pw.Widget clauseLine(String numberAndTitle, String body, {List<pw.TextSpan>? boldSpans}) {
    // Build rich text: numberAndTitle bold, body normal but allow inline bold spans if provided
    final List<pw.TextSpan> spans = [];
    spans.add(pw.TextSpan(text: '$numberAndTitle', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)));
    spans.add(pw.TextSpan(text: body, style: baseStyle));
    // If boldSpans provided, we will inject them (simple approach: append after body)
    if (boldSpans != null && boldSpans.isNotEmpty) {
      spans.addAll(boldSpans);
    }
    return pw.RichText(text: pw.TextSpan(children: spans));
  }

  // Build the PDF with exact page breaks and spacing similar to images
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 20),
      build: (context) => [
        // PAGE 1 (title + intro + clauses 1-5)
        pw.Center(child: pw.Text('RENT AGREEMENT', style: titleStyle)),
        pw.SizedBox(height: 10),

        pw.Text('This Rent Agreement is made and executed on this $shiftingDateFormatted by and Between:', style: baseStyle),
        pw.SizedBox(height: 6),

        pw.Text('$ownerName, $ownerRelation, $ownerRelationPerson, Resident of $ownerAddress (hereinafter called the FIRST PARTY/LANDLORD).', style: boldStyle),
        pw.SizedBox(height: 10),

        pw.Text('                                                                          AND', style: baseStyle),
        pw.SizedBox(height: 10),

        pw.Text('$tenantName, $tenantRelation, $tenantRelationPerson, Resident of $tenantPermAddress (hereinafter called the SECOND PARTY/TENANT).', style: boldStyle),
        pw.SizedBox(height: 10),

        pw.Text('The expression of the both the parties shall mean and include their respective legal heirs, successors, Executors, administrators, representatives and legal assigns.', style: baseStyle),
        pw.SizedBox(height: 10),

        pw.Text('AND WHEREAS The first party agrees to let out', style: baseStyle),
        pw.Text(rentedAddress, style: boldStyle),
        pw.SizedBox(height: 6),

        pw.Text('And the tenant also has agreed to take on rent the said property on the following terms and conditions of this Rent Agreement:-', style: baseStyle),
        pw.SizedBox(height: 10),

        pw.Text('NOW THIS RENT AGREEMENT WITNESSETH AS UNDER:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 15),

        // Clauses 1 - 5 (page 1)
        pw.Text('1. That the tenancy in respect of the above said premises has been granted by the first party to the second party for a period of 11 months commencing from $shiftingDateFormatted to $endDateFormatted.', style: baseStyle),
        pw.SizedBox(height: 10),

        // Clause 2 with amounts bolded
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(text: '2. Rent: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.TextSpan(
                text: 'The Second Party has paid an advance rent of ',
                style: baseStyle,
              ),
              pw.TextSpan(text: formatAmount(monthlyRentRaw), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.TextSpan(text: '. The monthly rent shall be ', style: baseStyle),
              pw.TextSpan(text: formatAmount(monthlyRentRaw), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.TextSpan(text: ' and is payable in advance on or before the 7th day of each calendar month. ', style: baseStyle),
              pw.TextSpan(text: 'Rs. ${maintenanceRaw.isNotEmpty ? maintenanceRaw : '0'} /- ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.TextSpan(text: '( ' + (maintenanceRaw.isNotEmpty ? numberToWords(int.tryParse(maintenanceRaw.replaceAll(',', '')) ?? 0) + ' RUPEES )' : 'ZERO RUPEES )'), style: baseStyle),
              pw.TextSpan(text: ' maintenance charge to be charged extra and water and electricity charges to be charged as actual.', style: baseStyle),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
        // Clause 3 with amounts
        pw.RichText(
          text: pw.TextSpan(children: [
            pw.TextSpan(text: '3. Security Deposit: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: 'A security deposit of ', style: baseStyle),
            pw.TextSpan(text: formatAmount(securityRaw), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: ' is paid by the Second Party to the First Party in two installments: ', style: baseStyle),
            pw.TextSpan(text: formatAmount(installmentSecurityRaw), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: ' in this month and the remaining amount in the second month. This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.', style: baseStyle),
          ]),
        ),
        pw.SizedBox(height: 10),
        pw.Text('4. Usage: The rented premises shall be used for residential purposes only.', style: baseStyle),
        pw.SizedBox(height: 10),
        pw.Text('5. Electricity Charges: The Second Party/Tenant shall be responsible for paying electricity charges based on actual consumption. The rate per unit is INR 2 (TWO RUPEES) per unit and will be billed separately from the monthly rent.', style: baseStyle),
        pw.SizedBox(height: 10),
        pw.Text('6. Extension and Alterations: The tenancy can be extended if both parties agree. The Tenant cannot make any alterations to the rented property without the owner\'s written permission.', style: baseStyle),
        pw.SizedBox(height: 10),
        pw.Text('7. Damage and Handover: The Tenant must use the premises properly and not cause any damage; if damage occurs, the Tenant will be liable for the cost of repairs. Should the Tenant fail to hand over the premises by the due date, they will be responsible for damages and any legal consequences.', style: baseStyle),
        pw.SizedBox(height: 10),
        pw.Text('8. Inspection: The Tenant must allow the Landlord or their authorized agent to enter the premises for inspection or required work. This access should be at any reasonable time, ensuring both parties can manage the property effectively.', style: baseStyle),
        pw.SizedBox(height: 10),
        pw.Text('9. Taxes and Landlord\'s Liability: The Landlord is responsible for paying house and municipal taxes. However, the Landlord isn\'t liable for disputes between the Tenant and other residents, or for any loss, damage, or injury to the Tenant\'s personal belongings or to the Tenant and their guests.', style: baseStyle),
        pw.SizedBox(height: 10),
        pw.Text('10. Vacating & Termination: The Tenant must vacate the premises in its original condition, with whitewashing done before leaving. Either party may terminate the agreement by giving one month\'s written notice. If the tenancy is extended beyond the initial term, the monthly rent shall increase by 10%, unless both parties agree otherwise in writing.', style: baseStyle),

        // Force page break at end of this page only if content spills - but we'll continue and use NewPage manually before page 3
      ],
    ),
  );

  // PAGE 2 (clauses 6 - 13)
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 28),
      build: (context) => [
        pw.SizedBox(height: 60),
        pw.Text('11. Tenant Information: The Tenant and their visitors must provide valid ID and required details to the Owner before moving in. In case of disputes or misconduct, the Owner may evict the Tenant. The Owner also reserves the right to terminate the agreement with one month\'s notice before the 11-month term ends.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('12. Electricity & Water Charges: That the tenant shall pay the water and electricity charges as per actual consumption and this above payments will be excluding the monthly rent.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('13. Lock-in Period: The Second Party shall not terminate the lease within the first six months. If terminated within this period, the security deposit shall be forfeited. After the lock-in period, the Second Party must give one months\' notice to vacate, and the First Party must give the same notice to repossess the premises.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('14. Prohibited Activities: That the Second Party shall not do any illegal or unlawful activities in-the above said premises; if he does the same then the First Party will not be liable and responsible for the same. The Second Party shall not keep any unauthorized inflammable and explosive things in the said premises in any manner.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('15. Loan & Credit Application: That the Second Party will not apply for any loan, credit card at the above said address. If any loan will be pending against the Second Party, the First Party will not be liable and responsible for the same.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('16. Restriction on GST Registration: The Tenant is strictly prohibited from registering for GST using the Property\'s address. In the event that the Tenant obtains GST registration at the Property\'s address, the Owner shall bear no responsibility for any liabilities, penalties, or legal consequences arising therefrom. The Tenant shall be solely liable for any disputes, claims, or regulatory actions related to such unauthorized use. Furthermore, if the Owner receives any legal notice in this regard, the Owner and the Property shall not be held liable or obligated to make any payments or compliance on behalf of the Tenant.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('17. Repair and Cleanliness: The Tenant is responsible for minor, day-to-day repairs like fuses, tube lights, and water taps at their own expense. They must return the premises in the same condition as received. Additionally, the Tenant will keep the premises clean and hygienic, ensuring no nuisance is caused to others.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('18. Liability for Death or Suicide: In the event of any death, suicide, or injury occurring within the premises, the First Party/Landlord shall not be held responsible or liable for any claims arising therefrom.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('19. Unauthorized Occupants: No person other than the Second Party/Tenant shall occupy the premises without prior written consent from the First Party/Landlord. Unauthorized occupants will be considered a violation of this agreement and may result in termination.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('20. Non-Payment of Rent: If the Second Party/Tenant fails to pay the rent on time, the First Party/Landlord reserves the right to take legal action to recover the outstanding amount and repossess the premises.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('21. Living Relationships: The Second Party/Tenant shall not enter into or maintain a live-in relationship within the premises without notifying the First Party/Landlord. Any legal issues arising from such arrangements shall be the sole responsibility of the Second Party/Tenant, and the First Party/Landlord shall not be held liable.', style: baseStyle),
        pw.SizedBox(height: 15),
        pw.Text('22. Disputes: This clause establishes that any legal disagreements stemming from this agreement must exclusively be resolved by the courts located within Delhi or New Delhi. This ensures clarity regarding the specific legal forum and jurisdiction for dispute resolution, preventing litigation elsewhere.', style: baseStyle),
      ],
    ),
  );

  // PAGE 3 (clauses 14 - 24, witness, signatures)
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 28),
      build: (context) => [
        pw.SizedBox(height: 12),

        pw.Text('23. Legal Issues or Police Cases: If the Second Party/Tenant is involved in any police case or legal issue, the First Party/Landlord shall not be held responsible or liable for any consequences arising from such matters.', style: baseStyle),
        pw.SizedBox(height: 6),
        pw.Text('24. Mediator: Swaven Realty Pvt. Ltd. ("Mediator") acts solely as a facilitator between the Owner and the Tenant. It operates as a pure agent, collecting the first month\'s rent from the Tenant, deducting commission, and transferring the balance to the Owner. From the second month onward, the Tenant shall pay rent directly to the Owner. The Mediator holds no responsibility for any disputes between the parties after the initial transaction.', style: baseStyle),

        pw.SizedBox(height: 18),
        pw.Text('IN WITNESS WHEREOF, both the parties have signed this Deed of Agreement on the day, month and year first above written. That both the parties have read and understood the contents of this Agreement and have signed the same without any force or pressure from any side.', style: baseStyle),
        pw.SizedBox(height: 20),

        // Signatures section, two columns
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('FIRST PARTY / LANDLORD', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 6),
                pw.Text('Name: $ownerName', style: baseStyle),
                pw.Text('Aadhar No: $ownerAadhar', style: baseStyle),
                pw.SizedBox(height: 18),
                pw.Text('Signature: ____________________________', style: baseStyle),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('SECOND PARTY / TENANT', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 6),
                pw.Text('Name: $tenantName', style: baseStyle),
                pw.Text('Aadhar No: $tenantAadhar', style: baseStyle),
                pw.SizedBox(height: 18),
                pw.Text('Signature: ____________________________', style: baseStyle),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 30),

        pw.Text('WITNESS:-', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Signature: ____________________________', style: baseStyle),
            pw.Text('Signature: ____________________________', style: baseStyle),
          ],
        ),
      ],
    ),
  );

  // PAGE 4 - SHO letter (rent verification)
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 28),
      build: (context) => [
        pw.Text('To,', style: baseStyle),
        pw.Text('Respected SHO Sir,', style: baseStyle),
        pw.Text('Police Station - Fatehpur Beri,', style: baseStyle),
        pw.Text('South Delhi,', style: baseStyle),
        pw.SizedBox(height: 12),
        pw.Text('Subject: Rent Verification Request', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.SizedBox(height: 12),

        pw.RichText(
          text: pw.TextSpan(children: [
            pw.TextSpan(text: 'Sir,\n\n', style: baseStyle),
            pw.TextSpan(text: 'I ', style: baseStyle),
            pw.TextSpan(text: tenantName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: ', $tenantRelation $tenantRelationPerson residing at ', style: baseStyle),
            pw.TextSpan(text: rentedAddress, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: ' have been living here as a tenant since ', style: baseStyle),
            pw.TextSpan(text: shiftingDateFormatted, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: '. The owner of the property is ', style: baseStyle),
            pw.TextSpan(text: ownerName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: ', $ownerRelation $ownerRelationPerson residing at ', style: baseStyle),
            pw.TextSpan(text: ownerAddress, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.TextSpan(text: '.\n', style: baseStyle),
          ]),
        ),
        pw.SizedBox(height: 6),

        pw.Text('My permanent address is: $tenantPermAddress', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Mobile Number: $tenantMobile', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        pw.Text('Job Details/Designation: ________________________________________________', style: baseStyle),
        pw.SizedBox(height: 18),

        pw.Text('I fully understand and agree that all the information provided by me in this Rent Verification Form is true and correct. In case any information is found to be false, misleading, or incomplete, or if I am involved in any kind of illegal activity during my stay at the rented property, then the property owner, mediator, broker, or the property itself shall not be held responsible or liable in any legal, financial, or criminal proceedings. I, the tenant, will be solely and fully responsible for any consequences arising from such actions, and I shall bear all legal liabilities, penalties, or prosecution that may arise in the future.', style: baseStyle),
        pw.SizedBox(height: 20),

        pw.Text('Thank you for your attention to this matter.', style: baseStyle),
        pw.SizedBox(height: 12),
        pw.Text('Sincerely,', style: baseStyle),
        pw.SizedBox(height: 6),
        pw.Text('Name: $tenantName', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('Aadhar No: $tenantAadhar', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/agreement_${data['id'] ?? 'unknown'}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}
