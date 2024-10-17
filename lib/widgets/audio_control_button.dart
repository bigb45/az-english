import 'package:ez_english/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioControlButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final AudioControlType type;
  final double? size;
  final bool isLoading; // New parameter for loading state
  final bool isRecording;
  const AudioControlButton({
    super.key,
    required this.onPressed,
    required this.type,
    this.size,
    this.isLoading = false, // Default value for loading state
    this.isRecording = false,
  });

  @override
  State<AudioControlButton> createState() => AudioControlButtonState();
}

class AudioControlButtonState extends State<AudioControlButton> {
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTap: widget.isLoading ? null : widget.onPressed,
      child: Transform.translate(
        offset: Offset(0, isPressed ? 5 : 0),
        child: Container(
          decoration: BoxDecoration(
            color: Palette.primaryVariant,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: isPressed
                ? null
                : const [
                    BoxShadow(
                      color: Palette.primaryVariantShadow,
                      offset: Offset(0, 5),
                      blurRadius: 0,
                    ),
                  ],
          ),
          width: widget.size ?? 150.w,
          height: widget.size ?? 150.w,
          child: Center(
            child: widget.isLoading
                ? const CircularProgressIndicator(
                    color: Palette.secondary,
                  )
                : Icon(
                    widget.isRecording ? Icons.stop : _getIconData(widget.type),
                    color: Palette.secondary,
                    size: widget.size == null ? 80.r : widget.size! / 2,
                  ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(AudioControlType type) {
    switch (type) {
      case AudioControlType.microphone:
        return Icons.mic;
      case AudioControlType.speaker:
        return Icons.volume_up;
      case AudioControlType.play:
        return Icons.play_arrow;
      case AudioControlType.pause:
        return Icons.pause;
      default:
        return Icons.help;
    }
  }
}

enum AudioControlType {
  microphone,
  speaker,
  play,
  pause,
}
