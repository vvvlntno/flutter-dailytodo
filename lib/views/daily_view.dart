import 'package:flutter/material.dart';
import '../widgets/todo_item.dart';

class DailyToDoView extends StatelessWidget {
  final List todosList;
  final Function checkDate;
  final Function handleToDoChange;
  final Function deleteToDoItem;

  const DailyToDoView({Key? key, required this.todosList, required this.checkDate, required this.handleToDoChange, required this.deleteToDoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: todosList
                      .where((todoo) => !todoo.isDone)
                      .where((todoo) => checkDate(todoo))
                      .map((todoo) => ToDoItem(
                            todo: todoo,
                            onToDoChanged: handleToDoChange,
                            onDeleteItem: deleteToDoItem,
                          ))
                      .toList(),
                ),
                if (todosList
                  .where((todoo) => todoo.isDone)
                  .where((todoo) => checkDate(todoo))
                  .isNotEmpty &&
                  todosList
                  .where((todoo) => !todoo.isDone)
                  .where((todoo) => checkDate(todoo))
                  .isNotEmpty) // Hier wird geprüft, ob sowohl erledigte als auch nicht erledigte Elemente vorhanden sind
                const Divider(
                  height: 0.0,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: todosList
                        .where((todoo) => todoo.isDone)
                        .where((todoo) => checkDate(todoo))
                        .map((todoo) => ToDoItem(
                              todo: todoo,
                              onToDoChanged: handleToDoChange,
                              onDeleteItem: deleteToDoItem,
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}