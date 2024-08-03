import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_context/one_context.dart';

import '../../../data/models/artist_model.dart';
import '../../pages/artist/artist_page.dart';

class ArtistsCardsListWidget extends StatelessWidget {
  const ArtistsCardsListWidget({super.key, required this.artistList});

  final List<ArtistModel> artistList;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        // color: Colors.amber,
        height: 0.2.sh,
        width: double.infinity,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,

            ///!------------Total Items-------///
            itemCount: artistList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                ///!  -------------    On Artists Circle Card Tap
                onTap: () {
                  _artistCardOnTap(context, index);
                },

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///!----------Cached Network Image--------///
                    CachedNetworkImage(
                      ///!--------Music Image Url List-------///
                      imageUrl: artistList[index].img.toString(),

                      ///!-------On Image Successfully Loaded---------///
                      imageBuilder: (context, imageProvider) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BounceInLeft(
                          child: Card(
                              shape: const CircleBorder(),
                              color: Colors.transparent,
                              margin: EdgeInsets.zero,
                              child: CircleAvatar(
                                radius: 55.w,
                                backgroundColor: Colors.transparent,
                                backgroundImage: imageProvider,
                              )),
                        ),
                      ),

                      ///!----------------On Loading-------------///
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 50.w,
                          backgroundColor: Colors.transparent,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      ),

                      ///!----------------On Error-------------///
                      errorWidget: (context, url, error) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 50.w,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Image isn't loaded, please check your Internet connection!",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(fontSize: 8.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///!--------Music  Title----------///
                    Text(
                      artistList[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 8.sp, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  ///?-----------        Methods    -------------///
  void _artistCardOnTap(BuildContext context, int index) {
    OneContext().push(
        MaterialPageRoute(
          builder: (context) => ArtistPage(
              artistName: artistList[index].name, image: artistList[index].img),
        ));
  }
}
