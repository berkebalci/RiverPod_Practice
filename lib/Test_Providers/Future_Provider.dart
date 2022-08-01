import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
Future<int> fetcWeather() async{
  await Future.delayed(Duration(seconds: 3));
  return 15;
}
final futureprovider = FutureProvider<int>((ref) {
  return fetcWeather();
});

class Future_Provider extends ConsumerWidget {
  const Future_Provider({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue future = ref.watch(futureprovider);
    return Scaffold(
      appBar: null
      ,body: Center(
        child: future.when(
          data: (value){
            Text("$value");
          }, 
          error: (e,stack){
            return Text("Error $e");
          }, 
          loading:() {
            return const CircularProgressIndicator();}
            )),
    );
  }
}