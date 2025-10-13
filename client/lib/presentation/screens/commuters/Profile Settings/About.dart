import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: const Color(0xFF00A2FF),
        title: const Text(
          'About Sakay',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Color(0xFF00A2FF)),
            child: Row(
              children: [
                Image.asset(
                  'assets/bus.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Real-time Bus Tracking',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Lingayen-Dagupan Route',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(
                    icon: Icons.rocket_launch,
                    title: 'Our Mission',
                    content:
                        'Sakay is an innovative real-time bus tracking system designed to enhance the commuting experience along the Lingayen-Dagupan route. Developed to address common transportation challenges such as delays, overcrowding, and the lack of real-time information, Sakay utilizes GPS technology to deliver accurate updates on vehicle locations, estimated arrival times, and proximity alerts.',
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    icon: Icons.visibility,
                    title: 'Our Vision',
                    content:
                        'Our mission is to transform public transportation by prioritizing reliability, efficiency, and accessibility for commuters, drivers, and operators. Through advanced features like route optimization and real-time vehicle tracking, Sakay reduces delays, improves operational efficiency, and elevates the overall travel experience.',
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    icon: Icons.school,
                    title: 'Development',
                    content:
                        'This project is a product of the collaborative efforts of a dedicated team from PHINMA – University of Pangasinan. Motivated by the growing need for efficient and reliable public transportation, the Sakay team has developed a solution that prioritizes data accuracy, passenger safety, and user-friendly functionality, ensuring a seamless experience for all users.',
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    icon: Icons.eco,
                    title: 'Our Impact',
                    content:
                        'By promoting sustainable urban mobility, Sakay not only addresses the immediate needs of commuters but also contributes to reducing traffic congestion and supporting the shift toward more efficient public transportation systems.',
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF00A2FF).withOpacity(0.1),
                          const Color(0xFF0080CC).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF00A2FF).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.group, color: Color(0xFF00A2FF)),
                            SizedBox(width: 12),
                            Text(
                              'Meet the Team',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _TeamMember(
                          name: 'Lance Manaois',
                          position: 'Project Manager & Full-stack Developer',
                        ),
                        _TeamMember(
                          name: 'Stephen Bautista',
                          position: 'Lead Developer & Full-stack Developer',
                        ),
                        _TeamMember(
                          name: 'Jaspher Tania',
                          position: 'UI/UX Designer & Frontend Developer',
                        ),
                        _TeamMember(
                          name: 'Mark Joshua Sarmiento',
                          position: 'Frontend Developer',
                        ),
                        _TeamMember(
                          name: 'Christian Majin',
                          position: 'Frontend Developer',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.grey.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
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
                child: const Icon(
                  Icons.star,
                  color: Color(0xFF00A2FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : const Color(0xFF4A5568),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamMember extends StatelessWidget {
  final String name;
  final String position;

  const _TeamMember({required this.name, required this.position});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00A2FF), Color(0xFF0080CC)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
