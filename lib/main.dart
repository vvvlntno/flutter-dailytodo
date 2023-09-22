
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import './models/todo.dart';
import './views/view_controller_body.dart';
import './widgets/header.dart';

void main() {
  SystemChrome.setApplicationSwitcherDescription(
    const ApplicationSwitcherDescription(
      label: 'DailyTodo',
      primaryColor: 0xFF673ab7,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, 
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


Future<void> saveToLocalStorage(List<ToDo> todosList) async {
  final prefs = await SharedPreferences.getInstance();
  final todoJsonList = todosList.map((todo) => jsonEncode(todo.toJson())).toList();
  await prefs.setStringList('todos', todoJsonList);
}

Future<List<ToDo>> loadFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final todoJsonList = prefs.getStringList('todos');
  if (todoJsonList == null) {
    return [];
  }
  return todoJsonList.map((json) => ToDo.fromJson(jsonDecode(json))).toList();
}


class _MyHomePageState extends State<MyHomePage> {
  String _viewState = "";
  // d == Day, m == Month, s == Settings
  String _beautifiedViewState = "";
  String _dateState = "";
  String _realDate = "";
  String _beautifiedDate = "";

  bool _isInitialized = false;

  double _startX = 0.0;
  double _currentX = 0.0;

  final List<int> thirtyonemonths = [1, 3, 5, 7, 8, 10, 12];
  final List<int> thirtymonths = [4, 6, 9, 11];
  final List<int> backthirtyonemonths = [1, 2, 4, 6, 8, 9, 11];
  final List<int> backthirtymonths = [5, 7, 10, 12];

  void _changeState(String wantedState) {
    setState(() {
      if (_viewState == "d") {
        if (wantedState == "m") {
          _viewState = "m";
        } else if (wantedState == "s") {
          _viewState = "s";
        }
      } else if (_viewState == "m") {
        if (wantedState == "d") {
          _viewState = "d";
        } else if (wantedState == "s") {
          _viewState = "s";
        }
      } else if (_viewState == "s") {
        if (wantedState == "s") {
          _viewState = "d";
        } else {
          _viewState = wantedState;
        }
      } 
      _beautifyViewState();
    });
  }

  void _beautifyViewState() {
    setState(() {
      if (_viewState == "d") {
        _beautifiedViewState = "Day";
      } else if (_viewState == "m") {
        _beautifiedViewState = "Month";
      } else if (_viewState == "s") {
        _beautifiedViewState = "Tutorial";
      } 
    });
  }

  void _updateStateDate({int changeday = 0, int changemonth = 0}) {
    setState(() {
      var day = int.parse(_dateState.substring(0, 2));
      var month = int.parse(_dateState.substring(2, 4));
      var year = int.parse(_dateState.substring(4));

      var newday = day + changeday;
      var newmonth = month + changemonth;
      var newyear = year;

      if (newday == 0) {
        if (backthirtyonemonths.contains(newmonth)) {
          newday = 31;
          newmonth = newmonth - 1;
          if (newmonth == 0) {
            newmonth = 12;
            newyear = newyear - 1;
          }
        } else if (backthirtymonths.contains(newmonth)) {
          newday = 30;
          newmonth = newmonth - 1;
        } else if (newmonth == 3) {
          newmonth = 2;
          if (newyear % 4 == 0) {
            newday = 29;
          } else {
            newday = 28;
          }
        }
      } else if (newday == 29) {
        if (newmonth == 2) {
          if (newyear % 4 == 0) {
            newday = 29;
            newmonth = 2;
          } else {
            newday = 1;
            newmonth = 3;
          }
        }
      } else if (newday == 30) {
        if (newmonth == 2) {
          if (newyear % 4 == 0) {
            newday = 1;
            newmonth = 3;
          }
        }
      } else if (newday == 31) {
        if (thirtymonths.contains(newmonth)) {
          newday = 1;
          newmonth = newmonth + 1;
        }
      } else if (newday == 32) {
        if (thirtyonemonths.contains(newmonth)) {
          newday = 1;
          newmonth = newmonth + 1;
          if (newmonth == 13) {
            newday = 1;
            newmonth = 1;
            newyear = newyear + 1;
          }
        }
      } else if (newmonth == 0) {
        newmonth = 12;
        newyear = newyear - 1;
      } else if (newmonth == 13) {
        newmonth = 1;
        newyear = newyear + 1;
      } 
  
      var sday = newday.toString();
      if (sday.length == 1) {sday = '0$sday';}
      var smonth = newmonth.toString();
      if (smonth.length == 1) {smonth = '0$smonth';}
      var syear = newyear.toString();

      _dateState = "$sday$smonth$syear";
    });
  }

  void _setRealDate() {
    setState(() {
      DateTime now = DateTime.now();
      int day = now.day;
      int month = now.month;
      int year = now.year;
      String smonth = month.toString();
      if (smonth.length == 1) {smonth = '0$month';}

      _realDate = '$day$smonth$year';
    });
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      saveToLocalStorage(todosList);
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      saveToLocalStorage(todosList);
    });
  }

  void _addToDoItem(String name) {
    setState(() {
      var id = _dateState;
      var inumber = todosList.where((todoo) => _checkDate(todoo)).toList().length + 1;
      var number = inumber.toString();
      if (number.length == 1) {
        number = "00$number";
      } else if (number.length == 2) {
        number = "0$number";
      } 
      var time = DateTime.now().millisecondsSinceEpoch.toString();
      var fullid = "$id-$number-$time";
      todosList.add(ToDo(
        id: fullid,
        todoText: name,
        ));
      saveToLocalStorage(todosList);
    });
    
    _todoController.clear();
  }

  bool _checkDate(ToDo item) {
    if (item.id != null && item.id!.startsWith(_dateState)) {
      return true;
    } 
    return false;
  }

  void _handleSwipeGesture() {
    const double swipeThreshold = 100.0;

    final double deltaX = _currentX - _startX;

    if (_viewState == "d") {
      if (deltaX > swipeThreshold) {
        _updateStateDate(changeday: -1);
      } else if (deltaX < -swipeThreshold) {
        _updateStateDate(changeday: 1);
      }
    } else if (_viewState == "m") {
      if (deltaX > swipeThreshold) {
        _updateStateDate(changemonth: -1);
      } else if (deltaX < -swipeThreshold) {
        _updateStateDate(changemonth: 1);
      }
    } 
  }

  void _initdateState() {
    setState(() {
      if(!_isInitialized) {
        _viewState = "d";
        _beautifyViewState();
        _dateState = _realDate;
        _isInitialized = true;
        loadFromLocalStorage().then((loadedTodos) {
        setState(() {
          todosList.clear();
          todosList.addAll(loadedTodos);
        });
      });
      }
    });
  }

  void _beautifyDate() {
    setState(() {
      _beautifiedDate = "${_dateState.substring(0,2)}.${_dateState.substring(2,4)}.${_dateState.substring(4)}";
    });
  }

  void updateDateAndViewState(String newDateState, String newViewState) {
    setState(() {
      _dateState = newDateState;
      _changeState(newViewState);
    });
  }

  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _setRealDate();
    _initdateState();
    _beautifyDate();
    return GestureDetector(
       onHorizontalDragStart: (details) {
        _startX = details.localPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        _currentX = details.localPosition.dx;
      },
      onHorizontalDragEnd: (details) {
        _handleSwipeGesture();
      },
      child: Scaffold(
        appBar: Header(viewState: _viewState, beautifiedDate: _beautifiedDate, changeState: _changeState, beautifiedViewState: _beautifiedViewState),
        body: ViewControllerBody(viewState: _viewState, todosList: todosList, checkDate: _checkDate, handleToDoChange: _handleToDoChange, deleteToDoItem: _deleteToDoItem, todoController: _todoController, addToDoItem: _addToDoItem, dateState: _dateState, updateDateAndViewState: updateDateAndViewState)
        ),
    );
  }
}
