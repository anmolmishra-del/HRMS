import 'dart:typed_data';
import 'package:equatable/equatable.dart';

enum MessageType { text, image, video, document, audio, notification }

enum MessageStatus { sending, sent, failed }

enum ChannelType { channel, chat, group }

class ChatChannel extends Equatable {
  final int id;
  final String name;
  final String displayName;
  final String lastMessage;
  final String lastMessageTime;
  final DateTime? lastMessageRaw;
  final int unreadCount;
  final bool isPinned;
  final int memberCount;
  final String? image;
  final ChannelType type;
  final String? imStatus; // online, away, offline
  final DateTime? lastInterestDt;

  // New fields from backend
  final String? description;
  final int? parentChannelId;
  final List<int>? subChannelIds;
  final String? sfuChannelUuid;
  final String? sfuServerUrl;
  final bool active;
  final int? partnerId;

  // Last message status checkmarks
  final bool isLastMessageFromMe;
  final int? lastMessageId;
  final bool isLastMessageRead;

  const ChatChannel({
    required this.id,
    required this.name,
    required this.displayName,
    this.lastMessage = '',
    this.lastMessageTime = '',
    this.lastMessageRaw,
    this.unreadCount = 0,
    this.isPinned = false,
    this.memberCount = 0,
    this.image,
    required this.type,
    this.imStatus,
    this.lastInterestDt,
    this.description,
    this.parentChannelId,
    this.subChannelIds,
    this.sfuChannelUuid,
    this.sfuServerUrl,
    this.active = true,
    this.partnerId,
    this.isLastMessageFromMe = false,
    this.lastMessageId,
    this.isLastMessageRead = false,
  });

  factory ChatChannel.fromJson(Map<String, dynamic> json, String currentUserName, int currentPartnerId) {
    print('ChatChannel.fromJson raw payload: id=${json['id']}, name=${json['name']}, display_name=${json['display_name']}, type=${json['channel_type']}');
    final typeStr = json['channel_type']?.toString() ?? 'channel';
    ChannelType type;
    if (typeStr == 'chat') {
      type = ChannelType.chat;
    } else if (typeStr == 'group') {
      type = ChannelType.group;
    } else {
      type = ChannelType.channel;
    }

    return ChatChannel(
      id: json['id'],
      name: json['name'] is String ? json['name'] : '',
      displayName: (json['display_name'] is String && json['display_name'].isNotEmpty) 
          ? json['display_name'] 
          : (json['name'] is String ? json['name'] : ''),
      type: type,
      memberCount: (json['channel_member_ids'] as List?)?.length ?? 0,
      image: json['image_128'] is String ? json['image_128'] : null,
      description: json['description'] is String ? json['description'] : null,
      parentChannelId: json['parent_channel_id'] is List 
          ? json['parent_channel_id'][0] 
          : (json['parent_channel_id'] is int ? json['parent_channel_id'] : null),
      subChannelIds: json['sub_channel_ids'] is List ? (json['sub_channel_ids'] as List).cast<int>() : null,
      sfuChannelUuid: json['sfu_channel_uuid'] is String ? json['sfu_channel_uuid'] : null,
      sfuServerUrl: json['sfu_server_url'] is String ? json['sfu_server_url'] : null,
      active: json['active'] is bool ? json['active'] : true,
    );
  }

  ChatChannel copyWith({
    String? displayName,
    int? unreadCount,
    bool? isPinned,
    String? imStatus,
    DateTime? lastInterestDt,
    String? image,
    int? partnerId,
    bool? isLastMessageFromMe,
    int? lastMessageId,
    bool? isLastMessageRead,
    String? lastMessage,
    String? lastMessageTime,
    DateTime? lastMessageRaw,
  }) {
    return ChatChannel(
      id: id,
      name: name,
      displayName: displayName ?? this.displayName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageRaw: lastMessageRaw ?? this.lastMessageRaw,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      memberCount: memberCount,
      image: image ?? this.image,
      type: type,
      imStatus: imStatus ?? this.imStatus,
      lastInterestDt: lastInterestDt ?? this.lastInterestDt,
      description: description,
      parentChannelId: parentChannelId,
      subChannelIds: subChannelIds,
      sfuChannelUuid: sfuChannelUuid,
      sfuServerUrl: sfuServerUrl,
      active: active,
      partnerId: partnerId ?? this.partnerId,
      isLastMessageFromMe: isLastMessageFromMe ?? this.isLastMessageFromMe,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      isLastMessageRead: isLastMessageRead ?? this.isLastMessageRead,
    );
  }

  @override
  List<Object?> get props => [
    id, name, displayName, lastMessage, lastMessageTime,
    unreadCount, isPinned, memberCount, image, type,
    imStatus, active, partnerId, isLastMessageFromMe, lastMessageId, isLastMessageRead
  ];
}

class ChatMessage extends Equatable {
  final int id;
  final String sender;
  final int senderId;
  final String message;
  final DateTime date;
  final String formattedDate;
  final bool isMe;
  final MessageType type;
  final MessageStatus status;
  final List<ChatAttachment>? attachments;

  // New fields from backend
  final String? messageType; // comment, notification, etc.
  final String? model;
  final int? resId;
  final String? subject;
  final int? subtypeId;
  final List<int>? partnerIds;
  final bool needAction;
  final List<int>? starredPartnerIds;
  final int? parentId;
  final String? parentMessagePreview;
  final List<int>? reactionIds;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.senderId,
    required this.message,
    required this.date,
    required this.formattedDate,
    required this.isMe,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.attachments,
    this.messageType,
    this.model,
    this.resId,
    this.subject,
    this.subtypeId,
    this.partnerIds,
    this.needAction = false,
    this.starredPartnerIds,
    this.parentId,
    this.parentMessagePreview,
    this.reactionIds,
  });

  ChatMessage copyWith({
    int? id,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sender: sender,
      senderId: senderId,
      message: message,
      date: date,
      formattedDate: formattedDate,
      isMe: isMe,
      type: type,
      status: status ?? this.status,
      attachments: attachments,
      messageType: messageType,
      model: model,
      resId: resId,
      subject: subject,
      subtypeId: subtypeId,
      partnerIds: partnerIds,
      needAction: needAction,
      starredPartnerIds: starredPartnerIds,
      parentId: parentId,
      parentMessagePreview: parentMessagePreview,
      reactionIds: reactionIds,
    );
  }

  @override
  List<Object?> get props => [
    id, senderId, message, date, formattedDate,
    isMe, type, status, attachments, parentId, parentMessagePreview
  ];
}

class ChatAttachment extends Equatable {
  final int id;
  final String name;
  final Uint8List? bytes;
  final String? mimeType;
  final int? fileSize;
  final int? createUid;

  const ChatAttachment({
    required this.id,
    required this.name,
    this.bytes,
    this.mimeType,
    this.fileSize,
    this.createUid,
  });

  factory ChatAttachment.fromJson(Map<String, dynamic> json) {
    return ChatAttachment(
      id: json['id'],
      name: json['name'] ?? '',
      mimeType: json['mimetype'],
      fileSize: json['file_size'],
      createUid: json['create_uid'] is List ? json['create_uid'][0] : json['create_uid'],
    );
  }

  @override
  List<Object?> get props => [id, name, mimeType, fileSize];
}
