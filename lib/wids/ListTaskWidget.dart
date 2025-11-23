import 'package:flutter/material.dart';

class ListTaskWidget extends StatefulWidget {

  final String text;
  final VoidCallback onDelete;

  const ListTaskWidget({super.key, required this.text, required this.onDelete});



  @override
  State<ListTaskWidget> createState() => _ListTaskWidgetState();
}

class _ListTaskWidgetState extends State<ListTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${widget.text}"),
          IconButton(onPressed: widget.onDelete, icon: Icon(Icons.delete))
        ],
      ),
    );
  }
}
