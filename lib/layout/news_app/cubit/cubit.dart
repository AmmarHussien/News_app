import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_app/cubit/states.dart';
import 'package:news_app/modules/news_app/business/business_screen.dart';
import 'package:news_app/modules/news_app/science/science_screen.dart';
import 'package:news_app/modules/news_app/sports/sports_screen.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';


class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super (NewsInitialState());
  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems =
  [
    BottomNavigationBarItem(
          icon: Icon(
              Icons.business,
            ),
          label: 'Business',
        ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
  ];
  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),

  ];
  void changeBottomNavBar (int index)
  {
     currentIndex = index ;
     if ( index ==1)
       {
         getSports();
       }
     if ( index ==2)
     {
       getScience();
     }
     emit(NewsBottomNavState());
  }
  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];
  List<dynamic> search = [];


  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
        query: {
          'country':'eg',
          'category':'business',
          'apikey':'603424a7303348c3adb446b2d2c88e53',
        },
        url: 'v2/top-headlines'
    ).then((value)
    {
      //print(value.data['articles'] [0] ['title']);
      business = value.data['articles'];
      print(business[0]['title']);

      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  void getSports()
  {
    emit(NewsGetSportsLoadingState());

    if ( sports.length == 0)
    {
      DioHelper.getData(query: {
        'country': 'eg',
        'category': 'sports',
        'apikey': '603424a7303348c3adb446b2d2c88e53',
      }, url: 'v2/top-headlines')
          .then((value) {
        //print(value.data['articles'] [0] ['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);

        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    }
    else
      {
        emit(NewsGetSportsSuccessState());
      }
  }

  void getScience()
  {
    emit(NewsGetScienceLoadingState());

    if ( science.length == 0)
    {
      DioHelper.getData(query: {
        'country': 'eg',
        'category': 'science',
        'apikey': '603424a7303348c3adb446b2d2c88e53',
      }, url: 'v2/top-headlines')
          .then((value) {
        //print(value.data['articles'] [0] ['title']);
        science = value.data['articles'];
        print(science[0]['title']);

        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }
    else
      {
        emit(NewsGetScienceSuccessState());
      }
  }

  void getSearch(String value)
  {

    search = [];
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(query: {
      'q': '$value',
      'apikey': '603424a7303348c3adb446b2d2c88e53',
    }, url: 'v2/everything')
        .then((value) {
      //print(value.data['articles'] [0] ['title']);
      search = value.data['articles'];
      print(search[0]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}