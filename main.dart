import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yapılacaklar Listesi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoItem> todoItems = [];

  void addTodoItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newItemTitle = '';
        return AlertDialog(
          title: const Text('Yeni İş Ekle'),
          content: TextField(
            onChanged: (value) {
              newItemTitle = value;
            },
            decoration: const InputDecoration(hintText: "İş başlığını girin"),
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ekle'),
              onPressed: () {
                if (newItemTitle.isNotEmpty) {
                  setState(() {
                    todoItems.add(TodoItem(title: newItemTitle));
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapılacaklar Listesi'),
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(todoItems[index].title),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: todoItems[index].subItems.length,
                itemBuilder: (context, subIndex) {
                  return ListTile(
                    title: Text(todoItems[index].subItems[subIndex].title),
                    trailing: todoItems[index].subItems[subIndex].isCompleted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        todoItems[index].subItems[subIndex].isCompleted =
                            !todoItems[index].subItems[subIndex].isCompleted;
                      });
                    },
                  );
                },
              ),
              ListTile(
                title: const Text('Alt başlık ekle'),
                leading: const Icon(Icons.add),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String newSubItemTitle = '';
                      return AlertDialog(
                        title: const Text('Yeni Alt Başlık Ekle'),
                        content: TextField(
                          onChanged: (value) {
                            newSubItemTitle = value;
                          },
                          decoration: const InputDecoration(
                              hintText: "Alt başlık girin"),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('İptal'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Ekle'),
                            onPressed: () {
                              if (newSubItemTitle.isNotEmpty) {
                                setState(() {
                                  todoItems[index].subItems.add(
                                      SubItem(title: newSubItemTitle));
                                });
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodoItem,
        tooltip: 'Yeni İş Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem {
  String title;
  List<SubItem> subItems;

  TodoItem({required this.title, List<SubItem>? subItems})
      : subItems = subItems ?? [];
}

class SubItem {
  String title;
  bool isCompleted;

  SubItem({required this.title, this.isCompleted = false});
}
