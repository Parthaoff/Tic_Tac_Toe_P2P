import 'package:flutter/material.dart';
import 'package:tictactoe_p2p/services/networking_service.dart';

class GameScreen extends StatefulWidget {
  final bool isHost;
  const GameScreen({super.key, required this.isHost});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final NetworkingService _networkingService = NetworkingService();
  List<String> _board = List.filled(9, '');
  String _mySymbol = '';
  String _opponentSymbol = '';
  bool _isMyTurn = false;
  bool _isGameOver = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeGame();
    // Listen for moves from the opponent
    _networkingService.opponentMoveNotifier.addListener(_onOpponentMove);
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is removed
    _networkingService.opponentMoveNotifier.removeListener(_onOpponentMove);
    _networkingService.disconnect();
    super.dispose();
  }

  void _initializeGame() {
    _mySymbol = widget.isHost ? 'X' : 'O';
    _opponentSymbol = widget.isHost ? 'O' : 'X';
    _isMyTurn = widget.isHost;
    _statusMessage = _isMyTurn ? "Your Turn ($_mySymbol)" : "Opponent's Turn ($_opponentSymbol)";
  }

  void _onOpponentMove() {
    final moveIndex = _networkingService.opponentMoveNotifier.value;
    if (moveIndex != null) {
      setState(() {
        _board[moveIndex] = _opponentSymbol;
        _isMyTurn = true;
        _checkWinner();
        if (!_isGameOver) {
          _statusMessage = "Your Turn ($_mySymbol)";
        }
      });
    }
  }

  void _makeMove(int index) {
    if (_board[index].isNotEmpty || !_isMyTurn || _isGameOver) {
      return;
    }

    setState(() {
      _board[index] = _mySymbol;
      _isMyTurn = false;
      _networkingService.sendMove(index);
      _checkWinner();
      if (!_isGameOver) {
        _statusMessage = "Opponent's Turn ($_opponentSymbol)";
      }
    });
  }

  // --- (The _checkWinner, _endGame, and _showResultDialog methods are almost the same) ---

  void _checkWinner() {
    const List<List<int>> winningLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];
    for (var line in winningLines) {
      String player = _board[line[0]];
      if (player.isNotEmpty && player == _board[line[1]] && player == _board[line[2]]) {
        String message = (player == _mySymbol) ? 'You Win!' : 'You Lose!';
        _endGame(message);
        return;
      }
    }
    if (!_board.contains('')) {
      _endGame('It\'s a Draw!');
    }
  }

  void _endGame(String message) {
    setState(() {
      _isGameOver = true;
      _statusMessage = message;
    });
    _showResultDialog(message);
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isGameOver = false;
      _initializeGame();
    });
  }

  void _showResultDialog(String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: const Text('Play again?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
                // TODO: Send a "play again" message to the opponent
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to home screen
              },
            ),
          ],
        );
      },
    );
  }

  // --- (The build method is the same, just uses the new state variables) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _statusMessage,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          AbsorbPointer(
            absorbing: !_isMyTurn || _isGameOver,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _makeMove(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          _board[index],
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _board[index] == 'X' ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: const Text('Reset Game (Local)'),
          )
        ],
      ),
    );
  }
}