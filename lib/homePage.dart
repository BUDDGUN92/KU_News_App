import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'categoriesPage.dart';
import 'main.dart';
import 'model/allNewsModel.dart';
import 'model/bBcNewsModel.dart';
import 'newsDetailPage.dart';
import 'view_model/newsListViewModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsListViewModel newsListViewModel = NewsListViewModel();
  final format = DateFormat('MMMM dd,yyyy');

  @override
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesPage()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: Kheight * 0.05,
            width: Kwidth * 0.05,
          ),
        ),
        title: Text('News',
            style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: Kheight * 0.55,
            child: FutureBuilder<BbcNewsModel>(
              future: newsListViewModel.fetchBBcNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: spinkit);
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.articles?.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                            snapshot.data!.articles![index].publishedAt!);

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Kheight * 0.02),
                              height: Kheight * 0.6,
                              width: Kwidth * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(child: spinkit2),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: InkWell(
                                onTap: () {
                                  String newsImage = snapshot
                                      .data!.articles![index].urlToImage!;
                                  String newsTitle =
                                      snapshot.data!.articles![index].title!;
                                  String newsDate = snapshot
                                      .data!.articles![index].publishedAt!;
                                  String newsAuthor =
                                      snapshot.data!.articles![index].author!;
                                  String newsDesc = snapshot
                                      .data!.articles![index].description!;
                                  String newsContent =
                                      snapshot.data!.articles![index].content!;
                                  String newsSource = snapshot
                                      .data!.articles![index].source!.name!;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewsDetailPage(
                                              newsImage,
                                              newsTitle,
                                              newsDate,
                                              newsAuthor,
                                              newsDesc,
                                              newsContent,
                                              newsSource)));
                                },
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: const EdgeInsets.all(10),
                                      height: Kheight * 0.22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: Kwidth * 0.7,
                                            child: Text(
                                              snapshot.data!.articles![index]
                                                  .title!,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w700),
                                              // softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: Kwidth * 0.7,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${snapshot.data!.articles![index].source!.name}',
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            )
                          ],
                        );
                      });
                }
              },
            ),
          ),
          FutureBuilder<AllNewsModel>(
            future: newsListViewModel.fetchNews('general'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('');
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt!);

                      return InkWell(
                        onTap: () {
                          String newsImage =
                              snapshot.data!.articles![index].urlToImage!;
                          String newsTitle =
                              snapshot.data!.articles![index].title!;
                          String newsDate =
                              snapshot.data!.articles![index].publishedAt!;
                          String newsAuthor =
                              snapshot.data!.articles![index].author!;
                          String newsDesc =
                              snapshot.data!.articles![index].description!;
                          String newsContent =
                              snapshot.data!.articles![index].content!;
                          String newsSource =
                              snapshot.data!.articles![index].source!.name!;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsDetailPage(
                                      newsImage,
                                      newsTitle,
                                      newsDate,
                                      newsAuthor,
                                      newsDesc,
                                      newsContent,
                                      newsSource)));
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: Kwidth * 0.04,
                              vertical: Kheight * 0.02),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${snapshot.data!.articles![index].urlToImage}",
                                  height: Kheight * 0.18,
                                  width: Kwidth * 0.3,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(child: spinkit2),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  height: Kheight * 0.18,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Kwidth * 0.59,
                                        child: Text(
                                          snapshot
                                              .data!.articles![index].title!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600),
                                          // softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: Kwidth * 0.56,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${snapshot.data!.articles![index].source!.name}',
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                      // return Row(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Text(snapshot.data!.articles![index].title!),
                      //       ],
                      //     ),

                      //   ],
                      // );
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50.0,
);
