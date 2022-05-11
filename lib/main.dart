import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuk/readInfo.dart';
import 'package:cuk/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Add User Info')),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '이름을 입력하시오'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: '나이를 입력하시오'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              child: const Text(
                'Create data',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              onPressed: () {
                final user = User(
                  name: nameController.text,
                  age: int.parse(ageController.text),
                );
                createUser(user);
                print('success');
                // Get.to(() => ReadInfo());
              },
            ),
            const SizedBox(height: 15),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child: const Text(
                'Read data',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              onPressed: () {
                Get.to(() => ReadInfo());
              },
            ),
            const SizedBox(height: 15),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text(
                'Update data',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              onPressed: () {
                final doUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc('update-test1');

                doUser.update({
                  'name': 'jenny',
                });
              },
            ),
            const SizedBox(height: 15),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'Delete data',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              onPressed: () {
                final doUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc('update-test2');

                doUser.update({
                  'job': FieldValue.delete(),
                });
              },
            ),
          ],
        ),
      );

  /// Create
  Future createUser(User user) async {
    //사용자 정의 ID로 새 document를 만들고 document 참조를 통헤 내부에 데이터를 쓸 수 있음
    //doc()안에 문자열을 넣으면 입력한 string값의 documentID가 생성된다.
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;
    //json 데이터로 변환
    final json = user.toJson();
    await docUser.set(json);
  }
}
