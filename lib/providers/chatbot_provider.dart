import 'package:flutter/material.dart';
import '../data/models/chat_message.dart';
import '../data/repositories/chatbot_repository.dart';

class ChatbotProvider extends ChangeNotifier {
  final ChatbotRepository _repository;

  ChatbotProvider(this._repository);

  // State
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with welcome message
  void initialize() {
    if (_messages.isEmpty) {
      _messages.add(
        ChatMessage(
          message: 'Xin chào! Tôi là PawVerse Assistant. Tôi có thể giúp gì cho bạn về thú cưng hôm nay?',
          isUser: false,
        ),
      );
      notifyListeners();
    }
  }

  // Send message
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    _messages.add(
      ChatMessage(
        message: message.trim(),
        isUser: true,
      ),
    );
    notifyListeners();

    // Set loading state
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Call API
      final botResponse = await _repository.sendMessage(message.trim());

      // Add bot response
      _messages.add(
        ChatMessage(
          message: botResponse,
          isUser: false,
        ),
      );
    } catch (e) {
      _error = e.toString();
      
      // Add error message to chat
      _messages.add(
        ChatMessage(
          message: 'Xin lỗi, tôi đang gặp sự cố kết nối. Vui lòng thử lại sau.',
          isUser: false,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear chat
  void clearChat() {
    _messages.clear();
    initialize();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
