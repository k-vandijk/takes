import 'package:flutter/material.dart';

class RecorderButtonWidget extends StatefulWidget {
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const RecorderButtonWidget({
    super.key,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  State<RecorderButtonWidget> createState() => _RecorderButtonWidgetState();
}

class _RecorderButtonWidgetState extends State<RecorderButtonWidget>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePressed() {
    if (isRecording) {
      widget.onStopRecording();
    } else {
      widget.onStartRecording();
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isRecording)
            Positioned(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(isRecording ? Icons.stop : Icons.mic),
            iconSize: 36,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: _handlePressed,
          ),
        ],
      ),
    );
  }
}