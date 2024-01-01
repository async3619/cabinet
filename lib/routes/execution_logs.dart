import 'package:flutter/material.dart';

class ExecutionLogsRoute extends StatefulWidget {
  const ExecutionLogsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ExecutionLogsRoute> createState() => _ExecutionLogsRouteState();
}

class _ExecutionLogsRouteState extends State<ExecutionLogsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Execution Logs'),
      ),
    );
  }
}
