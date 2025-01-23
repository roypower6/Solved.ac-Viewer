import 'package:flutter/material.dart';
import 'package:solved_ac_browser/model/shop_item_model.dart';
import 'package:solved_ac_browser/service/api_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  late Future<List<ShopItemModel>> _shopItemsFuture;

  @override
  void initState() {
    super.initState();
    _shopItemsFuture = SolvedacApi.getShopItems(); // Fetch shop items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solved.ac Shop"),
      ),
      body: FutureBuilder<List<ShopItemModel>>(
        // Expanded 제거
        future: _shopItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('샵 아이템을 불러오는 중 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('구매 가능한 아이템이 없습니다.'));
          } else {
            return _buildShopList(snapshot.data!);
          }
        },
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: shopItem.itemImageUrl.isEmpty
                  ? const Icon(
                      Icons.card_giftcard_outlined,
                      size: 30,
                      color: Colors.grey,
                    )
                  : Image.network(
                      shopItem.itemImageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.card_giftcard_outlined,
                          size: 30,
                          color: Colors.grey,
                        );
                      },
                    ),
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
