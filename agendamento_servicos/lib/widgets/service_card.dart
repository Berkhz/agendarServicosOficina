import 'package:flutter/material.dart';
import '../models/servico.dart';

class ServiceCard extends StatelessWidget {
  final Servico servico;
  final VoidCallback? onDelete;

  const ServiceCard({required this.servico, this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              servico.tipo,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Data: ${servico.data}'),
            Text('Hora: ${servico.hora}'),
            Text('Status: ${servico.status}'),
            if (onDelete != null)
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }
}