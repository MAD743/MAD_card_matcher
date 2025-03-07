import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'game_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Card Matching Game',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Matching Game')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Consumer<GameProvider>(
            builder: (context, game, child) {
              return Text('Score: ${game.score}',
                  style: const TextStyle(fontSize: 20));
            },
          ),
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, game, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: game.cards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => game.flipCard(index),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          final rotateAnim =
                              Tween(begin: pi, end: 0.0).animate(animation);
                          return AnimatedBuilder(
                            animation: rotateAnim,
                            builder: (context, child) {
                              final isUnder = (rotateAnim.value > pi / 2);
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(rotateAnim.value),
                                child: isUnder
                                    ? Container(
                                        color: Colors.blue,
                                        child: const Icon(Icons.help, size: 50))
                                    : child,
                              );
                            },
                            child: game.cards[index].isFaceUp ||
                                    game.cards[index].isMatched
                                ? Image.asset(game.cards[index].imagePath,
                                    fit: BoxFit.cover)
                                : Container(
                                    color: Colors.blue,
                                    child: const Icon(Icons.help, size: 50)),
                          );
                        },
                        child: game.cards[index].isFaceUp ||
                                game.cards[index].isMatched
                            ? Image.asset(game.cards[index].imagePath,
                                fit: BoxFit.cover)
                            : Container(
                                color: Colors.blue,
                                child: const Icon(Icons.help, size: 50)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).resetGame();
            },
            child: const Text("Restart Game"),
          ),
        ],
      ),
    );
  }
}
