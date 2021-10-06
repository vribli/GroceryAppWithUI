import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:grocery_app/common_widgets/app_button.dart';
import 'package:grocery_app/common_widgets/app_text.dart';
import 'package:grocery_app/screens/dashboard/dashboard_screen.dart';
import 'package:grocery_app/styles/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home/home_screen.dart';
import 'explore_screen.dart';
import 'product_details/product_details_screen.dart';
import 'package:grocery_app/models/results.dart';

class WelcomeScreen extends StatelessWidget {
  final String imagePath = "assets/images/welcome_image.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
                icon(),
                SizedBox(
                  height: 20,
                ),
                welcomeTextWidget(),
                SizedBox(
                  height: 10,
                ),
                sloganText(),
                SizedBox(
                  height: 40,
                ),
                getButton(context),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ));
  }

  Widget icon() {
    String iconPath = "assets/icons/app_icon.svg";
    return SvgPicture.asset(
      iconPath,
      width: 48,
      height: 56,
    );
  }

  Widget welcomeTextWidget() {
    return Column(
      children: [
        AppText(
          text: "Ask Auntie",
          fontSize: 48,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        AppText(
          text: "for the best prices",
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget sloganText() {
    return Column(
      children: [
        AppText(
          text: "Compare supermarkets for",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xffFCFCFC).withOpacity(0.7),
        ),
        AppText(
          text: "the best deals and prices!",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xffFCFCFC).withOpacity(0.7),
        ),
      ],
    );
  }

  Widget getButton(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: "Search by name",
          fontWeight: FontWeight.w600,
          padding: EdgeInsets.symmetric(vertical: 25),
          onPressed: () {
            onTextClicked(context);
          },
        ),
        SizedBox(
          height: 20,
        ),
        AppButton(
          label: "Search by image",
          fontWeight: FontWeight.w600,
          padding: EdgeInsets.symmetric(vertical: 25),
          onPressed: () {
            onImageClicked(context);
          },
        ),
        SizedBox(
          height: 20,
        ),
        AppButton(
          label: "Product test",
          fontWeight: FontWeight.w600,
          padding: EdgeInsets.symmetric(vertical: 25),
          onPressed: () {
            onProductClicked(context);
          },
        ),

      ],
    );

  }

  void onTextClicked(BuildContext context) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) {
        return HomeScreen();
      },
    ));
  }

  void onImageClicked(BuildContext context) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) {
        return ExploreScreen();
      },
    ));
  }

  final temp = ApiSearchResult(
    availability : 'available',
    category: 'Alcohol',
    img : "https://ssecomm.s3-ap-southeast-1.amazonaws.com/products/sm/gsBKSTrP7e7OkGoMsWliG9cLmKIwgB.0.jpg",
    name : 'Beer',
    previousPrice : 3.00,
    productPrice : 3.00,
    promoPrice : 1.50,
    rating : 5.00,
    size : '3 x 400 ml',
    supermarket : 'Sheng Siong',
    url : 'google.com'
  );


  void onProductClicked(BuildContext context) {

    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) {
        return ProductDetailsScreen(temp);
      },
    ));
  }

}
