import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/chat/presentation/chat_detail_screen.dart';
import 'package:flutter_app/features/chat/models/chat_model.dart';
import 'package:flutter_app/features/chat/cubit/chat_cubit.dart';
import 'package:flutter_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_app/features/auth/login/cubit/login_state.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'dart:convert';

class AppFirebaseService {
  static final AppFirebaseService _instance = AppFirebaseService._internal();
  factory AppFirebaseService() => _instance;
  AppFirebaseService._internal();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  int? _pendingChannelId;
  Map<String, dynamic>? _pendingChannelData;

   Future<void> initialize() async {
    try {
      debugPrint('Initializing Firebase SDK...');
      await Firebase.initializeApp();
      debugPrint('Firebase SDK initialized successfully.');

      await requestPermission();

      // Initialize local notifications
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(
       settings:  initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('AppFirebaseService: onDidReceiveNotificationResponse actionId=${response.actionId}');
          if (response.actionId == 'reply' && response.input?.isNotEmpty == true) {
            final String? payload = response.payload;
            if (payload != null) {
              final channelId = int.tryParse(payload);
              if (channelId != null) {
                final context = navigatorKey.currentContext;
                if (context != null) {
                  context.read<ChatCubit>().sendMessage(channelId, response.input!);
                }
              }
            }
          } else {
            // Tap on body -> Navigate
            final String? payload = response.payload;
            if (payload != null) {
              final channelId = int.tryParse(payload);
              if (channelId != null) {
                final context = navigatorKey.currentContext;
                if (context != null) {
                  AppFirebaseService()._navigateToChat(context, channelId, {});
                }
              }
            }
          }
        },
        onDidReceiveBackgroundNotificationResponse: onNotificationBackground,
      );

      final token = await getFCMToken();

      debugPrint('FCM Token: $token');

      // Foreground messages
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          debugPrint(
            'Foreground message: ${message.notification?.title}',
          );
          // Show local notification for foreground message if not in active chat
          showLocalNotification(message);
        },
      );

      // User tapped notification
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          debugPrint(
            'Notification clicked: ${message.data}',
          );
          _handleMessageClick(message);
        },
      );

      // App launched from terminated state
      RemoteMessage? initialMessage =
          await _messaging.getInitialMessage();

      if (initialMessage != null) {
        debugPrint(
          'App opened from terminated notification: ${initialMessage.data}',
        );
        _handleMessageClick(initialMessage);
      }
    } catch (e) {
      debugPrint('FirebaseService Error: $e');
    }
  }

  void _handleMessageClick(RemoteMessage message) {
    final data = message.data;
    final channelIdVal = data['channel_id'];
    if (channelIdVal == null) return;
    final channelId = int.tryParse(channelIdVal.toString());
    if (channelId == null) return;

    final context = navigatorKey.currentContext;
    if (context == null) {
      _pendingChannelId = channelId;
      _pendingChannelData = data;
      debugPrint('AppFirebaseService: Context is null, notification stored as pending (Channel ID: $channelId)');
      return;
    }

    final loginCubit = context.read<LoginCubit>();
    if (loginCubit.state.status != LoginStatus.success) {
      _pendingChannelId = channelId;
      _pendingChannelData = data;
      debugPrint('AppFirebaseService: User not logged in, notification stored as pending (Channel ID: $channelId)');
      return;
    }

    _navigateToChat(context, channelId, data);
  }

  void _navigateToChat(BuildContext context, int channelId, Map<String, dynamic> data) {
    debugPrint('AppFirebaseService: Navigating to ChatDetailScreen for Channel ID: $channelId');
    final chatCubit = context.read<ChatCubit>();
    
    ChatChannel? targetChannel;
    for (final channel in chatCubit.state.channels) {
      if (channel.id == channelId) {
        targetChannel = channel;
        break;
      }
    }
    if (targetChannel == null) {
      for (final dm in chatCubit.state.directMessages) {
        if (dm.id == channelId) {
          targetChannel = dm;
          break;
        }
      }
    }

    if (targetChannel == null) {
      final channelTypeStr = data['channel_type']?.toString();
      ChannelType type = ChannelType.chat;
      if (channelTypeStr == 'channel') {
        type = ChannelType.channel;
      } else if (channelTypeStr == 'group') {
        type = ChannelType.group;
      }
      
      final displayName = data['display_name'] ?? data['name'] ?? 'Chat';
      targetChannel = ChatChannel(
        id: channelId,
        name: displayName,
        displayName: displayName,
        type: type,
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (navContext) => ChatDetailScreen(channel: targetChannel!),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<ChatCubit>().fetchChannels();
      }
    });
  }

  void checkAndHandlePendingNotification(BuildContext context) {
    if (_pendingChannelId != null && _pendingChannelData != null) {
      final channelId = _pendingChannelId!;
      final data = _pendingChannelData!;
      
      _pendingChannelId = null;
      _pendingChannelData = null;

      debugPrint('AppFirebaseService: Triggering pending notification for Channel ID: $channelId');
      _navigateToChat(context, channelId, data);
    }
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final data = message.data;
    final channelIdVal = data['channel_id'];
    if (channelIdVal == null) return;
    
    // Parse channelId and verify if the user is currently viewing the active chat
    final channelId = int.tryParse(channelIdVal.toString());
    if (channelId != null) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        final chatCubit = context.read<ChatCubit>();
        if (chatCubit.state.currentChatId == channelId.toString()) {
          debugPrint('AppFirebaseService: Suppressing local notification since this chat is currently open');
          return;
        }
      }
    }

    final title = message.notification?.title ?? data['display_name'] ?? data['name'] ?? 'New Message';
    
    final String? rawBody = (data['body'] != null && data['body'].toString().isNotEmpty)
        ? data['body'].toString()
        : message.notification?.body;
    final body = parseNotificationBody(rawBody, data: data);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chat_replies',
      'Chat Messages',
      channelDescription: 'Notifications for direct chat messages',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'reply',
          'Reply',
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              label: 'Type your message...',
            ),
          ],
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final notifId = channelId ?? 999;

    await flutterLocalNotificationsPlugin.show(
      
      id: notifId,
  title: title,
  body: body,
  notificationDetails: platformChannelSpecifics,
  payload: channelIdVal.toString(),
    );
  }

  String parseNotificationBody(String? rawBody, {Map<String, dynamic>? data}) {
    final lowerBody = rawBody?.toLowerCase() ?? '';
    
    // Check for attachment indicators in the HTML or URL
    bool isAttachment = lowerBody.contains('/web/content/') ||
        lowerBody.contains('/web/image/') ||
        lowerBody.contains('data-mimetype=') ||
        lowerBody.contains('class="o_image"') ||
        lowerBody.contains('class="o_attachment"');

    // Strip HTML tags to get pure text
    String cleanText = (rawBody ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();

    // Check if cleanText is just a filename (e.g. image.png, doc.pdf)
    bool cleanTextIsFilename = RegExp(r'^[\w\-. ]+\.[a-zA-Z0-9]+$').hasMatch(cleanText);

    // Check FCM data for attachment flags
    bool hasAttachmentKey = false;
    String? mimetype;
    if (data != null) {
      final attachmentIdsStr = data['attachment_ids'];
      final attachmentsStr = data['attachments'];
      hasAttachmentKey = (attachmentIdsStr != null && attachmentIdsStr != '[]' && attachmentIdsStr != 'false' && attachmentIdsStr.isNotEmpty) ||
                         (attachmentsStr != null && attachmentsStr != '[]' && attachmentsStr != 'false' && attachmentsStr.isNotEmpty);
      mimetype = data['mimetype']?.toString().toLowerCase();
    }

    if (isAttachment || cleanTextIsFilename || hasAttachmentKey) {
      // Determine file extension/mimetype
      String extension = '';
      
      // Try to find mime-type in data-mimetype="..."
      final mimeMatch = RegExp(r'''data-mimetype=["']([^"']+)["']''').firstMatch(lowerBody);
      String? matchedType;
      if (mimeMatch != null && mimeMatch.groupCount >= 1) {
        final mime = mimeMatch.group(1)!;
        if (mime.startsWith('image/')) matchedType = 'Sent an image';
        else if (mime.startsWith('video/')) matchedType = 'Sent a video';
        else if (mime.startsWith('audio/')) matchedType = 'Sent an audio file';
        else if (mime.contains('pdf') || mime.contains('word') || mime.contains('excel') || mime.contains('powerpoint') || mime.contains('office') || mime.contains('sheet')) {
          matchedType = 'Sent a document';
        }
      }

      // Fallback to FCM mimetype if available
      if (matchedType == null && mimetype != null && mimetype.isNotEmpty) {
        if (mimetype.startsWith('image/')) matchedType = 'Sent an image';
        else if (mimetype.startsWith('video/')) matchedType = 'Sent a video';
        else if (mimetype.startsWith('audio/')) matchedType = 'Sent an audio file';
        else if (mimetype.contains('pdf') || mimetype.contains('word') || mimetype.contains('excel') || mimetype.contains('powerpoint') || mimetype.contains('office') || mimetype.contains('sheet')) {
          matchedType = 'Sent a document';
        }
      }

      // Try to extract extension from cleanText (if it is a filename) or rawBody href
      final extMatch = RegExp(r'\.([a-zA-Z0-9]+)(?:[?#]|$)').firstMatch(cleanText.isNotEmpty ? cleanText : (rawBody ?? ''));
      if (extMatch != null && extMatch.groupCount >= 1) {
        extension = extMatch.group(1)!.toLowerCase();
      }

      if (matchedType == null) {
        if (['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'heic'].contains(extension)) {
          matchedType = 'Sent an image';
        } else if (['mp4', 'mov', 'avi', 'mkv', 'webm', '3gp'].contains(extension)) {
          matchedType = 'Sent a video';
        } else if (['mp3', 'wav', 'm4a', 'ogg', 'aac', 'flac'].contains(extension)) {
          matchedType = 'Sent an audio file';
        } else if (['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'csv', 'zip', 'rar', 'tar', 'gz'].contains(extension)) {
          matchedType = 'Sent a document';
        } else {
          matchedType = 'Sent an attachment';
        }
      }

      // If there is other message text accompanied with the attachment, we want to show the text.
      final filenameMatch = RegExp(r'<a[^>]*>([^<]+)</a>').firstMatch(rawBody ?? '');
      String? filename = filenameMatch?.group(1)?.trim();
      
      String textWithoutFilename = cleanText;
      if (filename != null && filename.isNotEmpty) {
        textWithoutFilename = cleanText.replaceAll(filename, '').trim();
      } else if (cleanTextIsFilename) {
        textWithoutFilename = '';
      }

      // Verify if remaining text is generic (like "You received a new message")
      final t = textWithoutFilename.trim().toLowerCase();
      bool isGeneric = t == 'you received a message' || t == 'you received a new message' || t == 'new message';

      if (textWithoutFilename.isNotEmpty && !isGeneric) {
        return textWithoutFilename;
      }
      return matchedType;
    }

    final t = cleanText.trim().toLowerCase();
    bool isGeneric = t == 'you received a message' || t == 'you received a new message' || t == 'new message' || t.isEmpty;
    return isGeneric ? 'You received a message' : cleanText;
  }

  Future<void> requestPermission() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('Notification permission status: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Failed to request notification permission: $e');
    }
  }

  Future<String?> getFCMToken() async {
    try {
      String? token = await _messaging.getToken();
      return token;
    } catch (e) {
      debugPrint('Error fetching FCM Token: $e');
      return null;
    }
  }
}

@pragma('vm:entry-point')
void onNotificationBackground(NotificationResponse response) async {
  debugPrint('AppFirebaseService: onNotificationBackground actionId=${response.actionId}');
  if (response.actionId == 'reply' && response.input?.isNotEmpty == true) {
    final String? payload = response.payload; // Contains the channel_id
    if (payload == null) return;
    final channelId = int.tryParse(payload);
    if (channelId == null) return;
    final text = response.input!;

    debugPrint('AppFirebaseService: Background reply for channel $channelId: $text');
    try {
      final prefs = SharedPref();
      final sobj = await prefs.getObject('session');
      final baseUrl = await prefs.getString('baseUrl');
      if (baseUrl == null || sobj == null) return;
      final session = OdooSession.fromJson(sobj);
      final client = OdooClient(baseUrl, sessionId: session);

      await client.callKw({
        'model': 'discuss.channel',
        'method': 'message_post',
        'args': [channelId],
        'kwargs': {
          'body': text,
          'message_type': 'comment',
          'subtype_xmlid': 'mail.mt_comment',
        },
      });
      debugPrint('AppFirebaseService background reply sent successfully.');
    } catch (e) {
      debugPrint('AppFirebaseService background reply failed: $e');
    }
  }
}
