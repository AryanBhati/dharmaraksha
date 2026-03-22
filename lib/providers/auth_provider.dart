import 'package:flutter/material.dart';

enum UserType { client, lawyer }

enum AuthState { unauthenticated, onboardingComplete, authenticated }

class AuthProvider extends ChangeNotifier {
  AuthState _authState = AuthState.unauthenticated;
  UserType _userType = UserType.client;
  bool _onboardingComplete = false;
  String _phoneNumber = '';
  String _userName = '';

  AuthState get authState => _authState;
  UserType get userType => _userType;
  bool get onboardingComplete => _onboardingComplete;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  String get phoneNumber => _phoneNumber;
  String get userName => _userName;

  void completeOnboarding() {
    _onboardingComplete = true;
    _authState = AuthState.onboardingComplete;
    notifyListeners();
  }

  void setUserType(UserType type) {
    _userType = type;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  /// Mock OTP verification — always succeeds
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Mock client registration
  Future<void> registerClient({
    required String name,
    required String phone,
    String? email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _userName = name;
    _phoneNumber = phone;
    _authState = AuthState.authenticated;
    notifyListeners();
  }

  /// Mock lawyer registration (KYC)
  Future<void> registerLawyer({
    required String name,
    required String phone,
    required String barCouncilId,
    required List<String> specializations,
    required int yearsExperience,
    required List<String> languages,
    required double chatRate,
    required double callRate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _userName = name;
    _phoneNumber = phone;
    _authState = AuthState.authenticated;
    notifyListeners();
  }

  /// Mock login for returning users
  Future<void> login(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _phoneNumber = phone;
    _authState = AuthState.authenticated;
    _userName = 'Returning User';
    notifyListeners();
  }

  void logout() {
    _authState = AuthState.onboardingComplete;
    _userName = '';
    _phoneNumber = '';
    notifyListeners();
  }
}
