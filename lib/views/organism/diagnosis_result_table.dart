import 'package:flutter/material.dart';

class DiagnosisResultTable extends StatelessWidget {
  final String title;
  final List<Map<String, String>> rows; // Each map: {item, value, definition}

  const DiagnosisResultTable({required this.title, required this.rows, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        Table(
          border: TableBorder.all(
            color: Colors.blueGrey.shade400,
            width: 1.5,
            borderRadius: BorderRadius.circular(6),
          ),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(4),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.15),
              ),
              children: <Widget>[
                _tableHeader('Items'),
                _tableHeader('Value'),
                _tableHeader('Definition'),
              ],
            ),
            ...rows.map((Map<String, String> row) => TableRow(
              children: <Widget>[
                _tableCell(row['item'] ?? ''),
                _tableCell(row['value'] ?? ''),
                _tableCell(row['definition'] ?? ''),
              ],
            )),
          ],
        ),
      ],
    );
  }

  Widget _tableHeader(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );

  Widget _tableCell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    ),
  );
} 