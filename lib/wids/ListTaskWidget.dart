import 'package:flutter/material.dart';

class ListTaskWidget extends StatefulWidget {

  final String text;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ListTaskWidget({super.key, required this.text, required this.onDelete, required this.onEdit});



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
          IconButton(onPressed: widget.onEdit, icon: Icon(Icons.edit)),
          Text("${widget.text}"),
          IconButton(onPressed: widget.onDelete, icon: Icon(Icons.delete))
        ],
      ),
    );
  }
}
