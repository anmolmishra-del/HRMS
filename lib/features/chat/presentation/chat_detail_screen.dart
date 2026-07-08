import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'dart:io';
import '../models/chat_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatChannel channel;
  const ChatDetailScreen({super.key, required this.channel});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatAttachment> _pendingAttachments = [];
  int _lastMessageCount = 0;
  late ChatCubit _chatCubit;
  ChatMessage? _replyingToMessage;
  int? _highlightedMessageId;

  void _scrollToMessage(int messageId) {
    final messages = _chatCubit.state.activeMessages;
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    double offset = 0.0;
    for (int i = 0; i < index; i++) {
      final msg = messages[i];
      double height = 85.0; // base height

      if (msg.message.length > 45) {
        height += (msg.message.length / 45).floor() * 20.0;
      }

      if (msg.parentId != null) {
        height += 60.0;
      }

      if (msg.attachments != null && msg.attachments!.isNotEmpty) {
        final hasImage = msg.attachments!.any((a) => a.mimeType?.startsWith('image/') ?? false);
        if (hasImage) {
          height += 210.0;
        } else {
          height += msg.attachments!.length * 50.0;
        }
      }
      offset += height;
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    setState(() {
      _highlightedMessageId = messageId;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _highlightedMessageId = null;
        });
      }
    });
  }

  void _onMessageTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.fetchMessages(widget.channel.id);
    _messageController.addListener(_onMessageTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageTextChanged);
    // Safely clear the active chat using the stored cubit reference
    _chatCubit.clearActiveChat(widget.channel.id);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // Since list is reversed, 0.0 is the bottom
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: true,
      withData: false,
    );

    if (result != null) {
      for (var file in result.files) {
        if (file.path != null) {
          try {
            final bytes = await File(file.path!).readAsBytes();
            setState(() {
              _pendingAttachments.add(ChatAttachment(
                id: 0,
                name: file.name,
                bytes: bytes,
                mimeType: lookupMimeType(file.name) ?? 'application/octet-stream',
              ));
            });
          } catch (e) {
            debugPrint('Failed to read file: $e');
          }
        }
      }
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _pendingAttachments.removeAt(index);
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _pendingAttachments.isEmpty) return;

    final attachmentsCopy = List<ChatAttachment>.from(_pendingAttachments);
    final parentId = _replyingToMessage?.id;

    _messageController.clear();
    setState(() {
      _pendingAttachments.clear();
      _replyingToMessage = null; // Reset reply state
    });

    // Trigger sending in the background without awaiting it to block the scroll action
    _chatCubit.sendMessage(
      widget.channel.id, 
      text,
      attachments: attachmentsCopy.isNotEmpty ? attachmentsCopy : null,
      parentId: parentId,
    );
    
    // Scroll to the bottom instantly so the user sees their optimistically added message
    _scrollToBottom();
  }

  Widget _buildReplyPreviewArea() {
    if (_replyingToMessage == null) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.indigo,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _replyingToMessage!.isMe ? 'Replying to yourself' : 'Replying to ${_replyingToMessage!.sender}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _replyingToMessage!.attachments != null && _replyingToMessage!.attachments!.isNotEmpty
                      ? (_replyingToMessage!.message.isNotEmpty ? _replyingToMessage!.message : 'Attachment')
                      : _replyingToMessage!.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
            onPressed: () {
              setState(() {
                _replyingToMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      appBar: _buildAppBar(context),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 4),
              ),
            );
            context.read<ChatCubit>().clearErrorMessage();
          }
          if (state.status == ChatStatus.loaded && state.activeMessages.length != _lastMessageCount) {
            _lastMessageCount = state.activeMessages.length;
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          final isCurrentChat = state.currentChatId == widget.channel.id.toString();
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (!isCurrentChat || (state.status == ChatStatus.loading && state.activeMessages.isEmpty)) {
                          final isDark = Theme.of(context).brightness == Brightness.dark;
                          return Shimmer.fromColors(
                            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                            child: ListView.builder(
                              reverse: true,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                final isMe = index % 2 == 0;
                                return Align(
                                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width * 0.55,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomLeft: Radius.circular(isMe ? 20 : 0),
                                        bottomRight: Radius.circular(isMe ? 0 : 20),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        if (state.activeMessages.isEmpty && state.status == ChatStatus.loaded) {
                          return _buildEmptyChat(context);
                        } 

                        return ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          itemCount: state.activeMessages.length,
                          itemBuilder: (context, index) {
                            final message = state.activeMessages[index];
                            ChatMessage? parentMessage;
                            if (message.parentId != null) {
                              try {
                                parentMessage = state.activeMessages.firstWhere((m) => m.id == message.parentId);
                              } catch (_) {}
                            }
                            return SwipeToReply(
                              onRightSwipe: () {
                                setState(() {
                                  _replyingToMessage = message;
                                });
                              },
                              child: _MessageBubble(
                                key: ValueKey(message.id), 
                                message: message,
                                parentMessage: parentMessage,
                                isHighlighted: _highlightedMessageId == message.id,
                                onQuoteTap: (parentId) => _scrollToMessage(parentId),
                                onReplySelected: (msg) {
                                  setState(() {
                                    _replyingToMessage = msg;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (_pendingAttachments.isNotEmpty) _buildAttachmentPreview(),
                  if (_replyingToMessage != null) _buildReplyPreviewArea(),
                  _buildInputArea(context),
                ],
              ),
              if (state.isUploading)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.indigo,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Uploading file... ${state.uploadProgress}%',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: state.uploadProgress / 100,
                              backgroundColor: Colors.grey[200],
                              color: AppColors.indigo,
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: isDark ? Theme.of(context).appBarTheme.backgroundColor : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          _buildSmallAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.channel.displayName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.channel.type == ChannelType.chat 
                      ? (widget.channel.imStatus == 'online' ? l10n.online : l10n.offline) 
                      : '${widget.channel.memberCount} members',
                  style: TextStyle(
                    fontSize: 12, 
                    color: widget.channel.imStatus == 'online' ? Colors.green : Colors.grey
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam_rounded, color: AppColors.indigo),
          onPressed: () => _showFeatureSoon(context, 'Video Call'),
        ),
        IconButton(
          icon: const Icon(Icons.phone_rounded, color: AppColors.indigo, size: 20),
          onPressed: () => _showFeatureSoon(context, 'Voice Call'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showFeatureSoon(BuildContext context, String feature) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.feature_coming_soon(feature)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.indigo,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSmallAvatar() {
    if (widget.channel.image != null && widget.channel.image != "false" && widget.channel.image!.isNotEmpty) {
      try {
        final cleanedDatas = widget.channel.image!.trim().replaceAll(RegExp(r'\s+'), '');
        final actualBase64 = cleanedDatas.contains(',') ? cleanedDatas.split(',').last : cleanedDatas;
        final bytes = base64Decode(actualBase64);
        if (bytes.isEmpty) throw 'Empty image data';
        return CircleAvatar(
          radius: 18,
          child: ClipOval(
            child: Image.memory(
              bytes,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildDefaultSmallAvatarContent(),
            ),
          ),
        );
      } catch (e) {
        return _buildDefaultSmallAvatar();
      }
    }
    return _buildDefaultSmallAvatar();
  }

  Widget _buildDefaultSmallAvatarContent() {
    return Center(
      child: Text(
        widget.channel.displayName.isNotEmpty ? widget.channel.displayName[0].toUpperCase() : '?',
        style: const TextStyle(color: AppColors.indigo, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDefaultSmallAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.indigo.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: _buildDefaultSmallAvatarContent(),
    );
  }

  Widget _buildEmptyChat(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 64, color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(l10n.say_hello, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pendingAttachments.length,
        itemBuilder: (context, index) {
          final att = _pendingAttachments[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.indigo.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.indigo.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attach_file_rounded, size: 14, color: AppColors.indigo),
                const SizedBox(width: 6),
                Text(
                  att.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _removeAttachment(index),
                  child: const Icon(Icons.cancel_rounded, size: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
              child: IconButton(
                onPressed: _pickFiles, 
                icon: const Icon(Icons.add, color: AppColors.indigo),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.type_a_message,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            (() {
              final isSendEnabled = _messageController.text.trim().isNotEmpty || _pendingAttachments.isNotEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSendEnabled ? AppColors.indigo : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: isSendEnabled ? _sendMessage : null,
                  icon: Icon(
                    Icons.send_rounded,
                    color: isSendEnabled ? Colors.white : Colors.grey[600],
                    size: 20,
                  ),
                ),
              );
            })(),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatMessage? parentMessage;
  final ValueChanged<ChatMessage> onReplySelected;
  final bool isHighlighted;
  final ValueChanged<int>? onQuoteTap;
  
  const _MessageBubble({
    super.key, 
    required this.message, 
    this.parentMessage, 
    required this.onReplySelected,
    this.isHighlighted = false,
    this.onQuoteTap,
  });

  void _showMessageOptions(BuildContext context, ChatMessage message, ValueChanged<ChatMessage> onReplySelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Rename builder context parameter from 'context' to 'sheetContext' to avoid variable shadowing
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.reply_rounded, color: AppColors.indigo),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  onReplySelected(message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_rounded, color: Colors.grey),
                title: const Text('Copy text'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Clipboard.setData(ClipboardData(text: message.message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message copied')),
                  );
                },
              ),
              // Check if the message belongs to the current user (message.isMe)
              // If so, show the "Delete Message" option in the long-press menu
              if (message.isMe)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  title: const Text('Delete Message', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    // Close the bottom sheet using its own sheetContext
                    Navigator.pop(sheetContext);
                    // Pass the stable parent 'context' (which belongs to the screen)
                    // instead of the deactivated sheetContext to prevent element lookup exceptions
                    _showDeleteConfirmation(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Confirmation dialog helper to prevent accidental message deletions
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text('Are you sure you want to delete this message? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // BUG FIX: Capture the ChatCubit and ScaffoldMessenger reference before any pop or async gap.
                // This prevents "deactivated widget's ancestor lookup" or "use across async gaps" exceptions.
                final chatCubit = context.read<ChatCubit>();
                final messenger = ScaffoldMessenger.of(context);

                // Close the dialog first
                Navigator.pop(dialogContext);

                // Call deleteMessage on the cached Cubit reference (completely safe)
                final success = await chatCubit.deleteMessage(message.id);

                // Show feedback SnackBar using the cached messenger reference (completely safe)
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Message deleted' : 'Failed to delete message'),
                    backgroundColor: success ? Colors.green : Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReplyQuoteBox(BuildContext context) {
    final isMe = message.isMe;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    String senderName = "";
    String bodyText = "";
    
    if (parentMessage != null) {
      senderName = parentMessage!.isMe ? "You" : parentMessage!.sender;
      bodyText = parentMessage!.message;
    } else if (message.parentMessagePreview != null && message.parentMessagePreview!.isNotEmpty) {
      final preview = message.parentMessagePreview!;
      if (preview.contains(': ')) {
        final index = preview.indexOf(': ');
        senderName = preview.substring(0, index);
        bodyText = preview.substring(index + 2);
      } else {
        senderName = "Original Message";
        bodyText = preview;
      }
    } else {
      return const SizedBox.shrink();
    }
    
    bodyText = bodyText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();

    return GestureDetector(
      onTap: () {
        if (message.parentId != null && onQuoteTap != null) {
          onQuoteTap!(message.parentId!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isMe 
              ? Colors.white.withOpacity(0.12) 
              : (isDark ? Colors.grey[850] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: isMe ? Colors.white70 : AppColors.indigo,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isMe ? Colors.white70 : AppColors.indigo,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              bodyText,
              style: TextStyle(
                fontSize: 11,
                color: isMe ? Colors.white.withOpacity(0.8) : (isDark ? Colors.grey[400] : Colors.grey[700]),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                message.sender,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
          GestureDetector(
            onLongPress: () => _showMessageOptions(context, message, onReplySelected),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? (isDark ? Colors.amber.withOpacity(0.3) : Colors.amber.withOpacity(0.2))
                    : (message.isMe ? AppColors.indigo : (isDark ? Colors.grey[800] : Colors.grey.withOpacity(0.1))),
                border: Border.all(
                  color: isHighlighted ? Colors.amber : Colors.transparent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isMe ? 20 : 0),
                  bottomRight: Radius.circular(message.isMe ? 0 : 20),
                ),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.parentId != null)
                      _buildReplyQuoteBox(context),
                    if (message.attachments != null && message.attachments!.isNotEmpty)
                      _buildAttachments(context),
                    Text(
                      message.message,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.formattedDate,
                            style: TextStyle(
                              fontSize: 10,
                              color: message.isMe ? Colors.white.withOpacity(0.7) : Colors.grey,
                            ),
                          ),
                          if (message.isMe) ...[
                            const SizedBox(width: 4),
                            if (message.status == MessageStatus.sending)
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: Colors.white.withOpacity(0.6),
                              )
                            else if (message.status == MessageStatus.failed)
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to send message/file. Please verify the file size, internet connection, and try again.'),
                                      backgroundColor: Colors.redAccent,
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.error_outline_rounded,
                                  size: 14,
                                  color: Colors.redAccent,
                                ),
                              )
                            else
                              BlocBuilder<ChatCubit, ChatState>(
                                buildWhen: (previous, current) => 
                                    previous.partnerLastSeenMessageId != current.partnerLastSeenMessageId,
                                builder: (context, state) {
                                  // Fix double-ticks bug: only validate read state if the ID is a valid database ID (positive)
                                  final isRead = message.id > 0 &&
                                                state.partnerLastSeenMessageId != null && 
                                                state.partnerLastSeenMessageId! >= message.id;
                                  return Icon(
                                    isRead ? Icons.done_all_rounded : Icons.done_rounded,
                                    size: 14,
                                    color: isRead ? Colors.cyanAccent : Colors.white.withOpacity(0.7),
                                  );
                                },
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(BuildContext context) {
    final images = message.attachments!.where((a) => a.mimeType?.startsWith('image/') ?? false).toList();
    final others = message.attachments!.where((a) => !(a.mimeType?.startsWith('image/') ?? false)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: images.map((img) => _buildImageAttachment(context, img)).toList(),
            ),
          ),
        if (others.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: others.map((att) => _buildFileAttachment(context, att)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildImageMemory(BuildContext context, Uint8List bytes) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white),
                  elevation: 0,
                ),
                body: Center(
                  child: InteractiveViewer(
                    child: Image.memory(bytes),
                  ),
                ),
              ),
            ),
          );
        },
        child: Image.memory(
          bytes,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image_rounded, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildImageAttachment(BuildContext context, ChatAttachment att) {
    // Check if the image bytes are already available directly inside the attachment object
    if (att.bytes != null && att.bytes!.isNotEmpty) {
      return _buildImageMemory(context, att.bytes!);
    }

    // Check if the image bytes are already cached synchronously in the ChatCubit cache
    final cachedBytes = context.read<ChatCubit>().getCachedAttachment(att.id);
    if (cachedBytes != null) {
      return _buildImageMemory(context, cachedBytes);
    }

    // Default download fallback for existing messages retrieved from the Odoo backend
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        height: 200,
        color: Colors.black.withOpacity(0.05),
        child: FutureBuilder<Uint8List?>(
          future: context.read<ChatCubit>().downloadAttachment(att.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[200]!,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          iconTheme: const IconThemeData(color: Colors.white),
                          elevation: 0,
                        ),
                        body: Center(
                          child: InteractiveViewer(
                            child: Image.memory(snapshot.data!),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Image.memory(
                  snapshot.data!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image_rounded, color: Colors.grey)),
                ),
              );
            }
            return GestureDetector(
              onTap: () => _handleAttachmentClick(context, att),
              child: const Center(child: Icon(Icons.image_rounded, color: Colors.grey)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFileAttachment(BuildContext context, ChatAttachment att) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _handleAttachmentClick(context, att),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.white.withOpacity(0.1) : (isDark ? Colors.grey[850] : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getFileIcon(att.mimeType),
              size: 20,
              color: message.isMe ? Colors.white : AppColors.indigo,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                att.name,
                style: TextStyle(
                  color: message.isMe ? Colors.white : (isDark ? Colors.grey[300] : AppColors.textDark),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String? mimeType) {
    if (mimeType == null) return Icons.insert_drive_file_rounded;
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf_rounded;
    if (mimeType.contains('word') || mimeType.contains('officedocument')) return Icons.description_rounded;
    if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) return Icons.table_chart_rounded;
    if (mimeType.contains('zip') || mimeType.contains('rar')) return Icons.archive_rounded;
    return Icons.insert_drive_file_rounded;
  }

  Future<void> _handleAttachmentClick(BuildContext context, ChatAttachment att) async {
    try {
      final cubit = context.read<ChatCubit>();
      final l10n = AppLocalizations.of(context)!;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.downloading(att.name)), duration: const Duration(seconds: 1)),
      );

      final bytes = await cubit.downloadAttachment(att.id);
      if (bytes == null) throw 'Could not download file';

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${att.name}');
      await file.writeAsBytes(bytes);

      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onRightSwipe;
  const SwipeToReply({super.key, required this.child, required this.onRightSwipe});

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply> {
  double _dragOffset = 0.0;
  bool _triggered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          setState(() {
            _dragOffset = (_dragOffset + details.delta.dx).clamp(0.0, 80.0);
          });
          if (_dragOffset >= 60.0 && !_triggered) {
            _triggered = true;
            HapticFeedback.lightImpact();
            widget.onRightSwipe();
          }
        }
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _dragOffset = 0.0;
          _triggered = false;
        });
      },
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            if (_dragOffset > 10.0)
              Positioned(
                left: -50,
                top: 0,
                bottom: 0,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: (_dragOffset / 60.0).clamp(0.0, 1.0),
                    child: const Icon(
                      Icons.reply_rounded,
                      color: AppColors.indigo,
                      size: 24,
                    ),
                  ),
                ),
              ),
            widget.child,
          ],
        ),
      ),
    );
  }
}
