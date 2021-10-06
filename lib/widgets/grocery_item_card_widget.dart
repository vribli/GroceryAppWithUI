import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/models/results.dart';
import 'package:grocery_app/styles/colors.dart';

class GroceryItemCardWidget extends StatelessWidget {
  GroceryItemCardWidget({Key key, this.item}) : super(key: key);
  final ApiSearchResult item;

  final double width = 174;
  final double height = 250;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: imageWidget(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AppText(
              text: item.name,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: item.size,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7C7C7C),
            ),
            AppText(
              text: item.supermarket,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7C7C7C),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                AppText(
                  text: item.promoPrice,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Container(
      child: Image.network(item.image),
    );
  }

}
