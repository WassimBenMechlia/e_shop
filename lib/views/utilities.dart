import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class categoriesShimmer extends StatefulWidget {
  const categoriesShimmer({super.key});

  @override
  State<categoriesShimmer> createState() => _categoriesShimmerState();
}

class _categoriesShimmerState extends State<categoriesShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: List.generate(
          5, // Number of shimmering items (adjust as needed)
          (index) => Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            height: 30,
            width: 70,
          ),
        ),
      ),
    );
  }
}

class productsShimmerEffect extends StatefulWidget {
  const productsShimmerEffect({super.key});

  @override
  State<productsShimmerEffect> createState() => _productsShimmerEffectState();
}

class _productsShimmerEffectState extends State<productsShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 20, mainAxisSpacing: 20, maxCrossAxisExtent: 200),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          );
        },
        semanticChildCount: 8,
      ),
    );
  }
}
