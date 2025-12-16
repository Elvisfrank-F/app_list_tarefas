import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:tarefas/funcs/gerarPdf_func.dart';
import 'package:tarefas/controllers/task_controller.dart';

class PdfViewPagePdf extends StatelessWidget {

 final TaskController controller;
  const PdfViewPagePdf({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview to PDF"),
      ),
    body: PdfPreview(build: (format) async {

      return await GerarpdfFunc(controller).gerarPdfBytes();


    }),
    );
  }
}
