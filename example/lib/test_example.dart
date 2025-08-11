import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Jednoduchá service s nějakým stavem
class CounterService with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider v popupu',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _showCustomPopup(BuildContext context) {
    // voláme přímo z kontextu, kde je Provider => uvnitř popupu bude dostupný
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Popup s Providerem'),
          content: PopupContent(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Provider v popupu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Počet: ${counter.count}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCustomPopup(context),
              child: const Text('Otevřít popup'),
            ),
          ],
        ),
      ),
    );
  }
}

class PopupContent extends StatelessWidget {
  const PopupContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterService>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Počet v popupu: ${counter.count}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => counter.increment(),
          child: const Text('Přidat'),
        ),
      ],
    );
  }
}
