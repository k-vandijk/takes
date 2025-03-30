import 'package:flutter/material.dart';
import 'package:takes/widgets/small_button_widget.dart';

Future<String?> getRecordingName(BuildContext context) async {
  String name = 'untitled-${DateTime.now()}';
  final TextEditingController controller = TextEditingController(text: name);
  return await showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Name your recording', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmallButtonWidget(
                  text: 'Cancel',
                  icon: Icons.cancel,
                  backgroundColorOverwrite: Theme.of(context).colorScheme.error,
                  foregroundColorOverwrite: Theme.of(context).colorScheme.onError,
                  onPressed: () => Navigator.pop(context, null),
                ),
                const SizedBox(width: 8),
                SmallButtonWidget(
                  text: 'Save',
                  icon: Icons.save,
                  onPressed: () => Navigator.pop(context, name),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
