import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> generateAgreementPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  // Format shifting dates
  final shiftingDate = DateTime.parse(data['shifting_date']);
  final endDate = DateTime(shiftingDate.year, shiftingDate.month + 11, shiftingDate.day);

  pdf.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(24),
      build: (context) => [
        pw.Center(
          child: pw.Text("RENT AGREEMENT",
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 16),

        pw.Text(
          "This Rent Agreement is made and executed on this ${data['current_dates'].toString().split('T')[0]} by and Between:",
        ),
        pw.SizedBox(height: 8),

        // Owner
        pw.Text(
          "${data['owner_name']} , ${data['owner_relation']} ${data['relation_person_name_owner']}, "
              "Resident of ${data['parmanent_addresss_owner']} (hereinafter called the FIRST PARTY/LANDLORD).",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),

        pw.Text("AND"),
        pw.SizedBox(height: 12),

        // Tenant
        pw.Text(
          "${data['tenant_name']} , ${data['tenant_relation']} ${data['relation_person_name_tenant']}, "
              "Resident of ${data['permanent_address_tenant']} (hereinafter called the SECOND PARTY/TENANT).",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),

        pw.SizedBox(height: 20),
        pw.Text("The expression of the both the parties shall mean and include their respective legal heirs..."),

        pw.SizedBox(height: 20),
        pw.Text("AND WHEREAS The first party agrees to let out"),
        pw.Text("${data['rented_address']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

        pw.SizedBox(height: 20),
        pw.Text("NOW THIS RENT AGREEMENT WITNESSETH AS UNDER:",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

        // --- CLAUSES --- //
        pw.Text(
            "1. That the tenancy... commencing from ${shiftingDate.day}/${shiftingDate.month}/${shiftingDate.year} "
                "to ${endDate.day}/${endDate.month}/${endDate.year}."),
        pw.Text(
            "2. Rent: The monthly rent shall be Rs. ${data['monthly_rent']} /- ... ${data['maintaince']} maintenance charge."),
        pw.Text(
            "3. Security Deposit: A security deposit of Rs. ${data['securitys']} /- has been paid..."),

        // Continue with static clauses 4–24 (word-for-word from your template)
        // Only replace with dynamic values where needed (like rent, security, maintenance, etc.)

        pw.SizedBox(height: 20),
        pw.Text("IN WITNESS WHEREOF, both the parties have signed this Deed of Agreement..."),

        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(children: [
              pw.Text("FIRST PARTY / LANDLORD"),
              pw.Text("Name: ${data['owner_name']}"),
              pw.Text("Aadhar No: ${data['owner_addhar_no']}"),
              pw.SizedBox(height: 20),
              pw.Text("Signature: ____________"),
            ]),
            pw.Column(children: [
              pw.Text("SECOND PARTY / TENANT"),
              pw.Text("Name: ${data['tenant_name']}"),
              pw.Text("Aadhar No: ${data['tenant_addhar_no']}"),
              pw.SizedBox(height: 20),
              pw.Text("Signature: ____________"),
            ]),
          ],
        ),

        pw.SizedBox(height: 40),
        pw.Text("WITNESS:-"),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Signature: __________"),
            pw.Text("Signature: __________"),
          ],
        ),

        pw.SizedBox(height: 40),
        pw.Text("To,"),
        pw.Text("Respected SHO Sir,"),
        pw.Text("Police Station - Fatehpur Beri, South Delhi,"),
        pw.SizedBox(height: 12),
        pw.Text("Subject: Rent Verification Request"),

        pw.SizedBox(height: 12),
        pw.Text(
          "Sir,\n\nI ${data['tenant_name']} , ${data['tenant_relation']} ${data['relation_person_name_tenant']} "
              "residing at ${data['rented_address']} have been living here as a tenant since ${shiftingDate.day}/${shiftingDate.month}/${shiftingDate.year}. "
              "The owner of the property is ${data['owner_name']}, ${data['owner_relation']} ${data['relation_person_name_owner']} "
              "residing at ${data['parmanent_addresss_owner']}.",
        ),
        pw.SizedBox(height: 12),
        pw.Text("My permanent address is: ${data['permanent_address_tenant']}"),
        pw.Text("Mobile Number: ${data['tenant_mobile_no']}"),
        pw.SizedBox(height: 20),
        pw.Text("Sincerely,"),
        pw.Text("Name: ${data['tenant_name']}"),
        pw.Text("Aadhar No: ${data['tenant_addhar_no']}"),
      ],
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/agreement_${data['id']}.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}
