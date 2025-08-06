import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/utils/utils.dart';
import 'package:ibadahku/models/announcement_model.dart';
import 'package:ibadahku/controllers/announcement_controller.dart';
import 'package:ibadahku/screens/announcement/views/announcement_detail_view.dart';
import 'package:intl/intl.dart';

class AnnouncementListView extends StatelessWidget {
  const AnnouncementListView({super.key});

  Widget _buildNetworkImage(String imageUrl) {
    // Handle empty or null URLs
    if (imageUrl.isEmpty) {
      return Container(
        color: Utils.kPrimaryColor.withValues(alpha: 0.1),
        child: const Icon(
          Icons.announcement_outlined,
          color: Utils.kPrimaryColor,
          size: 32,
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
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: Utils.kPrimaryColor,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Utils.kPrimaryColor.withValues(alpha: 0.1),
          child: const Icon(
            Icons.announcement_outlined,
            color: Utils.kPrimaryColor,
            size: 32,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AnnouncementController controller =
        Get.find<AnnouncementController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Semua Pengumuman',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Utils.kPrimaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.announcementList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.announcement_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Belum ada pengumuman',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchAnnouncement();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.announcementList.length,
            itemBuilder: (context, index) {
              final announcement = controller.announcementList[index];
              return _buildAnnouncementCard(context, announcement!);
            },
          ),
        );
      }),
    );
  }

  Widget _buildAnnouncementCard(
      BuildContext context, AnnouncementModel announcement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(() => AnnouncementDetailView(announcement: announcement));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: _buildNetworkImage(announcement.imageUrl ?? ""),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        announcement.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(announcement.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }
}
