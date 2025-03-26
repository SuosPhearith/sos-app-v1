import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FlavorInfoScreen extends StatelessWidget {
  const FlavorInfoScreen({super.key});

  // Helper method to get environment variable safely
  String _getEnvValue(String key) {
    try {
      return dotenv.get(key);
    } catch (e) {
      return 'Not Available';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "អំពីប្រព័ន្ធ",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildInfoTile('App Name', _getEnvValue('APP_NAME')),
                  _buildInfoTile('API URL', _getEnvValue('API_URL')),
                  _buildInfoTile('Asset URL', _getEnvValue('ASSET_URL')),
                  _buildInfoTile('API Key', _getEnvValue('API_KEY')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each info tile
  Widget _buildInfoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.info_outline,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}