import 'package:flutter/material.dart';
import '../models/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;

  const ToDoItem({Key? key, required this.todo, required this.onToDoChanged, required this.onDeleteItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // print('Clicke item ${todo.id}');
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: todo.isDone? Colors.grey[350] : Colors.grey[200],
        leading: Icon(
          todo.isDone? Icons.check_box : Icons.check_box_outline_blank, 
          color: Colors.deepPurple,),
        title: Text(
          todo.todoText!, 
          style: TextStyle(
              fontSize: 16, 
              color: Colors.black, 
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
          ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5)
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: () {
              // print("Deleted item ${todo.id}");
              onDeleteItem(todo.id);
            },
          ),
        ),
        
      )
    );
  }
}