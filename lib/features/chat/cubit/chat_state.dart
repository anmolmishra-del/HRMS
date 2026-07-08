import 'package:equatable/equatable.dart';
import '../models/chat_model.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatChannel> channels;
  final List<ChatChannel> directMessages;
  final List<ChatMessage> activeMessages;
  final String? errorMessage;
  final String? currentChatId;
  final int? partnerLastSeenMessageId;
  final bool isUploading;
  final int uploadProgress;

  const ChatState({
    this.status = ChatStatus.initial,
    this.channels = const [],
    this.directMessages = const [],
    this.activeMessages = const [],
    this.errorMessage,
    this.currentChatId,
    this.partnerLastSeenMessageId,
    this.isUploading = false,
    this.uploadProgress = 0,
  });

  static const _clearString = Object();
  static const _clearInt = Object();

  ChatState copyWith({
    ChatStatus? status,
    List<ChatChannel>? channels,
    List<ChatChannel>? directMessages,
    List<ChatMessage>? activeMessages,
    String? errorMessage,
    Object? currentChatId = _clearString,
    Object? partnerLastSeenMessageId = _clearInt,
    bool? isUploading,
    int? uploadProgress,
  }) {
    return ChatState(
      status: status ?? this.status,
      channels: channels ?? this.channels,
      directMessages: directMessages ?? this.directMessages,
      activeMessages: activeMessages ?? this.activeMessages,
      errorMessage: errorMessage ?? this.errorMessage,
      currentChatId: identical(currentChatId, _clearString)
          ? this.currentChatId
          : currentChatId as String?,
      partnerLastSeenMessageId: identical(partnerLastSeenMessageId, _clearInt)
          ? this.partnerLastSeenMessageId
          : partnerLastSeenMessageId as int?,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  ChatState clearCurrentChat() {
    return ChatState(
      status: status,
      channels: channels,
      directMessages: directMessages,
      activeMessages: const [],
      errorMessage: errorMessage,
      currentChatId: null,
      partnerLastSeenMessageId: null,
      isUploading: false,
      uploadProgress: 0,
    );
  }

  ChatState clearErrorMessage() {
    return ChatState(
      status: status,
      channels: channels,
      directMessages: directMessages,
      activeMessages: activeMessages,
      errorMessage: null,
      currentChatId: currentChatId,
      partnerLastSeenMessageId: partnerLastSeenMessageId,
      isUploading: isUploading,
      uploadProgress: uploadProgress,
    );
  }

  @override
  List<Object?> get props => [
    status,
    channels,
    directMessages,
    activeMessages,
    errorMessage,
    currentChatId,
    partnerLastSeenMessageId,
    isUploading,
    uploadProgress,
  ];
}
