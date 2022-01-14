import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_list/book_list_page.dart';
import 'login/login_page.dart';

//void main() async{
void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class UserState extends ChangeNotifier{
  User? user;
  
  void setUser(User currentUser){
    if(user == null){
      //do nothing
    }
    else{
      user = currentUser;
      notifyListeners();
      }
    }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final UserState user = UserState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>.value(
        value: user,
        child: MaterialApp(
          //デバックラベル非表示
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginCheck(),
          routes:<String, WidgetBuilder>{
            "/login":(BuildContext context) => LoginPage(),
            "/home":(BuildContext context) => BookListPage(),
          },
        )
    );
  }
}

class LoginCheck extends StatefulWidget{
  LoginCheck({Key? key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();

}

class _LoginCheckState extends State<LoginCheck>{
   //ログイン状態のチェック(非同期で行う)
  void checkUser() async{
    final currentUser = FirebaseAuth.instance.currentUser;
    final userState = Provider.of<UserState>(context,listen: false);
    if(currentUser == null){
      Navigator.pushReplacementNamed(context,"/login");
    }else{
      userState.setUser(currentUser);
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState(){
    super.initState();
    checkUser();
  }
  //ログイン状態のチェック時はこの画面が表示される
  //チェック終了後にホーム or ログインページに遷移する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}