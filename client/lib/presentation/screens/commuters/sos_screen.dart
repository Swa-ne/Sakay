import 'dart:async';
import 'package:flutter/material.dart';

class SosOverlayDialog extends StatefulWidget {
  const SosOverlayDialog({super.key});

  @override
  State<SosOverlayDialog> createState() => _SosOverlayDialogState();
}

class _SosOverlayDialogState extends State<SosOverlayDialog>
    with SingleTickerProviderStateMixin {
  // Hold-to-trigger
  bool _isHolding = false;
  int _holdSeconds = 10;
  Timer? _holdTimer;

  // Confirmation (after accidental release)
  bool _isConfirming = false;
  int _confirmSeconds = 10;
  Timer? _confirmTimer;
  double _cancelProgress = 0.0; // slider progress 0..1

  // Slide-up animation
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  void _startHold() {
    // cancel any confirm timer if restarting a hold
    _confirmTimer?.cancel();
    setState(() {
      _isConfirming = false;
      _cancelProgress = 0.0;
      _isHolding = true;
      _holdSeconds = 10;
    });

    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _holdSeconds--);

      if (_holdSeconds <= 0) {
        // Full 10s hold completed -> send immediately
        _holdTimer?.cancel();
        _sendSOS();
      }
    });
  }

  void _stopHold() {
    if (!_isHolding) return;
    _holdTimer?.cancel();

    // If user released early (still > 0), enter confirmation phase
    if (_holdSeconds > 0) {
      _startConfirmCountdown();
    }

    setState(() {
      _isHolding = false;
      _holdSeconds = 10; // reset for next time
    });
  }

  void _startConfirmCountdown() {
    _confirmTimer?.cancel();
    setState(() {
      _isConfirming = true;
      _confirmSeconds = 10;
      _cancelProgress = 0.0;
    });

    _confirmTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _confirmSeconds--);
      if (_confirmSeconds <= 0) {
        _sendSOS();
      }
    });
  }

  void _cancelSOS({bool showSnack = true}) {
    _confirmTimer?.cancel();
    setState(() {
      _isConfirming = false;
      _confirmSeconds = 10;
      _cancelProgress = 0.0;
    });
    if (showSnack) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SOS canceled")),
      );
    }
  }

  void _sendSOS() {
    _holdTimer?.cancel();
    _confirmTimer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🚨 SOS has been sent to the authorities (placeholder)"),
      ),
    );
    // TODO: Replace with your actual SOS trigger function
    // e.g., await sosService.sendAlert();
    debugPrint("SOS Triggered!");
    Navigator.pop(context);
  }

void _closeDialog() {
  _holdTimer?.cancel();
  _confirmTimer?.cancel();
  _controller.reverse().then((_) {
    if (mounted) {
      Navigator.pop(context);
    }
  });
}


  @override
  void dispose() {
    _holdTimer?.cancel();
    _confirmTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fade background slightly red while holding
    final bgColor = _isHolding ? Colors.red.shade100 : Colors.white;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Top bar with Close button (left) + Title (center)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black, size: 28),
                      onPressed: _closeDialog,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "SOS",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // balance right side
                  ],
                ),
              ),

              const Spacer(),

              // Explanation when in confirmation mode
              if (_isConfirming)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    "Accidental release detected.\nSlide below to cancel before SOS is sent.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),

              // Center button (hold or confirmation text)
              if (!_isConfirming)
                GestureDetector(
                  onLongPressStart: (_) => _startHold(),
                  onLongPressEnd: (_) => _stopHold(),
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _isHolding ? "$_holdSeconds" : "Press and hold\nto send SOS",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              if (_isConfirming)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 12),
                  child: Text(
                    "Sending SOS in $_confirmSeconds…",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),

              const Spacer(),

              // Slide-to-cancel (only during confirmation)
              if (_isConfirming)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.swipe_right, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Slide to cancel",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 8,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Slider(
                          min: 0,
                          max: 1,
                          value: _cancelProgress,
                          onChanged: (v) {
                            setState(() => _cancelProgress = v);
                            if (v >= 0.98) {
                              _cancelSOS();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
