import 'dart:io';

import 'package:flutter_codigo_taskbd/models/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBAdmin {
  Database? myDatabase;

  static final DBAdmin db = DBAdmin._();
  DBAdmin._();

  Future<Database?> checkDatabase() async {
    if (myDatabase != null) {
      return myDatabase;
    }
    myDatabase = await initDatabase();
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status TEXT)');
      },
    );
  }

  Future<int> insertRawTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int? res = await db!.rawInsert(
        'INSERT INTO TASK(title, description, status) VALUES ("${model.title}","${model.description}","${model.status.toString()}")');
    return res;
  }

  Future<int> inssertTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.insert('TASK', {
      'title': '${model.title}',
      'description': '${model.description}',
      'status': '${model.status.toString()}',
    });
    return res;
  }

  getRawTask() async {
    Database? db = await checkDatabase();
    List tasks = await db!.rawQuery('SELECT * FROM Task');
    print(tasks);
  }

  Future<List> getTask() async {
    Database? db = await checkDatabase();
    List<Map<String, dynamic>> tasks = await db!.query('Task');
    List<TaskModel> taskModelList =
        tasks.map((e) => TaskModel.deMapAModel(e)).toList();

    /* tasks.forEach((element) {
      taskModelList.add(TaskModel.deMapAModel(element));
    }); */

    return taskModelList;
  }

  updateRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawUpdate(
        'UPDATE TASK SET title= "Ir de compras",description= "Comprar comida",status= "true" where id= 2');
    print(res);
  }

  updateTask(TaskModel model) async {
    Database? db = await checkDatabase();
    int res = await db!.update(
        'TASK',
        {
          'title': '${model.title}',
          'description': '${model.description}',
          'status': '${model.status}',
        },
        where: 'id=${model.id}');
  }

  deleteRawTask() async {
    Database? db = await checkDatabase();
    int res = await db!.rawDelete('DELETE FROM TASK WHERE id=3');
  }

  Future<int> deleteTask(int id) async {
    Database? db = await checkDatabase();
    int res = await db!.delete('TASK', where: 'id=$id');
    return res;
  }
}
