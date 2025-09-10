import 'package:flutter/material.dart';

class LanguagePreferencePage extends StatefulWidget {
  const LanguagePreferencePage({super.key});

  @override
  _LanguagePreferencePageState createState() => _LanguagePreferencePageState();
}

class _LanguagePreferencePageState extends State<LanguagePreferencePage>
    with TickerProviderStateMixin {
  String? selectedLanguage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
        title: Text(
          'Language Preference',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.language_rounded,
                      color: isDark ? Colors.white70 : Colors.black54,
                      size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Choose your preferred language',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          _modernLanguageTile(
                            'Tagalog',
                            'https://flagcdn.com/w40/ph.png',
                            'Filipino',
                            selectedLanguage,
                            toggleLanguage,
                            isDark,
                          ),
                          const SizedBox(height: 12),
                          _modernLanguageTile(
                            'English',
                            'https://flagcdn.com/w40/us.png',
                            'United States',
                            selectedLanguage,
                            toggleLanguage,
                            isDark,
                          ),
                          const SizedBox(height: 12),
                          _modernLanguageTile(
                            'Mandarin',
                            'https://flagcdn.com/w40/cn.png',
                            'Chinese',
                            selectedLanguage,
                            toggleLanguage,
                            isDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _saveButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00A2FF), Color(0xFF0080E6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A2FF).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (selectedLanguage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Language set to $selectedLanguage successfully!'),
                backgroundColor: const Color(0xFF00A2FF),
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Please select a language'),
                backgroundColor: Colors.orange[600],
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A2FF),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Save Language',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _modernLanguageTile(
    String language,
    String flagUrl,
    String subtitle,
    String? selectedLanguage,
    Function(String) toggleLanguage,
    bool isDark,
  ) {
    final bool isSelected = selectedLanguage == language;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF00A2FF).withOpacity(0.1)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF00A2FF)
              : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              Image.network(flagUrl, width: 40, height: 40, fit: BoxFit.cover),
        ),
        title: Text(
          language,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF00A2FF)
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isSelected
                ? const Color(0xFF00A2FF).withOpacity(0.7)
                : (isDark ? Colors.white70 : Colors.grey[600]),
          ),
        ),
        trailing: isSelected
            ? const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF00A2FF),
                child: Icon(Icons.check, size: 14, color: Colors.white),
              )
            : null,
        onTap: () => toggleLanguage(language),
      ),
    );
  }
}
