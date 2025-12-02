import 'package:flutter/material.dart';


class HeadingWidget extends StatelessWidget {

  final String headingTitle;
  final String headingSubtitle;
  final VoidCallback onTap;
  final String buttonText;


  const HeadingWidget({super.key,required this.headingTitle,
  required this.headingSubtitle,
  required this.onTap,
  required this.buttonText
  });

  @override
  Widget build(BuildContext context) {
    return Card(
          shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(12), // optional: corners को round करने के लिए
          ),
      color: const Color.fromARGB(255, 49, 64, 92),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
                Text(
                  headingSubtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    color: const Color.fromARGB(255, 214, 205, 205)
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20.0),
                //   border: Border.all(
                //     color: AppConstant.appScendoryColor,
                //     width: 1.5,
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    
                      color: const Color.fromARGB(255, 196, 211, 61),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
