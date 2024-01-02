import "dart:convert";

import "package:fashion_mod_app/model/models.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class ProductCard extends StatefulWidget {
  late double totalPayment;

  Function() loadProd;
  Product product;
  ProductCard(
      {super.key,
      required this.product,
      required this.loadProd,
      required this.totalPayment});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int numberOfItems = 1;
  void increment() {
    setState(() {
      numberOfItems++;
    });
    quantite(widget.product, numberOfItems);
  }

  void quantite(Product product, int amount) {
    setState(() {
      widget.totalPayment += product.price * amount;
    });
  }

  void decrement() {
    if (numberOfItems != 1) {
      setState(() {
        numberOfItems--;
      });
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.black;
  }

  bool isChecked = false;
  Future<void> _deleteProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedProducts = prefs.getStringList('bag_products');

    if (storedProducts != null) {
      List<Product> updatedProducts = storedProducts
          .map((productJson) => Product.fromJson(jsonDecode(productJson)))
          .where((product) => product.id != productId)
          .toList();

      List<String> updatedProductsJson = updatedProducts
          .map((product) => jsonEncode(product.toJson()))
          .toList();

      await prefs.setStringList('bag_products', updatedProductsJson);

      await widget.loadProd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
        height: 130,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            ),
            Container(
              height: 110,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                    decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.product.image)),
                )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$ ${widget.product.price}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _deleteProduct(widget.product.id);
                              },
                              child: Icon(Icons.close),
                            )
                          ],
                        ),
                        Text(
                          '${widget.product.title}',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () => increment(),
                            child: Icon(Icons.add_circle, color: Colors.black)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("${numberOfItems}"),
                        ),
                        GestureDetector(
                          onTap: () => decrement(),
                          child: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            text: TextSpan(
                              text: 'Size :',
                              style: TextStyle(color: Colors.grey),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: ' L',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
