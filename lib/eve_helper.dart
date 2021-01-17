import 'file:///F:/work/IdeaProjects/eve_helper/lib/views/tool_selection_views/tool_selection_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EVEHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVE Helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ToolSelectionView(),
    );
  }
}