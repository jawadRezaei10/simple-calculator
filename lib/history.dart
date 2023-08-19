import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final Box<List<String>> history;
  late List<String> calcs;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      history = await Hive.openBox<List<String>>('history');
      calcs = history.get('calcs') ?? [];
      setState(() => isLoading = false);
    });
  }

  void delete(int index) {
    setState(() {
      calcs.removeAt(index);
    });
    history.put('calcs', calcs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.amber,
            ))
          : calcs.length == 0
              ? const Center(
                  child: Text('No item!',
                      style: TextStyle(color: Colors.white, fontSize: 25)))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  physics: BouncingScrollPhysics(),
                  itemCount: calcs.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Text(calcs[index],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25)),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => delete(index),
                        ),
                      )),
    );
  }
}
