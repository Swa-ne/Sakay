import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms & Conditions",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(5, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        size: 48,
                        color: Color(0xFF00A2FF),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Legal Agreement',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Please read these terms carefully before using Sakay',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A2FF).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF00A2FF).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'By agreeing to these Terms and Conditions, you acknowledge and accept the following:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : const Color(0xFF2D3748),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _TermsSection(
                    title: '1. Usage of Sakay',
                    content:
                        'Sakay is a free public transportation companion app that provides real-time vehicle tracking, ETA notifications, and route optimization for commuters and drivers along the Lingayen-Dagupan route.',
                    icon: Icons.directions_bus,
                  ),
                  const _TermsSection(
                    title: '2. Account & Access',
                    content:
                        'Users are required to create an account using a valid email address and password. Drivers and commuters have separate access and features.',
                    icon: Icons.account_circle,
                  ),
                  const _TermsSection(
                    title: '3. Data Collection',
                    content:
                        'By using Sakay, you consent to the collection and secure storage of your email address and password for account authentication.',
                    icon: Icons.security,
                  ),
                  const _TermsSection(
                    title: '4. Announcements & Communication',
                    content:
                        'Admins may post important announcements which are visible to users through the app.',
                    icon: Icons.campaign,
                  ),
                  const _TermsSection(
                    title: '5. Service Availability',
                    content:
                        'Sakay does not guarantee uninterrupted access or flawless performance. GPS or internet issues may affect tracking.',
                    icon: Icons.wifi,
                  ),
                  const _TermsSection(
                    title: '6. Acceptable Use',
                    content:
                        'Users must not attempt to disrupt the service, misuse data, or impersonate others.',
                    icon: Icons.verified_user,
                  ),
                  const _TermsSection(
                    title: '7. Changes to Terms',
                    content:
                        'We may update these Terms and Conditions as the service evolves.',
                    icon: Icons.update,
                  ),
                  const _TermsSection(
                    title: '8. Contact & Support',
                    content:
                        'For questions, feedback, or issues, please reach out through our admin portal.',
                    icon: Icons.support_agent,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: isDark
                              ? Colors.white70
                              : Colors.grey.shade600,
                          size: 24,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Last updated: ${DateTime.now().year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.white70
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'These terms are effective immediately upon acceptance',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _TermsSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A2FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF00A2FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 11,
              height: 1.6,
              color: isDark ? Colors.white70 : const Color(0xFF4A5568),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
