import 'package:flutter/material.dart';
import 'package:notes_app/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> notes = [];
  late DBHelper dbHelper;

  @override
  void initState() {
    super.initState();

    dbHelper = DBHelper.getInstance;

    getNotes();
  }

  getNotes() async {
    notes = await dbHelper.getAllNotes();
    setState(() {});
  }

  // controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), centerTitle: true),
      body: notes.isNotEmpty
          // all notes will be visible here
          ? ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(notes[index][DBHelper.columnNotesTitle]),
                  subtitle: Text(notes[index][DBHelper.columnNotesDescription]),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              titleController.text =
                                  notes[index][DBHelper.columnNotesTitle];
                              descriptionController.text =
                                  notes[index][DBHelper.columnNotesDescription];
                              return getBottomSheetWidget(
                                toUpdate: true,
                                id: notes[index][DBHelper.columnNotesId],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () async {
                          bool check = await dbHelper.deleteNote(
                            id: notes[index][DBHelper.columnNotesId],
                          );

                          if (check) {
                            getNotes();
                          }
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No Notes Yet!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              titleController.clear();
              descriptionController.clear();
              return getBottomSheetWidget();
            },
          );
        },
        // note to be added from here
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool toUpdate = false, int id = -1}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            toUpdate ? 'Edit Note' : 'Add Note',
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: titleController,
            decoration: InputDecoration(
              label: const Text('Title *'),
              hintText: 'Enter title here',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              label: const Text('Description *'),
              hintText: 'Enter description here',
              alignLabelWithHint: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: const BorderSide(width: 0),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final title = titleController.text;
                    final description = descriptionController.text;
                    if (title.isNotEmpty && description.isNotEmpty) {
                      bool check = toUpdate
                          ? await dbHelper.updateNote(
                              id: id,
                              title: title,
                              description: description,
                            )
                          : await dbHelper.addNote(
                              title: title,
                              description: description,
                            );

                      if (check) {
                        getNotes();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            toUpdate
                                ? 'Note edited successfully!'
                                : 'Note added successfully!',
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '*Please fill all the required fields!',
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    side: BorderSide(width: 0),
                  ),
                  child: Text(
                    toUpdate ? 'Edit Note' : 'Add Note',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
