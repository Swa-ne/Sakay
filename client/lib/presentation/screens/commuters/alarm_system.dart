import 'package:flutter/material.dart';

class AlarmSystem extends StatelessWidget {
  final bool isTrackerOn;
  final double s;

  const AlarmSystem({
    super.key,
    required this.isTrackerOn,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    if (!isTrackerOn) return const SizedBox.shrink();

    return Row(
      children: [
        InkWell(
          onTap: () => _showAlarmDialog(context),
          borderRadius: BorderRadius.circular(10 * s),
          child: Container(
            width: 40 * s,
            height: 40 * s,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10 * s),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 6 * s,
                  offset: Offset(0, 2 * s),
                ),
              ],
            ),
            child: Icon(
              Icons.alarm,
              color: Colors.white,
              size: 20 * s,
            ),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  void _showAlarmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlarmSettingsDialog(
          s: s,
          onSave: (settings) {
            debugPrint("Saved settings: $settings");
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }
}

class AlarmSettings {
  final String km;
  final double ringVolume;
  final double alarmVolume;
  final bool vibrate;

  AlarmSettings({
    required this.km,
    required this.ringVolume,
    required this.alarmVolume,
    required this.vibrate,
  });

  @override
  String toString() =>
      "KM: $km, Ring: $ringVolume, Alarm: $alarmVolume, Vibrate: $vibrate";
}

class CustomDialogContainer extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Widget child;
  final Color backgroundColor;

  const CustomDialogContainer({
    super.key,
    this.widthFactor = 0.8,
    this.heightFactor = 0.7,
    this.minWidth = 280,
    this.maxWidth = 400,
    this.minHeight = 400,
    this.maxHeight = 600,
    required this.child,
    this.borderRadius = 12,
    this.backgroundColor = Colors.white,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final calculatedWidth =
        (screenWidth * widthFactor).clamp(minWidth, maxWidth);
    final calculatedHeight =
        (screenHeight * heightFactor).clamp(minHeight, maxHeight);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: calculatedWidth,
        height: calculatedHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
        ),
        child: child,
      ),
    );
  }
}

class AlarmSettingsDialog extends StatefulWidget {
  final double s;
  final void Function(AlarmSettings) onSave;
  final VoidCallback onCancel;

  const AlarmSettingsDialog({
    super.key,
    required this.s,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AlarmSettingsDialog> createState() => _AlarmSettingsDialogState();
}

class _AlarmSettingsDialogState extends State<AlarmSettingsDialog> {
  final TextEditingController kmController = TextEditingController();
  double ringVolume = 0.5;
  double alarmVolume = 0.7;
  bool vibrate = true;

  @override
  void dispose() {
    kmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = mediaQuery.size.width;
        final responsiveScale = screenWidth < 360 ? 0.8 : 1.0;

        return CustomDialogContainer(
          widthFactor: 0.3,
          heightFactor: 0.75,
          minWidth: 80 * responsiveScale,
          maxWidth: 200,
          minHeight: 450 * responsiveScale,
          maxHeight: 450,
          borderRadius: 8 * s * responsiveScale,
          child: Column(
            children: [
              _buildHeader(s, responsiveScale),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(12 * s * responsiveScale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDistanceInput(s, responsiveScale),
                      SizedBox(height: 4 * s * responsiveScale),
                      _buildDistanceHint(s, responsiveScale),
                      SizedBox(height: 12 * s * responsiveScale),
                      _buildSoundSelection(s, responsiveScale),
                      SizedBox(height: 12 * s * responsiveScale),
                      _buildVolumeControl(
                        "Ring Volume",
                        ringVolume,
                        (v) => setState(() => ringVolume = v),
                        s,
                        responsiveScale,
                      ),
                      SizedBox(height: 10 * s * responsiveScale),
                      _buildVolumeControl(
                        "Alarm Volume",
                        alarmVolume,
                        (v) => setState(() => alarmVolume = v),
                        s,
                        responsiveScale,
                      ),
                      SizedBox(height: 10 * s * responsiveScale),
                      _buildVibrateToggle(s, responsiveScale),
                      SizedBox(height: 16 * s * responsiveScale),
                      _buildActionButtons(s, responsiveScale),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(double s, double responsiveScale) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14 * s * responsiveScale),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00A2FF), Color(0xFF0080FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12 * s * responsiveScale),
            topRight: Radius.circular(12 * s * responsiveScale),
          ),
        ),
        child: Center(
          child: Text(
            "Alarm Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16 * s * responsiveScale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget _buildDistanceInput(double s, double responsiveScale) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8 * s * responsiveScale,
          vertical: 8 * s * responsiveScale,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8 * s * responsiveScale),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1 * s * responsiveScale,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Distance",
                  style: TextStyle(
                    fontSize: 13 * s * responsiveScale,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8 * s * responsiveScale,
                    vertical: 3 * s * responsiveScale,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A2FF).withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(5 * s * responsiveScale),
                  ),
                  child: Text(
                    "KM",
                    style: TextStyle(
                      fontSize: 11 * s * responsiveScale,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00A2FF),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5 * s * responsiveScale),
            TextField(
              controller: kmController,
              cursorColor: const Color(0xFF00A2FF),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18 * s * responsiveScale,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: "0",
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14 * s * responsiveScale,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ],
        ),
      );

  Widget _buildDistanceHint(double s, double responsiveScale) => Text(
        "Set distance for reminder",
        style: TextStyle(
          fontSize: 11 * s * responsiveScale,
          color: Colors.grey.shade600,
        ),
        textAlign: TextAlign.center,
      );

  Widget _buildSoundSelection(double s, double responsiveScale) => Container(
        padding: EdgeInsets.all(10 * s * responsiveScale),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8 * s * responsiveScale),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1 * s * responsiveScale,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sound",
                  style: TextStyle(
                    fontSize: 13 * s * responsiveScale,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  "Default",
                  style: TextStyle(
                    fontSize: 11 * s * responsiveScale,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14 * s * responsiveScale,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      );

  Widget _buildVolumeControl(
    String title,
    double value,
    ValueChanged<double> onChanged,
    double s,
    double responsiveScale,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13 * s * responsiveScale,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 5 * s * responsiveScale),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4 * s * responsiveScale,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8 * s * responsiveScale,
              ),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: 12 * s * responsiveScale,
              ),
              activeTrackColor: const Color(0xFF00A2FF),
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: const Color(0xFF00A2FF),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
              min: 0,
              max: 1,
              divisions: 10,
            ),
          ),
        ],
      );

  Widget _buildVibrateToggle(double s, double responsiveScale) => Container(
        padding: EdgeInsets.all(10 * s * responsiveScale),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8 * s * responsiveScale),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1 * s * responsiveScale,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.vibration,
              color: const Color(0xFF00A2FF),
              size: 17 * s * responsiveScale,
            ),
            SizedBox(width: 8 * s * responsiveScale),
            Expanded(
              child: Text(
                "Vibrate",
                style: TextStyle(
                  fontSize: 13 * s * responsiveScale,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: vibrate,
              activeColor: const Color(0xFF00A2FF),
              onChanged: (v) => setState(() => vibrate = v),
            ),
          ],
        ),
      );

  Widget _buildActionButtons(double s, double responsiveScale) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: widget.onCancel,
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              padding: EdgeInsets.symmetric(
                horizontal: 14 * s * responsiveScale,
                vertical: 8 * s * responsiveScale,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontSize: 13 * s * responsiveScale,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 6 * s * responsiveScale),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A2FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6 * s * responsiveScale),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 18 * s * responsiveScale,
                vertical: 8 * s * responsiveScale,
              ),
              elevation: 0,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              widget.onSave(AlarmSettings(
                km: kmController.text,
                ringVolume: ringVolume,
                alarmVolume: alarmVolume,
                vibrate: vibrate,
              ));
            },
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 13 * s * responsiveScale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
}
