import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/orders_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account info
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (user != null) ...[
                      _buildInfoRow('Email', user.email ?? 'No email'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Account ID', user.uid),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Account since',
                        _formatDate(user.metadata.creationTime),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amazon Prime
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          'https://www.nicepng.com/png/detail/115-1159983_prime-logo-amazon-prime-logo-white.png',
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.star,
                              color: Colors.blue,
                              size: 24,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Amazon Prime',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Not a Prime member',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Prime subscription
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7CA00),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Try Prime Free',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Account actions
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsButton(
                      context,
                      'Your Orders',
                      Icons.shopping_bag_outlined,
                      () {
                        // Navigate to orders page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrdersPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    _buildSettingsButton(
                      context,
                      'Your Addresses',
                      Icons.location_on_outlined,
                      () {
                        // Navigate to addresses page
                      },
                    ),
                    const Divider(),
                    _buildSettingsButton(
                      context,
                      'Your Payments',
                      Icons.payment_outlined,
                      () {
                        // Navigate to payments page
                      },
                    ),
                    const Divider(),
                    _buildSettingsButton(
                      context,
                      'Change Password',
                      Icons.lock_outline,
                      () {
                        // Navigate to change password page
                      },
                    ),
                    const Divider(),
                    _buildDarkModeToggle(context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign out button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        await authProvider.signOut();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                  foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Builder(
      builder: (context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not available',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon,
                color:
                    isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade700,
            ),
            const SizedBox(width: 16),
            Text(
              themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
              activeColor: const Color(0xFFF7CA00),
            ),
          ],
        ),
      );
    });
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.month}/${date.day}/${date.year}';
  }
}
