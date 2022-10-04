import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Stream: Verilerin aktığı bir yapı olarak düşünebiliriz.
Detaylı bilgiler not defterinde yazılı
*/

final stream_provider = StreamProvider.autoDispose<String>((ref) {
  return Stream.periodic(
    Duration(milliseconds: 400),
    (count) => '$count',
  );
});

class Stream_Provider extends ConsumerWidget {
  const Stream_Provider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(stream_provider);
    return Scaffold(body: Center());
  }
}
