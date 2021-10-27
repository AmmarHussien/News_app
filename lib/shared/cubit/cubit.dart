import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cashe_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialStat());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0 ;
 
  void ChangeIndex ( int index)
  {
    currentIndex = index ;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void createDatabase()
   {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version)
      {
        print('database created ');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT, status TEXT )').then((value)
        {
          print('table created');
        }).catchError((error)
        {
          print('error when Creating Tabble ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        GetDataFromDataBase(database);
        print('database opened ');
      },
    ).then((value)
    {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }
  insertDatabase({
    required String title,
    required String time,
    required String date,
  })
  async {
    await database.transaction((txn)
    async {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDataBaseState());
        GetDataFromDataBase(database);
      }).catchError((error)
      {
        print('error when Inserting New Record ${error.toString()}');
      });

    });
  }


  void GetDataFromDataBase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks= [];
    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {

      value.forEach((element) {
        if(element['status'] == 'new' )
       {
         newTasks.add(element);
       }else if(element['status'] == 'done' )
        {
          doneTasks.add(element);
        }else {
         archivedTasks.add(element);
       }
      });
      emit(AppGetDataBaseState());
    });
  }

  void deleteData({
    required int id,
})
  async {
     database.rawDelete(
      'DELETE FROM tasks WHERE ID = ?',
      [ id ],
    ).then((value)
     {
       GetDataFromDataBase(database);
       emit(AppDeleteDataBaseState());
     });
  }

  void updateData({
    required String status,
    required int id,
  })
  async {
    database.rawUpdate(
      'UPDATE tasks SET status = ?  WHERE id = ?',
      ['$status', id ],
    ).then((value)
    {
      GetDataFromDataBase(database);
      emit(AppUpdateDataBaseState());
    });
  }



  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState ({
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomSheetShown =isShow;
    fabIcon = icon ;
    emit(AppChangeBottomSheetState());
  }
  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if(fromShared != null)
      {
        isDark = fromShared;
        emit(AppChangeModeState());
      }
    else
      {
        isDark =!isDark;
        CacheHelper.putBool(key: 'isDark', value: isDark).then((value)
        {
          emit(AppChangeModeState());
        });
      }

  }
}