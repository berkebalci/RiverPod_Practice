
import 'package:firebase_uygulamasi/sign_in.dart';
import 'package:intl/intl.dart';
import 'package:firebase_uygulamasi/list_widget.dart';
import 'package:firebase_uygulamasi/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Test_Providers/Future_Provider.dart';
import 'Test_Providers/Stream_Provider.dart';

final clockprovider = StateNotifierProvider<Clock, DateTime>((ref) {
  return Clock();
});

class CounterPage extends ConsumerWidget {
  //ConsumerWidget kısmı widget'in Providerlara erişmesi için  elzem nokta!!

  CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Degisiklik oldu");
    final int counter = ref.watch(counterProvider); //Böylece counterProvider'in
    //**state'i her değiştiğinde bu widget rebuild olacak.

    //Bu metod ile counterProvider'in degerini alıyoruz.
    //Bu aslında Getx'de olan variable.obs yapısına benzemektedir.
    //Ayrıca fark edildiği gibi 'watch' fonksiyonu 'counter' değişkenine Provider'in yeni değerini döndürüyor.

    //watch state'de değişiklik gördüğünde içinde olduğu widget'i rebuild etmektedir.
    //**Sayı 5'i geçtiği zaman uyarı barı göstermek(Alert bar) */
    ref.listen<int>(counterProvider, ((previous, next) {
      //next ifadesi şu andaki değerimizi belirtmektedir.
      //Burdaki int ifadesini eklemessek 'if' ifadesinde hata alırız.

      if (next > 6) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert!"),
                content:
                    Text("Number is dangerously high.Please decrease it!."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Alright!"))
                ],
              );
            });
      }
    }));
    print("Degisiklik oldu 2");
    //final tarif_listesi = ref.watch(tarif_provider);
    final AsyncValue<int> counter2 = ref.watch(streamprovider(ref
        .read(userValueprovider.notifier)
        .state)); //Stream provider'in gözlemcisi
    final clock = ref.watch(clockprovider);
    final timeFormatted = DateFormat.Hms().format(clock);

    print("Degisiklik oldu 3");
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          flexibleSpace: SafeArea(
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (((context) => (MyApp())))));
                    },
                    icon: Icon(Icons.backup_outlined)),
                SizedBox(
                  width: 25,
                  height: 70,
                ),
                Text(
                  "Counter Page",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(
                  width: 25,
                  height: 70,
                ),
                IconButton(
                    //Ekrandaki sayinin default değere(state'e) dönmesini sağlıcak.
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      ref.invalidate(streamprovider(
                          0)); //Böylece counterProvider'e default state'ini verdik.
                    }),
              ],
            ),
          ),
        ),
        body: Stack(alignment: Alignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$timeFormatted"),
              Text(
                "$counter",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              List_Widget(),
              ElevatedButton(
                  child: Text(
                    "Future Provider",
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (((context) => (Future_Provider())))));
                  }),
              ElevatedButton(
                  child: Text(
                    "Stream Provider",
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (((context) => (Stream_Provider())))));
                  }),
              Text(counter2.when(
                  data: (int value) => value.toString(),
                  error: (Object a, _) => "$a",
                  loading: () =>
                      ref.read(userValueprovider.notifier).state.toString()))
              ,
              ElevatedButton(onPressed:(){
                Navigator.of(context).push(MaterialPageRoute(
                        builder: (((context) => (Sign_in())))));
              }, child: Text("Sign_in Page"))
            ],
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              ref
                  .read(counterProvider.notifier)
                  .state++; //state'i arttiriyoruz.
              //State bizim durumumuzda
            }));
  }
}

class Clock extends StateNotifier<DateTime> {
  Clock() : super(DateTime.now()) {
    print("Clock'in ici");
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      state = DateTime.now(); //StateNotifier'in state'i
      
    });
  }
  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel(); //bundan sonra callback fonksiyonu çalışmayacak.
    super.dispose();
  }
}
