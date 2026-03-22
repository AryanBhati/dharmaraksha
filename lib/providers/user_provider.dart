import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/mock_data.dart';

class UserProvider extends ChangeNotifier {
  AppUser _user =
      MockDataService.getUserById('u01') ?? MockDataService.users.first;

  AppUser get user => _user;

  void updateProfile(
      {required String name, required String email, required String phone}) {
    _user = _user.copyWith(name: name, email: email, phone: phone);
    notifyListeners();
  }

  void toggleSaveLawyer(String lawyerId) {
    final updated = List<String>.from(_user.savedLawyerIds);
    if (updated.contains(lawyerId)) {
      updated.remove(lawyerId);
    } else {
      updated.add(lawyerId);
    }
    _user = _user.copyWith(savedLawyerIds: updated);
    notifyListeners();
  }

  bool isLawyerSaved(String lawyerId) =>
      _user.savedLawyerIds.contains(lawyerId);

  void incrementConsultationCount() {
    _user = _user.copyWith(
        consultationsCompleted: _user.consultationsCompleted + 1);
    notifyListeners();
  }
}
