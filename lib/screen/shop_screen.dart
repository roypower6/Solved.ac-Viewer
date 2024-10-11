import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/shop_item_model.dart';
import 'package:solved_ac_browser/service/api_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:solved_ac_browser/service/admob_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  late Future<List<ShopItemModel>> _shopItemsFuture;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _shopItemsFuture = SolvedacApi.getShopItems(); // Fetch shop items
    _createBannerAd(); // Initialize ad banner
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SolvedAC Shop"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ShopItemModel>>(
              future: _shopItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Failed to load shop items.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items available.'));
                } else {
                  return _buildShopList(snapshot.data!); // Build shop item list
                }
              },
            ),
          ),
          if (_bannerAd != null)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }

  // Build a list of shop items
  Widget _buildShopList(List<ShopItemModel> shopItems) {
    return ListView.builder(
      itemCount: shopItems.length,
      itemBuilder: (context, index) {
        final item = shopItems[index];
        return ShopItemWidget(shopItem: item);
      },
    );
  }
}

// Widget for displaying individual shop item
class ShopItemWidget extends StatelessWidget {
  final ShopItemModel shopItem;

  const ShopItemWidget({super.key, required this.shopItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image with Fallback Icon if Image Fails to Load
            Image.network(
              shopItem.itemImageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback icon when the image fails to load
                return const Icon(
                  Icons.card_giftcard_outlined, // Icon as fallback
                  size: 50,
                );
              },
            ),
            const SizedBox(width: 16),
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopItem.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shopItem.displayDescription,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '가격: ${shopItem.price / 100} ${shopItem.priceUnit}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '구매 한도: ${shopItem.units}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
