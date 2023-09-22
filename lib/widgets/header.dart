import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String viewState;
  final String beautifiedDate;
  final Function changeState;
  final String beautifiedViewState;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  const Header({Key? key, required this.viewState, required this.beautifiedDate, required this.changeState, required this.beautifiedViewState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (viewState == "d")
              Text(
                beautifiedDate,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              if (viewState == "m") 
              Text(
                beautifiedDate.substring(3),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              if (viewState == "s") 
              const Text(
                "DailyToDo",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Expanded(child: SizedBox(width: 25)),
              TextButton(
                onPressed: () {
                  if (viewState == "d") {
                    changeState("m");
                  } else {
                    changeState("d");
                  }
                },
                child: Text(
                  beautifiedViewState,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(width: 100),
              ),
              IconButton(
                onPressed: () {
                  changeState("s");
                },
                icon: const Icon(Icons.menu_book, color: Colors.black),
              ),
            ],
          ),
        );
  }
}