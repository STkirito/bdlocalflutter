import 'package:flutter/material.dart';
import 'package:flutter_codigo_taskbd/db/db_admin.dart';
import 'package:flutter_codigo_taskbd/models/task_model.dart';
import 'package:flutter_codigo_taskbd/widgets/my_form_widget.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> gefulllName() async {
    return 'Juan Mnauel';
  }

  showDialogFrom(BuildContext context, {bool edit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return MyFormWidget(
          edit: edit,
        );
      },
    ).then((value) => setState(() {}));
  }

  deleteTask(int taskId) {
    DBAdmin.db.deleteTask(taskId).then((value) {
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
          children: [
            Icon(Icons.check_circle),
            SizedBox(
              width: 10.0,
            ),
            Text('Tarea eliminada'),
          ],
        )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomePage'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialogFrom(context);
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: DBAdmin.db.getTask(),
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasData) {
                List<TaskModel> mytasks = snap.data!;
                return ListView.builder(
                  itemCount: mytasks.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      confirmDismiss: (direction) async {
                        return true;
                      },
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.redAccent,
                      ),
                      onDismissed: (direction) {
                        deleteTask(mytasks[index].id!);
                      },
                      key: Key(index.toString()),
                      child: ListTile(
                        title: Text(mytasks[index].title),
                        subtitle: Text(mytasks[index].description),
                        trailing: IconButton(
                            onPressed: () {
                              showDialogFrom(context, edit: true);
                            },
                            icon: Icon(Icons.edit)),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
