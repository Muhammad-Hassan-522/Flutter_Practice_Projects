import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_practice/add_new_task.dart';
import 'package:firebase_practice/utils.dart';
import 'package:firebase_practice/widgets/date_selector.dart';
import 'package:firebase_practice/widgets/task_card.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNewTask()),
              );
            },
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const DateSelector(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("tasks")
                  .where(
                    'creator',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No data here yet!'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(snapshot.data!.docs[index].id),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await FirebaseFirestore.instance
                                .collection("tasks")
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                            return true;
                          }
                          return false;
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: hexToColor(
                                  snapshot.data!.docs[index].data()['color'],
                                ),
                                headerText: snapshot.data!.docs[index]
                                    .data()['title'],
                                descriptionText: snapshot.data!.docs[index]
                                    .data()['description'],
                                scheduledDate: DateFormat('EEE, MMM d, yyyy')
                                    .format(
                                      (snapshot.data!.docs[index]
                                              .data()['date'])
                                          .toDate(),
                                    ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: strengthenColor(
                                  const Color.fromRGBO(246, 222, 194, 1),
                                  0.69,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                DateFormat.jm().format(
                                  (snapshot.data!.docs[index]
                                          .data()['postedAt'])
                                      .toDate(),
                                ),
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
