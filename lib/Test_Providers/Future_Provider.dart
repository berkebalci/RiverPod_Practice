import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<int> fetcWeather() async {
  await Future.delayed(Duration(seconds: 3)); //await keywordu ile birlikte Future'in tamamlanmasını bekliyoruz.
  return 15;
}

final futureprovider = FutureProvider<int>((ref) {
  return fetcWeather();
});

class Future_Provider extends ConsumerWidget {
  const Future_Provider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue future = ref.watch(futureprovider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Future Provider"),
      ),
      body: Center(
          child: future.when(data: (value) {
        return Text(
          "$value",
          style: TextStyle(fontSize: 25),
        ); //Değerin doğru olma durumunda burası çalışıyor.
      }, error: (e, stack) {
        return Text("Error $e");
      }, loading: () {
        return const CircularProgressIndicator();
      })),
    );
  }
}
