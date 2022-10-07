import 'package:firebase_uygulamasi/Counterpage.dart';
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

final streamprovider = StreamProvider.autoDispose.family<int, int>(
  //Burada iki adet int olmasının sebebi ikinci int girilecek olan 'start' parametresinin türüdür.
  //streamprovider(6) diyip 'start' parametresini 6 yapabiliriz mesela bu durumda.
  (ref, start) {
    //Kullanicinin başlama değerini girmesi
    //**için 'family' modifier'ini kullanıcaz.autodispose ile family aynı anda olabiliyor.
    //Bir provider'dan başka bir Provider'a ulaştık
    final wsClient = ref.watch(websocketClientProvider);
    return wsClient.getCounterStream(start);
  },
);

//Sahte Websocket oluşturuyoruz
abstract class WebsocketClient {
  Stream<int> getCounterStream([int start = 0]);
}

final websocketClientProvider = Provider<WebsocketClient>(((ref) {
  return FakeWebsocketClient();
}));

class FakeWebsocketClient implements WebsocketClient {
  //Buradaki 'implements' keywordu 'extends' ile benzer amaca sahiptir.

  @override
  Stream<int> getCounterStream([int start = 0]) async* {
    int i = start;
    while (true) {
      yield i++;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}

int user_value = 0;
int temp = 0;
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  @override
  void initstate() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Home"),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
              height: 60,
            ),
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number, //Klavyeyi ona göre ayarliyor.
              textInputAction: TextInputAction
                  .done, //Klavyenin sağ altında çıkan yaziyi ayarliyor.
              decoration: InputDecoration(
                  labelText: "Bir numara giriniz", //Input'dan önceki yazi
                  border: OutlineInputBorder(), //Textfield'in çevresi
                  prefixIcon: Icon(Icons.numbers),
                  suffixIcon: controller.text.isEmpty
                      ? Container(
                          width: 0,
                        )
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            controller.clear(); //clear fonksiyonu ile controllerin 
                            //**degeri default degerine dondu('')
                          },
                        )),
            ),
            IconButton(
                onPressed: () {
                  temp = user_value;
                  user_value = int.parse(controller.text);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Input kaydedildi"),
                    action: SnackBarAction(
                      label: "Geri al",
                      onPressed: () {
                        user_value = temp;
                      },
                    ),
                  ));
                },
                icon: Icon(Icons.add_task)),
            IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      //ScaffoldMessenger programda herhangi bir bekletme yapmıyor.
                      //Aşağıdaki print ifadesi hemen çalıştırılıyor.
                      content: Text("Input2 kaydedildi"),
                      action: SnackBarAction(
                        label: "Geri al",
                        onPressed: () {},
                      ),
                    ));
                  print("Scaffold Messenger'dan sonra");
                },
                icon: Icon(Icons.access_time)),
            IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Input3 kaydedildi"),
                    action: SnackBarAction(
                      label: "Geri al",
                      onPressed: () {},
                    ),
                  ));
                },
                icon: Icon(Icons.thirteen_mp))
          ],
        ));
  }
}
