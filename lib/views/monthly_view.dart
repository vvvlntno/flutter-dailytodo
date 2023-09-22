import 'package:flutter/material.dart';
import '../models/todo.dart';

class MonthlyToDoView extends StatelessWidget {
  final int year;
  final int month;
  final List<ToDo> todosList;
  final Function(String selectedDate, String selectedViewState) onDateSelected;

  const MonthlyToDoView({
    Key? key,
    required this.year,
    required this.month,
    required this.todosList,
    required this.onDateSelected,
  }) : super(key: key);

  Map<int, Map<String, int>> calculateCompletedPerDay(
    List<ToDo> todos,
    String key,
  ) {
    final Map<int, Map<String, int>> completedData = {};

    for (int day = 1; day <= 31; day++) {
      completedData[day] = {'completed': 0, 'total': 0};
    }

    final filteredTodos = todos.where((todo) {
      if (todo.id != null) {
        final todoKey = todo.id!.substring(2, 8);
        return todoKey == key;
      }
      return false;
    });

    for (final todo in filteredTodos) {
      if (todo.id != null) {
        final day = int.parse(todo.id!.substring(0, 2));
        completedData[day] ??= {'completed': 0, 'total': 0};
        completedData[day]!['total'] = (completedData[day]!['total'] ?? 0) + 1;
        if (todo.isDone) {
          completedData[day]!['completed'] = (completedData[day]!['completed'] ?? 0) + 1;
        }
      }
    }

    return completedData;
  }

  Map<int, Map<String, int>> _calculateCompletedData(
    List<ToDo> todos, 
    String key,
  ) {
    final completedData = calculateCompletedPerDay(todos, key);
    return completedData;
  }

  @override
  Widget build(BuildContext context) {
    final monthKey = '${month.toString().padLeft(2, '0')}$year';

    final completedData = _calculateCompletedData(todosList, monthKey);
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final List<int> dayNumbers = List.generate(daysInMonth, (index) => index + 1);

    final List<String> dayNames = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${_getMonthName(month)} $year',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: dayNames.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 columns for each day of the week
            ),
            itemBuilder: (context, index) {
              final day = dayNumbers[index];
              final data = completedData[index + 1];
              final completedCount = data != null ? data['completed'] : 0;
              final totalCount = data != null ? data['total'] : 0;
              final displayText = '$completedCount/$totalCount';
              
              final anyAtAll = completedCount != 0 && totalCount != 0 ? true : false;
              final allCompleted = completedCount == totalCount ? true : false; 
              var color = Colors.blue[200];

              if (anyAtAll) {
                color = Colors.red[300];
                if (allCompleted) {
                  color = Colors.green[300];
                }
              } 

              final gridkey = '${day.toString().padLeft(2, '0')}${month.toString().padLeft(2, '0')}$year';

              return GestureDetector(
                onTap: () {
                  onDateSelected(gridkey, "d");
                },
                child: GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: color, 
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Text(
                            day.toString(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Text(
                            displayText,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ), 
                ),
              );
            },
            itemCount: daysInMonth,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}