import 'package:cuk/user.dart';
import 'package:flutter/material.dart';
import 'package:cuk/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReadInfo extends StatefulWidget {
  const ReadInfo({Key? key}) : super(key: key);

  @override
  State<ReadInfo> createState() => _ReadInfoState();
}

class _ReadInfoState extends State<ReadInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<List<User>>(
          future: readUsers().first,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            //snapshot을 통해 data access 가능
            else if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView(
                children: users.map(buildUser).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  ///Read
  //일부 json 데이터를 가져와서 User객체로 변환
  //모든 snapshot doc를 확인하고 각 doc에 대해 다시 User객체로 변환해서 해당 doc에 데이터를 접근할 수 있음
  //snapshot.docs.map((doc) => User.fromJson(doc.data())).toList() - mapping 후에는 User객체로 변환하기 위해 fromJson함수 사용
  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(
        child: Text('${user.age}'),
      ),
      title: Text(user.name));
}
