import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

// Example

class TextScreen extends StatelessWidget {
  const TextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int counter = context.watch<CounterProvider>().count;
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.go('/login'); // Navigate to login when clicked
          },
          child: Column(
            children: [
              Text(
                'Counter Value: $counter',
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'one',
                    onPressed: () =>
                        context.read<CounterProvider>().increment(),
                    tooltip: 'Increment',
                    child: Icon(Icons.add),
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: 'two',
                    onPressed: () =>
                        context.read<CounterProvider>().decrement(),
                    tooltip: 'Decrement',
                    child: Icon(Icons.remove),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
