import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionsScreen extends StatelessWidget {
  const AttributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Attributions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AttributionSection(
            title: 'Character Avatars',
            items: [
              _AttributionItem(
                name: 'Boy and Girl Avatars',
                attribution: 'Indian Vectors by Vecteezy',
                url: 'https://www.vecteezy.com/free-vector/indian',
              ),
            ],
          ),
          Divider(height: 32),
          _AttributionSection(
            title: 'Shop Items',
            items: [
              _AttributionItem(
                name: 'Turbans and Traditional Clothing',
                attribution: 'Indian Vectors by Vecteezy',
                url: 'https://www.vecteezy.com/free-vector/indian',
              ),
              _AttributionItem(
                name: 'Accessories',
                attribution: 'Original artwork by GNPS Team.',
              ),
            ],
          ),
          Divider(height: 32),
          _AttributionSection(
            title: 'Application Icons',
            items: [
              _AttributionItem(
                name: 'Material Icons',
                attribution: 'Google Material Design (Apache License 2.0).',
              ),
            ],
          ),
          SizedBox(height: 32),
          Center(
            child: Text(
              'Thank you to all the artists who contributed to this project.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttributionSection extends StatelessWidget {
  final String title;
  final List<_AttributionItem> items;

  const _AttributionSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }
}

class _AttributionItem extends StatelessWidget {
  final String name;
  final String attribution;
  final String? url;

  const _AttributionItem({
    required this.name,
    required this.attribution,
    this.url,
  });

  Future<void> _launchUrl() async {
    if (url == null) return;
    final uri = Uri.parse(url!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLink = url != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          InkWell(
            onTap: isLink ? _launchUrl : null,
            child: Text(
              attribution,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isLink ? Colors.blue : null,
                    decoration: isLink ? TextDecoration.underline : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
