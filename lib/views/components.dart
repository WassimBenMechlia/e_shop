import "package:fashion_mod_app/views/purchase.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "../model/models.dart";

class CategorieButton extends StatefulWidget {
  final List<String> categories;
  final Function(String) Tap;

  const CategorieButton({
    Key? key,
    required this.categories,
    required this.Tap,
  }) : super(key: key);

  @override
  State<CategorieButton> createState() => _CategorieButtonState();
}

class _CategorieButtonState extends State<CategorieButton> {
  double width = 0;
  int _selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: widget.categories.map((category) {
          int index = widget.categories.indexOf(category);
          category.length.toDouble() > 10 ? width = 150.0 : width = 80;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedindex = index;
                widget.Tap(category);
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedindex == index
                      ? Colors.black
                      : Color.fromARGB(255, 207, 207, 207),
                ),
                borderRadius: BorderRadius.circular(15),
                color: _selectedindex == index ? Colors.black : Colors.white,
              ),
              height: 40,
              width: width,
              child: Center(
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    color:
                        _selectedindex == index ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  Product product;
  ProductList({super.key, required this.product});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  void nav(Product product) {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => Purchase(product: product))));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nav(widget.product);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(widget.product.image),
              fit: BoxFit.scaleDown, // Adjust as needed
            ),
            color: Colors.white),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.grey.withOpacity(0.3),
                  Colors.black.withOpacity(0.8)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$ ${widget.product.price}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.product.title.substring(0, 12)}...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
