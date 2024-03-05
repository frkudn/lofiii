import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(CupertinoIcons.back)),
        title:  Text(
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.spMax),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.spMax, horizontal: 8.sp),
        child: ListView(
          children: [

            _description(
                "This Privacy Policy governs the information practices of LoFIII, an open-source mobile application only available on GitHub and F-Droid."),
            _heading("Personal Information:"),
            _description(
                "LoFIII collects minimal personal information, such as a username and profile picture, solely for enhancing user experience. Users can browse anonymously if preferred."),
            _heading("Feedback:"),
            _description(
                "The App includes a feedback feature that directs users to their email application for providing input directly to the developer"),
            _heading("Protection of Information:"),
            _description(
                "We employ industry-standard security measures to safeguard user data against unauthorized access or misuse."),
            _heading("Distribution:"),
            _description(
                "LoFIII is not available on mainstream app stores like the App Store or Google Play Store, ensuring user privacy and control."),
            _heading("Contact:"),
            _description(
                """For inquiries regarding this policy or the App, contact us at:\n\nLoFIII\nDeveloper: Furqan Uddin\nEmail: furqanuddin@programmer.net\n\nLast updated: March 2, 2024."""),
          ],
        ),
      ),
    );
  }

  Padding _heading(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.spMax),
      ),
    );
  }

  Padding _description(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 17.spMax),
      ),
    );
  }
}
