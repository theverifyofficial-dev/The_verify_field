import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class RentAgreementPage extends StatefulWidget {
  @override
  _RentAgreementPageState createState() => _RentAgreementPageState();
}

class _RentAgreementPageState extends State<RentAgreementPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController rentController = TextEditingController();

  Future<Uint8List> _generatePdf(String name, String address, String rent) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
           pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text("RENT AGREEMENT", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
              ),
              pw.SizedBox(height: 20),
              /*pw.Text(
                "This Rent Agreement is made on this day between $name (hereinafter referred to as the 'Tenant') residing at $address, "
                    "and the Landlord. Both parties have agreed to the following terms and conditions: ",
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(fontSize: 14),
              ),*/


              pw.RichText(
                text: pw.TextSpan(
                  style: pw.TextStyle(fontSize: 12),
                  children: [
                    pw.TextSpan(text: 'This Rent Agreement is made and executed on this 25/04/2025 by and Between: '),
                    pw.TextSpan(
                      text: "$name (C/O) VIPIN GUPTA Resident  H NO-100,KH NO-548,FLAT NO-3,SULTANPUR COLONY,SOUTH DELHI DELHI 110030, "
                          ,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: ' (hereinafter called the FIRST PARTY/LANDLORD).'),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text("AND", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
              ),
              pw.SizedBox(height: 10),

              pw.RichText(
                text: pw.TextSpan(
                  style: pw.TextStyle(fontSize: 12),
                  children: [
                    pw.TextSpan(text: ''),
                    pw.TextSpan(
                      text: "MAYANK YADAV  (S/O) SANJAY YADAV Resident L-1,2295/14,SANGAM VIHAR,PUSHPA BHAWAN S.O PUSHPA BHAWAN, P.O PUSHPA BHAWAN ,SOUTH DELHI DELHI 110062, "
                      ,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.TextSpan(text: ' (hereinafter called the second party/tenant).'),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "The expression of the both the parties shall mean and include their respective legal heirs, successors, Executors, administrators, representatives and legal assigns."
                ,
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "AND WHEREAS  the first party agrees to let out "
                ,
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "3BHK, H NO-100,FLAT NO-4,4TH FLOOR,KH NO-548 ,PEER BABA K SAMNE WALI GALI SULTANPUR,NEW DELHI,DELHI 110030"
                ,
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              //pw.SizedBox(height: 10),
              pw.Text(
                "And the tenant also has agreed to take on rent the said property on the following terms and conditions of this Rent Agreement:-"
                ,
                textAlign: pw.TextAlign.justify,
                style: pw.TextStyle(fontSize: 12),
              ),

              pw.SizedBox(height: 20),
              pw.Text("NOW THIS RENT AGREEMENT WITNESSETH AS UNDER:", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("1. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(text: 'That the tenancy in respect of the above said premises has been granted by the first party to the second party for a period of '),
                          pw.TextSpan(
                            text: "11 months ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'commencing from '),
                          pw.TextSpan(
                            text: "1/5/2025 to 31/3/2026.",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("2. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Rent: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'The Second Party has paid an advance rent of Rs. '),
                          pw.TextSpan(
                            text: "21,000/- ( Twenty One Thousand  Only). ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'The monthly rent shall be Rs '),
                          pw.TextSpan(
                            text: "21,000/- ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'and is payable in advance on or before the 7th day of each calendar month. '),
                          pw.TextSpan(
                            text: "Rs 500/- ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'maintenance charge to be charged extra and water and electricity  charges to be charged as actual. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("3. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Security Deposit: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'A security deposit of Rs. '),
                          pw.TextSpan(
                            text: "21,000/- ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("4. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Usage: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'The rented premises shall be used for '),
                          pw.TextSpan(
                            text: "residential ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'purposes only.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("5. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Electricity Charges: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'The Second Party/Tenant shall be responsible for paying electricity charges based on actual consumption. The rate per unit is INR '),
                          pw.TextSpan(
                            text: "[ as per govt. Unit.] ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'and will be billed separately from the monthly rent.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("6. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Extension: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'The tenancy period may be extended subject to mutual agreement by both parties.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("7. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Alterations: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the second party will not make any addition or alteration in the existing rented structure without the written permission of the owner.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("8. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Damage: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the tenant shall use the said premises properly and shall not cause any damage to the said premises in any manner whatsoever, In case any such damage is detected the tenant shall be liable to pay for the damages.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("9. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Inspection: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the tenant shall permit the Landlord, his successors, agent etc,to inspect the tenanted premises at all reasonable hours.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("10. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Taxes: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the landlord shall be liable to pay house-tax and other Municipal Taxes as levied by the local authorities.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("11. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Vacating Premises: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'Upon the expiry of the tenancy, the Second Party shall hand over the premises in the same condition as when received. If the agreement is extended, the rent shall increase by 10% of the initial rent amount. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("12. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Tenant Information: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: "The Tenant and their family members and friends must provide proper identification and required information to the Owner before occupying the property. In case of any disputes or issues, including fighting, between the Tenant and Owner, the Owner has the right to evict the Tenant and empty the flat. Additionally, the Owner reserves the right to terminate the agreement and empty the flat before 11 months, with one month's notice to the Tenant. "),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("13. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Handover: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That in case the tenant fails to handover the tenancy premises to the Landlord on the due date then he shall be liable for the damages/legal procedure. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("14. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Termination Notice: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the tenancy can be terminated by either party on giving one month’s notice in advance to the other party. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("14. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Termination Notice: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the tenancy can be terminated by either party on giving one month’s notice in advance to the other party. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("15. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Electricity & Water Charges: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the tenant shall pay the water and electricity charges as per actual consumption and this above payments will be excluding the monthly rent. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("16. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Lock-in Period: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: "The Second Party shall not terminate the lease within the first six months. If terminated within this period, the security deposit shall be forfeited. After the lock-in period, the Second Party must give one month's notice to vacate, and the First Party must give the same notice to repossess the premises. "),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("17. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Prohibited Activities: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the Second Party shall not do any illegal or unlawful activities in-the above said premises if he does the same then the First Party will not be liable and responsible for the same. The Second Party shall not Keep any unauthorized inflammable and explosive things in the said premises in any manner. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("18. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Premises for Inspection: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the Second Party will permit the First Party or his/her/their duly authorized agent to enter into the said premises for inspection or required work at any reasonable time. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("19. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Loan & Credit Application: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the Second Party will not apply for any loan, credit card at the above said address. If any loan will be pending against the Second Party, the First Party will not be liable and responsible for the same. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("20. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Restriction on GST Registration: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'The Tenant is strictly prohibited from registering for GST using the Property’s address. In the event that the Tenant obtains GST registration at the Property’s address, the Owner shall bear no responsibility for any liabilities, penalties, or legal consequences arising therefrom. The Tenant shall be solely liable for any disputes, claims, or regulatory actions related to such unauthorized use. Furthermore, if the Owner receives any legal notice in this regard, the Owner and the Property shall not be held liable or obligated to make any payments or compliance on behalf of the Tenant. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("21. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Repairs: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the tenant shall maintain the day to day minor repair i.e fuses of bulbs, tube lights, water taps, etc at his own cost and expenses, and Tenant shall return the premises in the same condition as given by the Landlord. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("22. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Landlord’s Liability: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: "The Landlord shall not be responsible for Any disputes, arguments,living relationship or quarrels arising between the Tenant and other residents. Any loss or damage to the Tenant's personal belongings.Any injury or harm caused to the Tenant or their guests. "),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("23. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Cleanliness: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: "That the Lessee shall keep the said premises in clean and hygienic condition and shall not do or cause to be done any act which may be nuisance to others. "),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("24. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Liability for Death or Suicide: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'In the event of any death, suicide, or injury occurring within the premises, the First Party/Landlord shall not be held responsible or liable for any claims arising therefrom. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("25. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Unauthorized Occupants: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'No person other than the Second Party/Tenant shall occupy the premises without prior written consent from the First Party/Landlord. Unauthorized occupants will be considered a violation of this agreement and may result in termination. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("26. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Non-Payment of Rent: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'If the Second Party/Tenant fails to pay the rent on time, the First Party/Landlord reserves the right to take legal action to recover the outstanding amount and repossess the premises. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("27. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Living Relationships: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'The Second Party/Tenant shall not enter into or maintain a live-in relationship within the premises without notifying the First Party/Landlord. Any legal issues arising from such arrangements shall be the sole responsibility of the Second Party/Tenant, and the First Party/Landlord shall not be held liable. '),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("28. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Disputes: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'Any disputes arising from this agreement shall fall under the jurisdiction of Delhi/New Delhi courts only.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("29. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Legal Issues or Police Cases: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'If the Second Party/Tenant is involved in any police case or legal issue, the First Party/Landlord shall not be held responsible or liable for any consequences arising from such matters.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("30. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Signed: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'That the present agreement has been executed under the free will and consent of both the parties and neither party has signed under any pressure, threat, coercion etc.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("31. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Mediator: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'SWAVEN REALTY PVT LTD (VERIFY REAL-ESTATE & SERVICES) is solely a mediator between the Owner and Tenant. The company and its affiliates are not responsible for any disputes or issues that may arise between them.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text("31. ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold,color: PdfColors.white)),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          /*pw.TextSpan(
                            text: "Mediator: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),*/
                          pw.TextSpan(text: 'IN WITNESS WHEREOF, both the parties have signed this Deed of Agreement on the day, month and year first above written.That both the parties have read and understood the contents of this Agreement and have signed the same without any force or pressure from any side.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),


              pw.SizedBox(height: 30),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [

                  /*pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "WITNESS ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                          ),
                          *//*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        *//*],
                      ),
                    ),
                  ),

                  pw.SizedBox(width: 100),*/
                  pw.SizedBox(width: 30),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "WITNESS:- ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          /*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        */],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text('1. ',style: pw.TextStyle(color: PdfColors.white)),
                  pw.SizedBox(width: 300),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Name: KUMARI NISHA ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          /*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        */],
                      ),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text('1. '),
                  pw.SizedBox(width: 300),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          /*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        */],
                      ),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text('1. ',style: pw.TextStyle(color: PdfColors.white)),
                  pw.SizedBox(width: 300),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "FIRST PARTY/OWNER ",
                          ),
                          /*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        */],
                      ),
                    ),
                  ),
                ],
              ),


              pw.SizedBox(height: 100),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text('1. ',style: pw.TextStyle(color: PdfColors.white)),
                  pw.SizedBox(width: 300),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Name: KUMARI NISHA ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          /*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        */],
                      ),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text('2. '),
                  pw.SizedBox(width: 300),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          /*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        */],
                      ),
                    ),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(width: 20),
                  pw.Text('1. ',style: pw.TextStyle(color: PdfColors.white)),
                  pw.SizedBox(width: 300),
                  pw.Expanded(
                    child: pw.RichText(
                      text: pw.TextSpan(
                        style: pw.TextStyle(fontSize: 11),
                        children: [
                          pw.TextSpan(
                            text: "SECOND PARTY/TENANT ",
                          ),
                          /*pw.TextSpan(
                            text: "Aadhar Card No:529006306632 ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.TextSpan(text: 'is paid by the Second Party to the First Party  in this month.This deposit is interest-free and shall be adjustable/refundable at the time of termination of this Rent Agreement after accounting for any dues, damages, remaining rent, electricity bill, cleaning, and other maintenance charges.'),
                        */],
                      ),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  void _handleGeneratePdf() async {
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final rent = rentController.text.trim();

    if (name.isEmpty || address.isEmpty || rent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final pdfData = await _generatePdf(name, address, rent);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rent Agreement Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Tenant Name"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Tenant Address"),
            ),
            TextField(
              controller: rentController,
              decoration: InputDecoration(labelText: "Monthly Rent"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleGeneratePdf,
              child: Text("Generate Rent Agreement PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
