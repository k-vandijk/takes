import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:takes/config.dart';
import 'package:takes/entities/recording.dart';
import 'package:takes/helpers/formatting_helper.dart';
import 'package:takes/helpers/notifications_helper.dart';
import 'package:takes/providers/recordings_provider.dart';
import 'package:takes/widgets/small_button_widget.dart';

enum ModalContent { details, label, rename }

class RecordingDetailsModal extends StatefulWidget {
  final Recording recording;
  final VoidCallback onDelete;

  const RecordingDetailsModal({
    super.key,
    required this.recording,
    required this.onDelete,
  });

  @override
  State<RecordingDetailsModal> createState() => _RecordingDetailsModalState();
}

class _RecordingDetailsModalState extends State<RecordingDetailsModal> {
  ModalContent _currentContent = ModalContent.details;

  @override
  Widget build(BuildContext context) {
    Widget modalToShow;

    switch (_currentContent) {
      case ModalContent.details:
        modalToShow = DetailsModalContent(
          recording: widget.recording,
          onDelete: widget.onDelete,
          onSwitch: (ModalContent newContent) {
            setState(() {
              HapticFeedback.mediumImpact();
              _currentContent = newContent;
            });
          },
        );
        break;
      case ModalContent.label:
        modalToShow = LabelModalContent(
          recording: widget.recording,
          onBack: () {
            setState(() {
              HapticFeedback.mediumImpact();
              _currentContent = ModalContent.details;
            });
          },
        );
        break;
      case ModalContent.rename:
        modalToShow = RenameModalContent(
          recording: widget.recording,
          onBack: () {
            setState(() {
              HapticFeedback.mediumImpact();
              _currentContent = ModalContent.details;
            });
          },
        );
        break;
    }

    return Container(padding: const EdgeInsets.all(16), child: modalToShow);
  }
}

class DetailsModalContent extends StatelessWidget {
  final Recording recording;
  final VoidCallback onDelete;
  final Function(ModalContent) onSwitch;

  const DetailsModalContent({
    super.key,
    required this.recording,
    required this.onDelete,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            recording.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Size: ${formatBytesToMegaBytes(recording.sizeBytes)}',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Duration: ${formatSecondsToMmSs(recording.durationSeconds)}',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          dense: true,
          leading: const Icon(Icons.edit),
          title: const Text('Rename'),
          onTap: () {
            onSwitch(ModalContent.rename);
          },
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.label_outline),
          title: const Text('Label'),
          onTap: () {
            onSwitch(ModalContent.label);
          },
        ),
        ListTile(
          dense: true,
          leading: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            'Delete',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onTap: () {
            Navigator.pop(context);
            onDelete();
          },
        ),
      ],
    );
  }
}

class LabelModalContent extends StatefulWidget {
  final Recording recording;
  final VoidCallback onBack;

  const LabelModalContent({
    super.key,
    required this.recording,
    required this.onBack,
  });

  @override
  State<LabelModalContent> createState() => _LabelModalContentState();
}

class _LabelModalContentState extends State<LabelModalContent> {

  Color selectedColor = labelColors.first;

  void onSave(BuildContext context, String label) {
    if (label.isNotEmpty) {
    widget.recording.label = label;
    widget.recording.labelBackgroundColor = selectedColor;
    widget.recording.labelForegroundColor = Colors.white;
    Provider.of<RecordsProvider>(context, listen: false)
        .updateRecording(widget.recording)
        .then((_) {
          Navigator.pop(context);
        })
        .catchError((error) {
          showErrorSnackBar(context);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
            Center(
              child: Text(
                'Label Recording',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Label'
          )
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              labelColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      HapticFeedback.mediumImpact();
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: selectedColor == color
                          ? Border.all(color: Theme.of(context).colorScheme.primary, width: 4)
                          : null,
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SmallButtonWidget(
              text: 'Save',
              onPressed: () => onSave(context, controller.text),
            ),
          ],
        ),
      ],
    );
  }
}

class RenameModalContent extends StatelessWidget {
  final Recording recording;
  final VoidCallback onBack;

  const RenameModalContent({
    super.key,
    required this.recording,
    required this.onBack,
  });

  void onSave(BuildContext context, String input) {
    if (input.isNotEmpty) {
      recording.name = input;
      Provider.of<RecordsProvider>(context, listen: false).updateRecording(recording).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        showErrorSnackBar(context);
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: recording.name);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
            Center(
              child: Text(
                'Rename Recording',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New Name'
          )),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SmallButtonWidget(
              text: 'Save',
              onPressed: () => onSave(context, controller.text),
            ),
          ],
        ),
      ],
    );
  }
}
