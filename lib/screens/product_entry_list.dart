// ... (imports)
import 'package:flutter/material.dart';
import 'package:football_shop/models/product_entry.dart';
import 'package:football_shop/widgets/left_drawer.dart';
import 'package:football_shop/screens/product_detail.dart';
import 'package:football_shop/widgets/product_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductEntryList extends StatefulWidget {
  final String initialFilter; // <--- Tambahkan parameter ini

  const ProductEntryList({super.key, this.initialFilter = 'all'}); // <--- Default ke 'all'

  @override
  State<ProductEntryList> createState() => _ProductEntryListState();
}

class _ProductEntryListState extends State<ProductEntryList> {
  String _filterType = 'all'; 

  @override
  void initState() {
    super.initState();
    _filterType = widget.initialFilter; // <--- Inisialisasi dari parameter
  }

  Future<List<ProductEntry>> fetchProductEntries(CookieRequest request) async {
    String url = 'http://localhost:8000/get-products/';
    if (_filterType == 'my') {
      url += '?filter=my';
    }
    
    final response = await request.get(url); 
    
    var data = response;
    
    List<ProductEntry> listProductEntries = [];
    for (var d in data) {
      if (d != null) {
        listProductEntries.add(ProductEntry.fromJson(d));
      }
    }
    return listProductEntries;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _filterType == 'my' ? 'My Products' : 'All Products', // Judul AppBar dinamis
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary, 
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _filterType = 'all';
                      });
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('All Products'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _filterType == 'all' ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                      foregroundColor: _filterType == 'all' ? Colors.white : Colors.black,
                      elevation: _filterType == 'all' ? 4 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!request.loggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please login to view your products!')),
                        );
                        return;
                      }
                      setState(() {
                        _filterType = 'my';
                      });
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text('My Products'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _filterType == 'my' ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                      foregroundColor: _filterType == 'my' ? Colors.white : Colors.black,
                      elevation: _filterType == 'my' ? 4 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchProductEntries(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                   return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No products found.',
                        style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => ProductEntryCard(
                      product: snapshot.data![index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              product: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}