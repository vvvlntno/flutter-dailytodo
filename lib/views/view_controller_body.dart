import 'package:dailytodo/widgets/tutorial.dart';
import 'package:flutter/material.dart';
import 'daily_view.dart';
import '../widgets/add_item.dart';
import 'monthly_view.dart';
import '../models/todo.dart';

class ViewControllerBody extends StatelessWidget {
  final String viewState;
  final List<ToDo> todosList;
  final Function checkDate;
  final Function handleToDoChange;
  final Function deleteToDoItem;
  final todoController;
  final Function addToDoItem;
  final String dateState;
  final Function(String newDateState, String newViewState) updateDateAndViewState; // Callback function

  const ViewControllerBody({
    Key? key,
    required this.viewState,
    required this.todosList,
    required this.checkDate,
    required this.handleToDoChange,
    required this.deleteToDoItem,
    required this.todoController,
    required this.addToDoItem,
    required this.dateState,
    required this.updateDateAndViewState, // Receive the callback function
  }) : super(key: key);

  void handleDateSelection(String selectedDate, String selectedViewState) {
    // Update the date and view state using the callback function
    updateDateAndViewState(selectedDate, selectedViewState);
  }

  @override
  Widget build(BuildContext context) {
    if (viewState == "d") {
      return Stack(
        children: [
          DailyToDoView(
            todosList: todosList,
            checkDate: checkDate,
            handleToDoChange: handleToDoChange,
            deleteToDoItem: deleteToDoItem,
          ),
          AddItem(todoController: todoController, addToDoItem: addToDoItem),
        ],
      );
    } else if (viewState == "m") {
      return Stack(
        children: [
          MonthlyToDoView(
            month: int.parse(dateState.substring(2, 4)),
            year: int.parse(dateState.substring(4)),
            todosList: todosList,
            onDateSelected: handleDateSelection,
          ),
        ],
      );
    } else if (viewState == "s") {
      return Stack(
        children: [
          TutorialWidget(),
        ],
      );
    } else {
      return const Text("Invalid View State");
    }
  }
}