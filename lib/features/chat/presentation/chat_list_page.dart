import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/l10n/app_localizations.dart';  
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../models/chat_model.dart';
import 'chat_detail_screen.dart';
import 'package:flutter_app/core/widget/loading_overlay.dart';

import 'dart:typed_data';

/// Detect if raw bytes represent an SVG file by checking for XML/SVG signatures.
/// SVGs cannot be decoded by Flutter's Image.memory and crash with 'unimplemented'.
bool _isSvgBytes(Uint8List bytes) {
  if (bytes.length < 5) return false;
  // Check for UTF-8 BOM or leading whitespace then '<'
  final str = String.fromCharCodes(bytes.take(100));
  return str.contains('<svg') || str.contains('<?xml');
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Listen for tab changes to show/hide FAB
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    context.read<ChatCubit>().initChat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showContactPicker() {
    final Future<List<Map<String, dynamic>>> contactsFuture = context.read<ChatCubit>().fetchContacts();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String searchQuery = "";
        int? loadingPartnerId;
        final l10n = AppLocalizations.of(sheetContext)!;
        return StatefulBuilder(
          builder: (builderContext, setModalState) {
            final isDark = Theme.of(builderContext).brightness == Brightness.dark;
            return Container(
              height: MediaQuery.of(builderContext).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? Theme.of(builderContext).colorScheme.surface : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: contactsFuture,
                  builder: (futureContext, snapshot) {
                    final isLoadingContacts = snapshot.connectionState == ConnectionState.waiting;
                    final allContacts = snapshot.data ?? [];
                    final filteredContacts = allContacts.where((c) {
                      final name = (c['name'] ?? '').toString().toLowerCase();
                      return name.contains(searchQuery.toLowerCase());
                    }).toList();

                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                          child: Row(
                            children: [
                              Text(
                                l10n.start_new_chat,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(builderContext).colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => Navigator.pop(builderContext),
                                icon: Icon(Icons.close_rounded, color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                        ),
                        if (!isLoadingContacts)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                              onChanged: (value) {
                                setModalState(() => searchQuery = value);
                              },
                              decoration: InputDecoration(
                                hintText: l10n.search_people,
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.indigo),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        if (!isLoadingContacts)
                          const SizedBox(height: 16),
                        Expanded(
                          child: isLoadingContacts
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.indigo,
                                  ),
                                )
                              : filteredContacts.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.person_search_rounded, size: 64, color: Colors.grey.shade200),
                                          const SizedBox(height: 16),
                                          Text(
                                            searchQuery.isEmpty ? l10n.no_contacts_found : l10n.no_matches_for(searchQuery),
                                            style: TextStyle(color: Colors.grey.shade400),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      itemCount: filteredContacts.length,
                                      separatorBuilder: (listContext, index) => const SizedBox(height: 4),
                                      itemBuilder: (listContext, index) {
                                        final contact = filteredContacts[index];
                                        final partnerId = contact['id'];
                                        final isLoading = partnerId != null && loadingPartnerId == partnerId;
                                        return ListTile(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          leading: _buildContactAvatar(contact['image_128']),
                                          title: Text(
                                            contact['name'],
                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                          subtitle: Text(
                                            (contact['function'] is String ? contact['function'] : null) ??
                                                (contact['email'] is String ? contact['email'] : null) ??
                                                l10n.employee,
                                            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                          ),
                                          trailing: isLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.indigo),
                                                  ),
                                                )
                                              : null,
                                          onTap: loadingPartnerId != null
                                              ? null
                                              : () async {
                                                  if (partnerId != null) {
                                                    // Check if a direct message channel already exists locally
                                                    final chatCubit = context.read<ChatCubit>();
                                                    ChatChannel? existingChannel;
                                                    for (final ch in chatCubit.state.directMessages) {
                                                      if (ch.partnerId == partnerId) {
                                                        existingChannel = ch;
                                                        break;
                                                      }
                                                    }

                                                    if (existingChannel != null) {
                                                      Navigator.pop(builderContext); // Close sheet instantly
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (navContext) => ChatDetailScreen(channel: existingChannel!),
                                                        ),
                                                      ).then((_) {
                                                        if (mounted) {
                                                          context.read<ChatCubit>().fetchChannels();
                                                        }
                                                      });
                                                      return;
                                                    }

                                                    // Fallback to calling createDirectMessage if not cached locally
                                                    setModalState(() {
                                                      loadingPartnerId = partnerId;
                                                    });
                                                    try {
                                                      final ChatChannel? channel = await context.read<ChatCubit>().createDirectMessage(partnerId);
                                                      if (mounted) {
                                                        Navigator.pop(builderContext); // Close sheet
                                                        if (channel != null) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (navContext) => ChatDetailScreen(channel: channel),
                                                            ),
                                                          ).then((_) {
                                                            if (mounted) {
                                                              context.read<ChatCubit>().fetchChannels();
                                                            }
                                                          });
                                                        }
                                                      }
                                                    } catch (e) {
                                                      if (mounted) {
                                                        setModalState(() {
                                                          loadingPartnerId = null;
                                                        });
                                                      }
                                                    }
                                                  }
                                                },
                                        );
                                      },
                                    ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContactAvatar(dynamic imageBase64) {
    if (imageBase64 is String && imageBase64 != "false" && imageBase64.isNotEmpty) {
      try {
        final cleanedDatas = imageBase64.trim().replaceAll(RegExp(r'\s+'), '');
        final actualBase64 = cleanedDatas.contains(',') ? cleanedDatas.split(',').last : cleanedDatas;
        final bytes = base64Decode(actualBase64);
        // Guard: SVG bytes cannot be decoded by Flutter's Image.memory
        if (bytes.isEmpty || _isSvgBytes(bytes)) throw 'Unsupported image format';
        return CircleAvatar(
          radius: 20,
          child: ClipOval(
            child: Image.memory(
              bytes,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person),
            ),
          ),
        );
      } catch (e) {
        return const CircleAvatar(radius: 20, child: Icon(Icons.person));
      }
    }
    return const CircleAvatar(radius: 20, child: Icon(Icons.person));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.indigo,
                AppColors.brightBlue,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.03),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          l10n.messages,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: l10n.channels),
            Tab(text: l10n.direct_messages),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChannelList(ChannelType.channel),
          _buildChannelList(ChannelType.chat),
        ],
      ),
      // Only show the FAB on the Direct Messages tab (index 1), not on the Channels tab
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 140.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: _currentTabIndex == 1
              ? FloatingActionButton(
                  key: const ValueKey('fab_visible'),
                  onPressed: _showContactPicker,
                  backgroundColor: AppColors.indigo,
                  child: const Icon(Icons.add_comment_rounded, color: Colors.white),
                )
              : const SizedBox.shrink(key: ValueKey('fab_hidden')),
        ),
      ),
    );
  }

  Widget _buildChannelList(ChannelType type) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.status == ChatStatus.loading && state.channels.isEmpty && state.directMessages.isEmpty) {
          return const AppLoader();
        }

        final items = type == ChannelType.channel ? state.channels : state.directMessages;

        if (items.isEmpty) {
          return _buildEmptyState(type);
        }

        return RefreshIndicator(
          onRefresh: () => context.read<ChatCubit>().fetchChannels(),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 120),
            itemCount: items.length,
            // FIX: Use ValueKey with channel ID so Flutter ALWAYS maps
            // the correct widget to the correct channel — prevents wrong chat opening.
            itemBuilder: (context, index) {
              final channel = items[index];
              return _ChannelTile(
                key: ValueKey(channel.id),
                channel: channel,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ChannelType type) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            type == ChannelType.channel ? Icons.forum_outlined : Icons.chat_bubble_outline_rounded,
            size: 64,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            type == ChannelType.channel ? l10n.no_channels_found : l10n.no_direct_messages,
            style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ChannelTile extends StatelessWidget {
  final ChatChannel channel;
  const _ChannelTile({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('ChatListPage: Tapped on channel ${channel.displayName} (ID: ${channel.id})');
            // Capture channel reference before navigation to prevent stale closure
            final selectedChannel = channel;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(channel: selectedChannel),
              ),
            ).then((_) {
              if (context.mounted) {
                context.read<ChatCubit>().fetchChannels();
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  _buildAvatar(context),
                  // if (channel.type == ChannelType.chat && channel.imStatus != null && channel.imStatus != 'offline')
                  //   Positioned(
                  //     right: 1,
                  //     bottom: 1,
                  //     child: Container(
                  //       width: 14,
                  //       height: 14,
                  //       decoration: BoxDecoration(
                  //         color: _getStatusColor(channel.imStatus!),
                  //         shape: BoxShape.circle,
                  //         border: Border.all(
                  //           color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
                  //           width: 2,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            channel.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (channel.lastMessageTime.isNotEmpty)
                          Text(
                            channel.lastMessageTime,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (channel.isLastMessageFromMe && channel.lastMessage.isNotEmpty) ...[
                          Icon(
                            channel.isLastMessageRead ? Icons.done_all_rounded : Icons.done_rounded,
                            size: 16,
                            color: channel.isLastMessageRead
                                ? Colors.cyan
                                : (isDark ? Colors.white.withOpacity(0.5) : Colors.grey.shade400),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            channel.lastMessage.isEmpty ? AppLocalizations.of(context)!.no_messages_yet : channel.lastMessage,
                            style: TextStyle(
                              fontSize: 13,
                              color: channel.unreadCount > 0 ? Colors.black87 : Colors.grey.shade600,
                              fontWeight: channel.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ), 
                        ),
                        if (channel.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.indigo,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              channel.unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildAvatar(BuildContext context) {
    if (channel.type == ChannelType.channel || channel.type == ChannelType.group) {
      return _buildDefaultAvatar();
    }
    if (channel.image != null && channel.image != "false" && channel.image!.isNotEmpty) {
      try {
        final cleanedDatas = channel.image!.trim().replaceAll(RegExp(r'\s+'), '');
        final actualBase64 = cleanedDatas.contains(',') ? cleanedDatas.split(',').last : cleanedDatas;
        final bytes = base64Decode(actualBase64);
        // Guard: SVG bytes cannot be decoded by Flutter's Image.memory
        if (bytes.isEmpty || _isSvgBytes(bytes)) throw 'Unsupported image format';
        return CircleAvatar(
          radius: 28,
          child: ClipOval(
            child: Image.memory(
              bytes,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildDefaultAvatarContent(),
            ),
          ),
        );
      } catch (e) {
        return _buildDefaultAvatar();
      }
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatarContent() {
    final defaultChar = (channel.type == ChannelType.channel || channel.type == ChannelType.group) ? '#' : '?';
    return Center(
      child: Text(
        channel.displayName.isNotEmpty ? channel.displayName[0].toUpperCase() : defaultChar,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.indigo, AppColors.brightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: _buildDefaultAvatarContent(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'away':
        return Colors.orange;
      case 'offline':
      default:
        return Colors.grey;
    }
  }
}
