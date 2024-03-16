
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:lofiii/data/services/app_services.dart';
import 'package:one_context/one_context.dart';
import 'package:url_launcher/link.dart';

import '../../../logic/cubit/theme_mode/theme_mode_cubit.dart';
import '../../../resources/my_assets/my_assets.dart';
import '../../widgets/common/social_media_icon_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            OneContext().pop();
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        title: const Text("About"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LOFIII LOGO
          BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, state) {
              return SlideInDown(
                child: Center(
                  child: SvgPicture.asset(
                    state.isDarkMode
                        ? MyAssets.lofiiiLogoDarkModeSvg
                        : MyAssets.lofiiiLogoLightModeSvg,
                    height: 0.3.sh,
                  ),
                ),
              );
            },
          ),

          // Version
          const Text(AppServices.appFullVersion, style: TextStyle(fontWeight: FontWeight.w500),),

          Gap(0.05.sh),

          // Detail
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            child: Text(
              "This is an open-source project and can be found on",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ),

          // GitHub Button
          Link(
            uri: Uri.parse("https://github.com/ffurqanuddin/lofiii"),
            target: LinkTarget.blank,
            builder: (context, followLink) => TextButton(
              onPressed: () {
                followLink!();
              },
              child: Text(
                "GitHub",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Message
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.sp),
            child: Text(
              "If you liked my work\nshow some ❤️ and ⭐ the repo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),

          const Spacer(),

          // Stay Connected
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
            child: ZoomIn(
              child: Text(
                "Stay Connected",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          ElasticInUp(
            child: const ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                //! LinkedIn Button
                SocialMediaIconButton(
                    url: "https://www.linkedin.com/in/ffurqanuddin/",
                    icon: FontAwesomeIcons.linkedin),
            
                //! Instagram Button
                SocialMediaIconButton(
                    url: "https://www.instagram.com/furqanuddin.dev/",
                    icon: FontAwesomeIcons.instagram),
            
                //! Twitter Button
                SocialMediaIconButton(
                    url: "https://www.twitter.com/ffurqanuddin",
                    icon: FontAwesomeIcons.twitter),
            
                //! Threads Button
                SocialMediaIconButton(
                    url: "https://www.threads.net/@furqanuddin.dev",
                    icon: FontAwesomeIcons.threads),
              ],
            ),
          ),

          FadeInUp(
            child: Center(
              child: Text(
                "Made with ❤️ by Furqan Uddin",
                style: TextStyle(fontSize: 12.spMax),
              ),
            ),
          ),

          Gap(0.02.sh)
        ],
      ),
    );
  }
}

