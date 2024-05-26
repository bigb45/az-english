import 'package:ez_english/features/levels/data/upload_data_viewmodel.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Results extends StatefulWidget {
  const Results({super.key});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late UploadDataViewmodel _dataViewmodel;
  @override
  void initState() {
    _dataViewmodel = Provider.of<UploadDataViewmodel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              Level? level = await _dataViewmodel.parseData();
              await _dataViewmodel.saveLevelToFirestore(level!);
            },
            child: Text("Add data"),
          ),
          Center(
            child: Text('Results'),
          ),
        ],
      ),
    );
  }
}
