import 'package:flutter/material.dart';
import 'card_model.dart';

class GameProvider with ChangeNotifier {
  final List<CardModel> _cards = [];
  CardModel? _firstFlippedCard;
  int _score = 0;
  bool _isProcessing = false;

  GameProvider() {
    _initializeCards();
  }

  List<CardModel> get cards => _cards;
  int get score => _score;

  void _initializeCards() {
    List<String> images = [
      'assets/images/card1.png',
      'assets/images/card2.png',
      'assets/images/card3.png',
      'assets/images/card4.png',
    ];

    for (var img in images) {
      _cards.add(CardModel(imagePath: img));
      _cards.add(CardModel(imagePath: img)); // Add pairs
    }

    _cards.shuffle();
  }

  void flipCard(int index) {
    if (_isProcessing || _cards[index].isMatched || _cards[index].isFaceUp)
      return;

    _cards[index].isFaceUp = true;
    notifyListeners();

    if (_firstFlippedCard == null) {
      _firstFlippedCard = _cards[index];
    } else {
      _isProcessing = true;
      Future.delayed(const Duration(seconds: 1), () {
        if (_firstFlippedCard!.imagePath == _cards[index].imagePath) {
          _firstFlippedCard!.isMatched = true;
          _cards[index].isMatched = true;
          _score += 10;
        } else {
          _firstFlippedCard!.isFaceUp = false;
          _cards[index].isFaceUp = false;
          _score -= 5;
        }
        _firstFlippedCard = null;
        _isProcessing = false;
        notifyListeners();
      });
    }
  }

  bool checkWin() {
    return _cards.every((card) => card.isMatched);
  }

  void resetGame() {
    _firstFlippedCard = null;
    _score = 0;
    _isProcessing = false;
    _initializeCards();
    notifyListeners();
  }
}
