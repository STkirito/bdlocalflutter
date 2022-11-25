import 'package:flutter/material.dart';
import 'package:flutter_codigo_taskbd/db/db_admin.dart';
import 'package:flutter_codigo_taskbd/models/task_model.dart';
import 'package:get/get.dart';

class MyFormWidget extends StatefulWidget {
  TaskModel? model;
  MyFormWidget({this.model, super.key});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  final _formKey = GlobalKey<FormState>();

  bool isFinished = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    if (widget.model != null) {
      _titleController.text = widget.model!.title;
      _descriptionController.text = widget.model!.description;
      isFinished = widget.model!.status == 'true' ? true : false;
    }

    super.initState();
  }

  addTask() {
    if (_formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
          title: _titleController.text,
          description: _descriptionController.text,
          status: isFinished.toString());
      DBAdmin.db.inssertTask(taskModel).then((value) {
        if (value > 0) {
          Get.back();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: Duration(milliseconds: 1200),
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(widget.model != null
                      ? 'Tarea modificada con éxito'
                      : 'Tarea registrada con éxito')
                ],
              )));
        }
        print(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.model != null ? 'Modificar tarea' : 'Agregar tarea'),
            SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Titulo'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                return null;
              },
            ),
            SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(hintText: 'Description'),
              validator: (value) {
                if (value!.isEmpty) {
                  return "El campo es obligatorio";
                }
                return null;
              },
            ),
            SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                Text('Estado: '),
                SizedBox(
                  width: 6.0,
                ),
                Checkbox(
                    value: isFinished,
                    onChanged: (value) {
                      isFinished = value!;
                      setState(() {});
                    }),
              ],
            ),
            SizedBox(
              height: 6.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Get.back(), child: Text('Cancelar')),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      addTask();
                    },
                    child: Text('Aceptar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
