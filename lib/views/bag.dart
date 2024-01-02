import "dart:convert";

import "package:fashion_mod_app/views/product_card.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../model/models.dart";

class Bag extends StatefulWidget {
  Product product;
  Bag({super.key, required this.product});

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  List<Product> bagProducts = [];
  double totalPayment = 0;

  @override
  void initState() {
    super.initState();
    _loadBagProducts();
  }

  Future<void> _loadBagProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedProducts = prefs.getStringList('bag_products');
    setState(() {
      totalPayment = 0;
    });
    if (storedProducts != null) {
      setState(() {
        bagProducts = storedProducts.map((productJson) {
          Map<String, dynamic> productMap = jsonDecode(productJson);
          totalPayment += productMap['price'];
          return Product.fromJson(productMap);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
          title: const Text(
            'BAGS',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bagProducts.length,
                itemBuilder: (context, index) {
                  if (index < bagProducts.length) {
                    return ProductCard(
                      product: bagProducts[index],
                      loadProd: () {
                        _loadBagProducts();
                      },
                      totalPayment: totalPayment,
                    );
                  } else {
                    return Center(
                      child: Text("BAG IS EMPTY"),
                    ); // or any other widget as a placeholder
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              height: 150,
              child: Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.confirmation_number_rounded,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "USE YOUR PROMO CODE",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      )),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL PAYMENT :",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$${totalPayment}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "CHEKOUT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                )
              ]),
            )
          ],
        ));
  }
}
