import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:musik/conts/colors.dart';
import 'package:musik/screens/search_screen.dart';
import 'package:musik/conts/notification.dart' as notify;

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String wlcmTxt = (now.hour >= 5 && now.hour < 12)
        ? "Good Morning,\nMake Today Amazing."
        : ((now.hour >= 11 && now.hour < 20)
            ? "Good Evening,\nHope you doing well today"
            : "Good Night,\nEnjoy your night with Music");
    Size screen = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              width: screen.width * .8,
              child: Text(
                wlcmTxt,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: "Regular",
                    letterSpacing: 2,
                    height: 1),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              width: 50,
              height: 50,
              child: IconButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 68, 72, 83))),
                onPressed: () {
                
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchScreen();
                  }));
                },
                icon: const Icon(
                  Ionicons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
