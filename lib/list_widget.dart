import 'package:firebase_uygulamasi/list_widget.dart';
import 'package:firebase_uygulamasi/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class List_Widget extends ConsumerWidget {
  const List_Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool checking = ref.watch(boolProvider);

    return Column(children: [
      Checkbox(
        value: checking,
        onChanged: (bool? value) {
          print("CheckBox değişti");
        },
      ),
      ElevatedButton(
          onPressed: () {
            print("${ref.read(boolProvider.notifier).state}"); //true değerini veriyor.
            if (ref.read(boolProvider.notifier).state == true) {
              ref.read(boolProvider.notifier).state = false;
            } else {
              ref.read(boolProvider.notifier).state = true;
            }
          },
          child: Icon(Icons.radio_button_unchecked)),
    ]);
  }
}
