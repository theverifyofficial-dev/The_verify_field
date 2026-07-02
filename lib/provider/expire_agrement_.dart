import 'package:flutter/material.dart';
import '../Rent Agreement/Expire_agreement.dart';
import '../model/Expire_Agreement.dart';

class ExpireAgreementController extends ChangeNotifier {
  List<ExpireAgreementData> agreements = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadExpiredAgreements(String fieldWorkerNumber) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await AgreementApiService.fetchExpiredAgreements(
        fieldWorkerNumber: fieldWorkerNumber,
      );
      agreements = result.data; // ✅ now works — result is ExpireAgreementResponse
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}