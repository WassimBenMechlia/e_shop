import "dart:convert";

import "package:fashion_mod_app/model/models.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "bag.dart";

class Purchase extends StatefulWidget {
  const Purchase({super.key, required this.product});
  final Product product;

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  bool detailsShown = false;
  void _toggleDetails() {
    setState(() {
      detailsShown = !detailsShown;
    });
  }

  void _addToShoppingBag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bagProducts = prefs.getStringList('bag_products') ?? [];
    bagProducts.add(jsonEncode(widget.product.toJson()));
    prefs.setStringList('bag_products', bagProducts);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Bag(product: widget.product),
      ),
    );
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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            )),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.product.image))),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$ ${widget.product.price}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${widget.product.title}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Details",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _toggleDetails();
                            },
                            icon: !detailsShown
                                ? Icon(Icons.keyboard_arrow_down_rounded)
                                : Icon(Icons.keyboard_arrow_up_rounded),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: detailsShown,
                        child: Text(
                            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa."),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          _addToShoppingBag();
                        },
                        child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Add To Shopping Bag",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ))
          ]),
    );
  }
}
