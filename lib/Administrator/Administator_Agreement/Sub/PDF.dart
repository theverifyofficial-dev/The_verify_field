import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

Future<File> generateAgreementPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  final shiftingDate = DateTime.parse(data['shifting_date']);
  final endDate = DateTime(shiftingDate.year, shiftingDate.month + 11, shiftingDate.day);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => [
        pw.Center(
          child: pw.Text("RENT AGREEMENT",
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 12),

        pw.Text(
          "This Rent Agreement is made and executed on this ${data['current_dates'].toString().split('T')[0]} by and Between:",
        ),
        pw.SizedBox(height: 6),

        pw.Text(
          "${data['owner_name']}, ${data['owner_relation']} ${data['relation_person_name_owner']}, Resident of ${data['parmanent_addresss_owner']}  (hereinafter called the FIRST PARTY/LANDLORD).",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.Text("AND"),
        pw.SizedBox(height: 12),

        pw.Text(
          "${data['tenant_name']}, ${data['tenant_relation']} ${data['relation_person_name_tenant']}, Resident of ${data['permanent_address_tenant']} (hereinafter called the SECOND PARTY/TENANT).",
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),

        pw.SizedBox(height: 16),
        pw.Text(
          "The expression of the both the parties shall mean and include their respective legal heirs, successors, Executors, administrators, representatives and legal assigns.",
        ),

        pw.SizedBox(height: 16),
        pw.Text("AND WHEREAS The first party agrees to let out"),
        pw.Text("${data['rented_address']}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

        pw.SizedBox(height: 12),
        pw.Text(
            "And the tenant also has agreed to take on rent the said property on the following terms and conditions of this Rent Agreement:-"),
        pw.SizedBox(height: 16),

        pw.Text("NOW THIS RENT AGREEMENT WITNESSETH AS UNDER:",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),

        // CLAUSES (copied from your PDF template exactly)
        pw.Text("1. That the tenancy in respect of the above said premises has been granted by the first party to the second party for a period of 11 months commencing from ${shiftingDate.day}/${shiftingDate.month}/${shiftingDate.year} to ${endDate.day}/${endDate.month}/${endDate.year}."),
        pw.SizedBox(height: 6),
        pw.Text("2. Rent: The Second Party has paid an advance rent of Rs. ${data['monthly_rent']} /-. The monthly rent shall be Rs. ${data['monthly_rent']} /- and is payable in advance on or before the 7th day of each calendar month. Rs. ${data['maintaince']} maintenance charge to be charged extra and water and electricity charges to be charged as actual."),
        pw.SizedBox(height: 6),
        pw.Text("3. Security Deposit: A security deposit of Rs. ${data['securitys']} /- is paid by the Second Party to the First Party in two installments Rs: ${data['installment_security_amount']} in this month and the remaining amount in the second month. This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges."),
        pw.SizedBox(height: 6),
        pw.Text("4. Usage: The rented premises shall be used for residential purposes only."),
        pw.Text("5. Electricity Charges: The Second Party/Tenant shall be responsible for paying electricity charges based on actual consumption."),
        pw.Text("6. Extension and Alterations: The tenancy can be extended if both parties agree. The Tenant cannot make alterations without written permission."),
        pw.Text("7. Damage and Handover: The Tenant must use the premises properly and hand it over in the same condition, else liable for damages."),
        pw.Text("8. Inspection: The Tenant must allow the Landlord reasonable access for inspection/repair."),
        pw.Text("9. Taxes and Landlord’s Liability: The Landlord is responsible for house/municipal taxes but not for disputes or tenant’s belongings."),
        pw.Text("10. Vacating & Termination: Either party may terminate with one month’s notice. On extension, rent increases by 10%."),
        pw.Text("11. Tenant Information: Tenant & visitors must provide ID. Owner can evict in case of disputes."),
        pw.Text("12. Electricity & Water Charges: Tenant shall pay actuals, excluding rent."),
        pw.Text("13. Lock-in Period: Tenant shall not terminate within 6 months, else security forfeited."),
        pw.Text("14. Prohibited Activities: No illegal or inflammable activities allowed."),
        pw.Text("15. Loan & Credit Application: Tenant shall not apply for loans/credit using this address."),
        pw.Text("16. Restriction on GST Registration: Tenant strictly prohibited from GST registration using this address."),
        pw.Text("17. Repair and Cleanliness: Tenant responsible for minor repairs and keeping premises hygienic."),
        pw.Text("18. Liability for Death or Suicide: Owner not responsible."),
        pw.Text("19. Unauthorized Occupants: No third party occupation without consent."),
        pw.Text("20. Non-Payment of Rent: Owner reserves right to legal action."),
        pw.Text("21. Living Relationships: No live-in without informing owner."),
        pw.Text("22. Disputes: Jurisdiction only in Delhi."),
        pw.Text("23. Legal Issues or Police Cases: Owner not responsible."),
        pw.Text("24. Mediator: Swaven Realty Pvt. Ltd. acts only as facilitator for first month’s rent."),

        pw.SizedBox(height: 16),
        pw.Text("IN WITNESS WHEREOF, both the parties have signed this Deed of Agreement on the day, month and year first above written."),
        pw.SizedBox(height: 20),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("FIRST PARTY / LANDLORD"),
                pw.Text("Name: ${data['owner_name']}"),
                pw.Text("Aadhar No: ${data['owner_addhar_no']}"),
                pw.SizedBox(height: 20),
                pw.Text("Signature: __________"),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("SECOND PARTY / TENANT"),
                pw.Text("Name: ${data['tenant_name']}"),
                pw.Text("Aadhar No: ${data['tenant_addhar_no']}"),
                pw.SizedBox(height: 20),
                pw.Text("Signature: __________"),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 30),
        pw.Text("WITNESS:-"),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("Signature: __________"),
            pw.Text("Signature: __________"),
          ],
        ),

        // SHO Letter on new page
        pw.NewPage(),
        pw.Text("To,"),
        pw.Text("Respected SHO Sir,"),
        pw.Text("Police Station - Fatehpur Beri, South Delhi,"),
        pw.SizedBox(height: 12),
        pw.Text("Subject: Rent Verification Request", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 12),
        pw.Text(
          "Sir,\n\nI ${data['tenant_name']}, ${data['tenant_relation']} ${data['relation_person_name_tenant']} residing at ${data['rented_address']} have been living here as a tenant since ${shiftingDate.day}/${shiftingDate.month}/${shiftingDate.year}. "
              "The owner of the property is ${data['owner_name']}, ${data['owner_relation']} ${data['relation_person_name_owner']} residing at ${data['parmanent_addresss_owner']}.\n"
              "My permanent address is: ${data['permanent_address_tenant']}\n"
              "Mobile Number: ${data['tenant_mobile_no']}\n\n"
              "Job Details/Designation: ________________________________________________\n\n"
              "I fully understand and agree that all the information provided by me in this Rent Verification Form is true and correct. In case any information is found to be false, misleading, or incomplete, or if I am involved in any kind of illegal activity during my stay, "
              "then the owner/mediator/property shall not be held responsible. I shall be solely liable for any legal or financial consequences.",
        ),
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
