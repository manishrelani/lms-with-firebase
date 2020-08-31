import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/util/firebase.dart';

class ClgUserID extends StatefulWidget {
  @override
  _ClgUserIDState createState() => _ClgUserIDState();
}

class _ClgUserIDState extends State<ClgUserID> {
  final idController = TextEditingController();
  FireBase firebase = FireBase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("member")
              .document("college")
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            return !snapshot.hasData
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data["id"].length,
                    itemBuilder: ((context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.assignment_ind),
                            title: Text(snapshot.data["id"][index],
                                style: TextStyle(fontSize: 16)),
                            trailing: GestureDetector(
                              child: const Icon(Icons.delete),
                              onTap: () {
                                firebase.removeMember(snapshot.data["id"][index]);
                              },
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      );
                    }),
                  );
          }),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text("College Member ID"),
      actions: [
        GestureDetector(
          child: const Icon(Icons.add),
          onTap: () {
            memberDialogBox(context);
            firebase.addClgStaff("ok");
          },
        ),
        const SizedBox(
          width: 15,
        )
      ],
    );
  }

  void memberDialogBox(BuildContext context) {
    final dialog = AlertDialog(
      content: TextField(
        autofocus: true,
        controller: idController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: "Member ID"),
      ),
      actions: [
        FlatButton(
            child: Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
            onPressed: () {
              firebase.addClgStaff(idController.text.trim()).then((value) {
                Navigator.pop(context);
              });
            }),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }
}
