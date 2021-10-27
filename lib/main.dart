import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/bloc_observer.dart';
import 'package:news_app/shared/compmnant/conestants.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cashe_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/styles/themes.dart';

import 'layout/news_app/cubit/cubit.dart';
import 'layout/news_app/news_layout.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;

  bool? isDark = CacheHelper.getDate(key: 'isDark');

  //String token = CacheHelper.getDate(key: 'token');
  bool onBoarding = CacheHelper.getDate(key: 'onBoarding');

  token =  CacheHelper.getDate(key: 'token');



  runApp(MyApp(
    isDark: isDark,

  ));
}
class MyApp extends StatelessWidget
{

  bool? isDark;

  MyApp({Key? key,
    this.isDark,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()..changeAppMode(
          fromShared: isDark,
        ),
        ),
        BlocProvider(
          create: (context) =>  NewsCubit()..getBusiness()..getSports()..getScience(),),

      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context , state ){},
        builder:(context , state )
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false ,
            theme: lightTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.light: ThemeMode.dark,
            darkTheme: darkTheme,
            home: NewsLayout(),
          );
        } ,

      ),
    );

  }

}