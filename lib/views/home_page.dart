import "package:fashion_mod_app/views/purchase.dart";
import "package:fashion_mod_app/views/utilities.dart";
import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

import "../controller/extractData.dart";
import "../model/models.dart";

import "components.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> futureProducts;
  Set<String> uniqueCategories = Set<String>();
  List<Product> displayedProducts = [];
  String _selectedCategory = "";

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      List<Product> products = await futureProducts;
      uniqueCategories =
          Set<String>.from(products.map((product) => product.category));
      setState(() {
        displayedProducts = products;
        _selectedCategory = uniqueCategories.first.toString();
      });
    } catch (error) {
      print('Error loading products: $error');
    }
  }

  void onCategorySelected(String index) {
    setState(() {
      _selectedCategory = index;
      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Icon(Icons.qr_code_rounded, color: Colors.black),
          title: const Text(
            "Shop",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.search_rounded,
                color: Colors.black,
                size: 30,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            const Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                height: 100,
                child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Center(
                      child: Icon(Icons.image),
                    )),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 60,
                child: FutureBuilder(
                  future: futureProducts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return categoriesShimmer();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Product> products = snapshot.data as List<Product>;
                      uniqueCategories = Set<String>.from(
                          products.map((product) => product.category));

                      return CategorieButton(
                        categories: uniqueCategories.toList(),
                        Tap: onCategorySelected,
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return productsShimmerEffect();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Product> allProducts = snapshot.data as List<Product>;

                    // Filter products based on the selected category
                    List<Product> filteredProducts = allProducts
                        .where(
                            (product) => product.category == _selectedCategory)
                        .toList();

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredProducts.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          maxCrossAxisExtent: 200),
                      itemBuilder: (context, index) {
                        Product product = filteredProducts[index];
                        return ProductList(
                          product: product,
                        );
                      },
                      semanticChildCount: filteredProducts.length,
                    );
                  }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
