import 'package:flutter/material.dart';

class AlreadyAtDestinationWidget extends StatefulWidget {
  final double s;
  final String destinationName;
  final VoidCallback onClose;

  const AlreadyAtDestinationWidget({
    Key? key,
    required this.s,
    required this.destinationName,
    required this.onClose,
  }) : super(key: key);

  @override
  _AlreadyAtDestinationWidgetState createState() =>
      _AlreadyAtDestinationWidgetState();
}

class _AlreadyAtDestinationWidgetState
    extends State<AlreadyAtDestinationWidget> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    // Auto-dismiss after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted && _isVisible) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    setState(() {
      _isVisible = false;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: _isVisible ? 20 * widget.s : -100,
      left: 16 * widget.s,
      right: 16 * widget.s,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: _isVisible ? 1 : 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16 * widget.s),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16 * widget.s),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10 * widget.s,
                  offset: Offset(0, 4 * widget.s),
                ),
              ],
              border: Border.all(
                color: Colors.green.shade300,
                width: 2 * widget.s,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8 * widget.s),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12 * widget.s),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24 * widget.s,
                  ),
                ),
                SizedBox(width: 12 * widget.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You've arrived!",
                        style: TextStyle(
                          fontSize: 16 * widget.s,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                      SizedBox(height: 4 * widget.s),
                      Text(
                        "You're already at ${widget.destinationName}",
                        style: TextStyle(
                          fontSize: 12 * widget.s,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8 * widget.s),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20 * widget.s,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: _dismiss,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 32 * widget.s,
                    minHeight: 32 * widget.s,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
