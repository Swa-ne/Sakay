import 'package:flutter/material.dart';

class ThemeCustomizationPage extends StatefulWidget {
  const ThemeCustomizationPage({super.key});

  @override
  _ThemeCustomizationPageState createState() => _ThemeCustomizationPageState();
}

class _ThemeCustomizationPageState extends State<ThemeCustomizationPage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  bool isAnnouncementEnabled = true;
  bool isSoundEffectEnabled = true;
  int fontSize = 14;
  int vibrationIntensity = 3;
  double soundVolume1 = 0.5;
  double soundVolume2 = 0.7;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 249, 249, 249),
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Theme Customization',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 249, 249, 249),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.palette,
                        title: 'Display Settings',
                      ),
                      const SizedBox(height: 16),
                      _buildModernOption(
                        icon: Icons.dark_mode,
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark theme',
                        trailing: _buildModernSwitch(isDarkMode, (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        }),
                      ),
                      _buildModernOption(
                        icon: Icons.text_fields,
                        title: 'Font Size',
                        subtitle: 'Adjust text size: ${fontSize}px',
                        trailing: _buildFontSizeControls(),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionHeader(
                        icon: Icons.notifications,
                        title: 'Notifications',
                      ),
                      const SizedBox(height: 16),
                      _buildModernOption(
                        icon: Icons.campaign,
                        title: 'Announcement Alert',
                        subtitle: 'Get notified of updates',
                        trailing:
                            _buildModernSwitch(isAnnouncementEnabled, (value) {
                          setState(() {
                            isAnnouncementEnabled = value;
                          });
                        }),
                      ),
                      _buildModernOption(
                        icon: Icons.volume_up,
                        title: 'Sound Effects',
                        subtitle: 'Enable notification sounds',
                        trailing:
                            _buildModernSwitch(isSoundEffectEnabled, (value) {
                          setState(() {
                            isSoundEffectEnabled = value;
                          });
                        }),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionHeader(
                        icon: Icons.vibration,
                        title: 'Sound & Vibration',
                      ),
                      const SizedBox(height: 16),
                      _buildModernOption(
                        icon: Icons.vibration,
                        title: 'Vibration Intensity',
                        subtitle: 'Level: $vibrationIntensity/5',
                        trailing: _buildVibrationControls(),
                      ),
                      const SizedBox(height: 16),
                      _buildSoundVolumeCard('Notification Volume', soundVolume1,
                          (value) {
                        setState(() {
                          soundVolume1 = value;
                        });
                      }),
                      const SizedBox(height: 12),
                      _buildSoundVolumeCard('Media Volume', soundVolume2,
                          (value) {
                        setState(() {
                          soundVolume2 = value;
                        });
                      }),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00A2FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF00A2FF),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildModernOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00A2FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00A2FF),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildModernSwitch(bool value, ValueChanged<bool> onChanged) {
    return Transform.scale(
      scale: 0.9,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF00A2FF),
        activeTrackColor: const Color(0xFF00A2FF).withOpacity(0.3),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildFontSizeControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            icon: Icons.remove,
            onPressed: fontSize > 10
                ? () {
                    setState(() {
                      fontSize--;
                    });
                  }
                : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              fontSize.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00A2FF),
              ),
            ),
          ),
          _buildControlButton(
            icon: Icons.add,
            onPressed: fontSize < 20
                ? () {
                    setState(() {
                      fontSize++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildVibrationControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            icon: Icons.remove,
            onPressed: vibrationIntensity > 1
                ? () {
                    setState(() {
                      vibrationIntensity--;
                    });
                  }
                : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              vibrationIntensity.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00A2FF),
              ),
            ),
          ),
          _buildControlButton(
            icon: Icons.add,
            onPressed: vibrationIntensity < 5
                ? () {
                    setState(() {
                      vibrationIntensity++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: onPressed != null
                ? const Color(0xFF00A2FF)
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildSoundVolumeCard(
      String title, double value, ValueChanged<double> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.volume_up,
                color: const Color(0xFF00A2FF),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF00A2FF),
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: const Color(0xFF00A2FF),
              overlayColor: const Color(0xFF00A2FF).withOpacity(0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
