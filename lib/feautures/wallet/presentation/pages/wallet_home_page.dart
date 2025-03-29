import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/balance_provider.dart'; // Updated import

class WalletHomePage extends StatefulWidget {
  const WalletHomePage({super.key});

  @override
  _WalletHomePageState createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();

    // Fetch balance when the page loads
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    balanceProvider.fetchBalance(authProvider.userId ?? 'mockUserId', authProvider.token ?? 'mockToken');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BalanceProvider>(
      builder: (context, balanceProvider, child) {
        return Scaffold(
          body: Container(
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Greeting and Balance
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${Provider.of<AuthProvider>(context).firstName ?? 'User'}',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Welcome, let\'s start managing your wallet',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4A90E2),
                                    Color(0xFF003087),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Balance',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      balanceProvider.isLoading
                                          ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      )
                                          : Text(
                                        _isBalanceVisible
                                            ? '₦${balanceProvider.balance.toStringAsFixed(2)}'
                                            : '****',
                                        style: GoogleFonts.poppins(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.white,
                                        ),
                                        onPressed: _toggleBalanceVisibility,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Last updated 2 mins ago',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (balanceProvider.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  balanceProvider.errorMessage!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // White Container for Content
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Action Buttons (Deposit, Withdrawal, Transfer)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    context,
                                    icon: Icons.add_circle,
                                    label: 'Deposit',
                                    onTap: () => Navigator.pushNamed(context, '/deposit'),
                                  ),
                                  _buildActionButton(
                                    context,
                                    icon: Icons.remove_circle,
                                    label: 'Withdrawal',
                                    onTap: () => Navigator.pushNamed(context, '/withdrawal'),
                                  ),
                                  _buildActionButton(
                                    context,
                                    icon: Icons.send,
                                    label: 'Transfer',
                                    onTap: () => Navigator.pushNamed(context, '/transfer'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Logout and More Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    context,
                                    icon: Icons.logout,
                                    label: 'Logout',
                                    onTap: () {
                                      Provider.of<AuthProvider>(context, listen: false).clear();
                                      Navigator.pushReplacementNamed(context, '/login');
                                    },
                                  ),
                                  _buildMoreButton(context),
                                ],
                              ),
                              const SizedBox(height: 30),
                              // Transactions Section
                              Text(
                                'Recent Transactions',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'You haven\'t made any transactions yet.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Transfer'),
              BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Get Card'),
            ],
            currentIndex: 0,
            selectedItemColor: const Color(0xFF003087),
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              switch (index) {
                case 0: // Home
                  Navigator.pushReplacementNamed(context, '/wallet-home');
                  break;
                case 1: // Transfer
                  Navigator.pushNamed(context, '/transfer');
                  break;
                case 2: // Get Card
                  Navigator.pushNamed(context, '/get-card');
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 32,
                color: const Color(0xFF003087),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'Register as a Merchant':
            Navigator.pushNamed(context, '/merchant-registration');
            break;
          case 'Get a Card':
            Navigator.pushNamed(context, '/get-card');
            break;
          case 'Contact Us':
            Navigator.pushNamed(context, '/contact-us');
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'Register as a Merchant',
          child: Text(
            'Register as a Merchant',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
        PopupMenuItem(
          value: 'Get a Card',
          child: Text(
            'Get a Card',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
        PopupMenuItem(
          value: 'Contact Us',
          child: Text(
            'Contact Us',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      ],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.more_horiz,
                size: 32,
                color: Color(0xFF003087),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'More',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}