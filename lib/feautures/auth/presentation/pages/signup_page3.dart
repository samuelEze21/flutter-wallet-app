import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/auth_service.dart';

class SignupStep3 extends StatefulWidget {
  const SignupStep3({super.key});

  @override
  _SignupStep3State createState() => _SignupStep3State();
}

class _SignupStep3State extends State<SignupStep3> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A90E2),
                  Color(0xFF003087),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Image.asset(
                  'assets/images/fast_ego_logo.jpg',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign Up - Step 3 of 3',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF003087),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (authProvider.errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Text(
                                authProvider.errorMessage!,
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis, // Handle long error messages
                              ),
                            ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.poppins(),
                              errorText: authProvider.emailError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) {
                              authProvider.setEmail(value);
                            },
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<List<String>>(
                            future: AuthService().getSecurityQuestions(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text(
                                  'Error loading security questions',
                                  style: GoogleFonts.poppins(color: Colors.red),
                                );
                              }
                              if (snapshot.hasData) {
                                return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Security Question',
                                    labelStyle: GoogleFonts.poppins(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                  ),
                                  items: snapshot.data!.map((question) {
                                    return DropdownMenuItem<String>(
                                      value: question,
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.7, // Constrain dropdown item width
                                        child: Text(
                                          question,
                                          style: GoogleFonts.poppins(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    authProvider.setSecurityQuestion(value!);
                                  },
                                );
                              }
                              return Text(
                                'No security questions available',
                                style: GoogleFonts.poppins(color: Colors.red),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Answer',
                              labelStyle: GoogleFonts.poppins(),
                              errorText: authProvider.securityAnswerError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) {
                              authProvider.setSecurityAnswer(value);
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Back',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF003087),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded( // Use Expanded instead of Flexible for stricter space allocation
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.5, // Limit button width
                                  ),
                                  child: GestureDetector(
                                    onTapDown: (_) {
                                      _animationController.reverse();
                                    },
                                    onTapUp: (_) async {
                                      _animationController.forward();
                                      final isValid = await authProvider.validateStep3();
                                      if (isValid) {
                                        final user = await authProvider.signup();
                                        if (user != null) {
                                          authProvider.clear();
                                          Navigator.pushReplacementNamed(context, '/wallet-home');
                                        }
                                      }
                                    },
                                    child: AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: 1 - (_animationController.value * 0.05),
                                          child: ElevatedButton(
                                            onPressed: null, // Logic handled in GestureDetector
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Further reduced padding
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              elevation: 5,
                                              shadowColor: Colors.black.withOpacity(0.3),
                                              backgroundColor: Colors.transparent,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF4A90E2),
                                                    Color(0xFF003087),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                              child: authProvider.isLoading
                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                  : Text(
                                                'Continue',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16, // Slightly reduced font size
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}