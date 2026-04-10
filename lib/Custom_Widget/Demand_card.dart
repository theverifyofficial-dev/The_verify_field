import 'package:flutter/material.dart';
import '../model/demand_model.dart';
import 'Demand_pin_button.dart';
import 'Demand_utilities.dart';

class DemandCard extends StatelessWidget {
  final TenantDemandModel d;
  final VoidCallback onTap;
  final Widget? PinList; // 👈 NEW
  final bool isField; // 👈 add this
  final String type; // 👈 NEW

  const DemandCard({
    super.key,
    required this.d,
    required this.onTap,
    this.isField = false,
    this.PinList,
    required this.type, // 👈 REQUIRED
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent = d.mark == "1";
    final isWeb = d.reference.toLowerCase() == "website";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    Text(
                      "ID-${d.id}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (isUrgent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "URGENT",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                    if (isWeb) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Website",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]

                  ],
                ),


                Spacer(),

                Text(
                  DemandUtils.formatPriceRange(d.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 5,),

                if(isField)
                PinList ??
                    PinListButton(
                      pId: d.id,
                      initialState: d.isPinned,
                      type: type,
                    ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔥 NAME
            Text(
              d.tname,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 10),

            if (d.buyRent.isNotEmpty || d.bhk.isNotEmpty) ...[

              Row(
                children: [
                  if (d.buyRent.isNotEmpty) _chip(d.buyRent),

                  if (d.buyRent.isNotEmpty && d.bhk.isNotEmpty)
                    const SizedBox(width: 8),

                  if (d.bhk.isNotEmpty) _chip2(d.bhk),
                ],
              ),

              const SizedBox(height: 12),
            ],

            /// 🔥 LOCATION
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.black),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    d.location.isNotEmpty ?
                    d.location : "Sultanpur",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),

                Spacer(),

                Text(
                  "by ${(d.assignedFieldworkerName?.trim().isNotEmpty ?? false)
                      ? d.assignedFieldworkerName
                      : (d.adminName ?? "--")}",
                    style: const TextStyle(color: Colors.black,fontStyle: FontStyle.italic,fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔥 DATE + TIME
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.black),
                const SizedBox(width: 6),
                    Text(d.formattedDate,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    final isRent = text.toLowerCase() == "rent";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isRent ? const Color(0xFF7C3AED) : Colors.orange, // purple / cyan
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white, // 🔥 better contrast
        ),
      ),
    );
  }

  Widget _chip2(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
        const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color:
          Color(0xFF334155),
        ),
      ),
    );
  }

}