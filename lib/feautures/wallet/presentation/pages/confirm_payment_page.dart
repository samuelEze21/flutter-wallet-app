import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/transfer_provider.dart';
import '../../../../core/providers/deposit_provider.dart';
import '../../../../core/providers/withdrawal_provider.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key});

  @override
  _ConfirmPaymentPageState createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment(Map<String, dynamic> args) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transferProvider = Provider.of<TransferProvider>(context, listen: false);
    final depositProvider = Provider.of<DepositProvider>(context, listen: false);
    final withdrawalProvider = Provider.of<WithdrawalProvider>(context, listen: false);
    final password = _passwordController.text.trim();
    final type = args['type'] as String;
    final amount = args['amount'] as double;
    final userId = authProvider.userId!;
    final token = authProvider.token!;

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your password';
        _isLoading = false;
      });
      return;
    }

    bool success = false;
    switch (type) {
      case 'transfer':
        final walletAddress = args['walletAddress'] as String;
        success = await transferProvider.confirmTransfer(userId, token, amount, walletAddress, password);
        _errorMessage = transferProvider.errorMessage;
        break;
      case 'deposit':
        final accountNumber = args['accountNumber'] as String;
        success = await depositProvider.confirmDeposit(userId, token, amount, accountNumber, password);
        _errorMessage = depositProvider.errorMessage;
        break;
      case 'withdrawal':
        final accountNumber = args['accountNumber'] as String;
        success = await withdrawalProvider.confirmWithdrawal(userId, token, amount, accountNumber, password);
        _errorMessage = withdrawalProvider.errorMessage;
        break;
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$type Successful!',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/wallet-home');
      });
    } else {
      setState(() {
        _errorMessage ??= 'Transaction failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final type = args['type'] as String;
    final amount = args['amount'] as double;
    final identifier = args['walletAddress'] ?? args['accountNumber'] as String;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF003087)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Confirm $type',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Amount: ₦${amount.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            type == 'transfer' ? 'To: $identifier' : 'Account: $identifier',
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF003087)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () => _confirmPayment(args),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A90E2).withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                  : Text(
                                'Confirm $type',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}