import 'package:firebase_uygulamasi/Test_Providers/Stream_Provider.dart';
import 'package:firebase_uygulamasi/list_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Test_Providers/Future_Provider.dart';

final counterProvider = StateProvider(((ref) {
  return 0;
})); //Read ve Modify yapabilcez
//Buradaki 0 counterProvider'in state'sidir.

//'autoDispose' ile widget'in dispose olduğu durumlarda(Farklı bir sayfaya geçme vs.)
//**bu widget'e bağlı Provider'in da dispose olmasını sağlıyoruz.
//Böylece yaptığımız uygulamada farklı bir sayfaya geçtiğimizde counterProvider oto
//**silindiğinden dolayı 0'dan tekrar tekrar başlıyor.

final boolProvider = StateProvider((ref) {
  return true;
});

final streamprovider = StreamProvider<int>(
  //Bir provider'dan başka bir Provider'a ulaştık
  (ref) {
    final wsClient = ref.watch(websocketClientProvider);
    return wsClient.getCounterStream();
  },
);

//Sahte Websocket oluşturuyoruz
abstract class WebsocketClient {
  Stream<int> getCounterStream();
}

final websocketClientProvider = Provider<WebsocketClient>(((ref) {
  return FakeWebsocketClient();
}));

class FakeWebsocketClient implements WebsocketClient {
  //Buradaki 'implements' keywordu 'extends' ile benzer amaca sahiptir.

  @override
  Stream<int> getCounterStream() async* {
    int i = 0;
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield i++;
    }
  }
}

Future main() async {
  //Firebase kullanacağımızdan dolayı Future ifadesi var.
  WidgetsFlutterBinding.ensureInitialized(); //Firebase bağlantısı
  await Firebase.initializeApp();

  runApp(ProviderScope(
      //Riverpod ile Flutter'ı bağladığımız yer!!
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Burdaki 'ref' ile watch,listen ve read yapabileceğiz.
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
            surface: Color(0Xff003909)),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Column(
          children: [
            ElevatedButton(
              child: Text("Go to the Counter page"),
              onPressed: () {
                Navigator.of(context).push(
                  //Navigation
                  MaterialPageRoute(builder: (((context) => CounterPage()))),
                );
              },
            ),
          ],
        ));
  }
}

class CounterPage extends ConsumerWidget {
  //ConsumerWidget kısmı widget'in Providerlara erişmesi için  elzem nokta!!

  CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int counter = ref.watch(counterProvider); //Böylece counterProvider'in
    //**state'i her değiştiğinde bu widget rebuild olacak.
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
    //final tarif_listesi = ref.watch(tarif_provider);
    final AsyncValue<int> counter2 = ref.watch(streamprovider); //Stream provider'in gözlemcisi

    return Scaffold(
        appBar: AppBar(
          title: Text("Counter Page"),
          leading: IconButton(
              //Ekrandaki sayinin default değere(state'e) dönmesini sağlıcak.
              icon: Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(//invalidate = geçersiz kilmak
                    counterProvider); //Böylece counterProvider'e default state'ini verdik.
              }),
        ),
        body: Stack(alignment: Alignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    error: (Object a,_) => "$a", 
                    loading: () => 0.toString()))
                    //TODO: User'in başlama değerini vermesini sağla!
            ],
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              ref.read(counterProvider.notifier).state++; //state'i arttiriyoruz.
              //State bizim durumumuzda
            }));
  }
}
