import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:ibadahku/models/announcement_model.dart';
import 'package:intl/intl.dart';

class AnnouncementDetailView extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailView({
    super.key,
    required this.announcement,
  });

  Widget _buildNetworkImage(String imageUrl) {
    // Handle empty or null URLs
    if (imageUrl.isEmpty) {
      return Container(
        color: Utils.kPrimaryColor.withOpacity(0.1),
        child: const Icon(
          Icons.announcement_outlined,
          color: Utils.kPrimaryColor,
          size: 64,
        ),
      );
    }

    // For web, use CORS proxy to avoid CORS issues
    String finalImageUrl = imageUrl;
    if (kIsWeb) {
      // Use a CORS proxy service for web
      finalImageUrl =
          'https://api.allorigins.win/raw?url=${Uri.encodeComponent(imageUrl)}';
    }

    return Image.network(
      finalImageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Utils.kPrimaryColor.withOpacity(0.1),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Utils.kPrimaryColor.withOpacity(0.1),
          child: const Icon(
            Icons.announcement_outlined,
            color: Utils.kPrimaryColor,
            size: 64,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Utils.kPrimaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  _buildNetworkImage(announcement.imageUrl ?? ""),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and Time
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Utils.kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Utils.kPrimaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(announcement.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Utils.kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      announcement.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Divider
                    Container(
                      height: 1,
                      width: 60,
                      color: Utils.kPrimaryColor.withOpacity(0.3),
                    ),
                    const SizedBox(height: 24),
                    // Content
                    Text(
                      announcement.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Footer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Utils.kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: Utils.kPrimaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pengumuman dari',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'STAI Daarut Tauhid',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy, HH:mm').format(dateTime);
  }
}
