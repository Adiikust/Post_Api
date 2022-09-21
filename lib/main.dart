import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:post_app/Views/Auth/api_screnn.dart';
import 'Controller/Export/export_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>("Adnan");
  await Hive.openBox('isUserLogin');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mobile Api',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginScreen()
        /* ValueListenableBuilder(
        valueListenable: Hive.box('isUserLogin').listenable(),
        builder: (BuildContext context, Box box, Widget? child) => box.get(
          'isUserLoggedIn',
          defaultValue: false,
        )
            ? DeliveryScreen(
               */ /* locationId: data["PersonalID"].toString(),
                location: data["Location"].toString(),
                personalID: data["LocationId"].toString(),
                userId: data["UserID"].toString(),*/ /*
              )
            : const LoginScreen(),
      ),*/
        );
  }
}
