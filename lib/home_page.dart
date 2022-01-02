import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_news/details_view.dart';

import 'model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List news = [];
  List category = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  final apiKey = '3b1cd13e09c8414ca9fc804c5fa17abb';
  String url =
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=3b1cd13e09c8414ca9fc804c5fa17abb';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataCallByQuery(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Test News'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 65,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: TextField(
                textAlign: TextAlign.left,
                maxLines: 1,
                expands: false,
                autofocus: false,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  url =
                  'https://newsapi.org/v2/everything?q=$value&from=2021-12-24&sortBy=popularity&apiKey=3b1cd13e09c8414ca9fc804c5fa17abb';
                  news.clear();
                  dataCallByQuery(url);
                  print(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search here',
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Container(
              height: 65,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: ListView.separated(
                separatorBuilder: (_, index){
                  return SizedBox(width: 10,);
                },
                itemCount: category.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index){
                return OutlinedButton(

                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: StadiumBorder()
                    ),
                    onPressed: (){},
                    child: Text(category[index]));
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
              child: Text(
                'Latest news',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: news.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsView(
                                        author: news[index].author,
                                        title: news[index].title,
                                        description: news[index].description,
                                        urlToImage: news[index].urlToImage,
                                        url: news[index].url)));
                          },
                          child: Container(
                              height: 250,
                              child: Stack(
                                children: [
                                  Image.network(
                                    news[index].urlToImage,
                                    height: double.infinity,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(16),
                                      height: 250,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.black.withOpacity(0),
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            news[index].title,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          /*const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        news[index].description,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      ),*/
                                        ],
                                      )),
                                ],
                              )),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Future dataCall() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=3b1cd13e09c8414ca9fc804c5fa17abb';

    var res = await http.get(Uri.parse(url));
    Map data = jsonDecode(res.body);
    data['articles'].forEach((value) {
      setState(() {
        NewsModel newsModel = NewsModel(
          author: value['author'],
          description: value['description'],
          title: value['title'],
          url: value['url'],
          urlToImage: value['urlToImage'],
        );
        news.add(newsModel);
      });
    });
    print(news[0].title);
  }

  Future dataCallByQuery(String url) async {
    var res = await http.get(Uri.parse(url));
    Map data = jsonDecode(res.body);
    data['articles'].forEach((value) {
      setState(() {
        NewsModel newsModel = NewsModel(
          author: value['author'],
          description: value['description'],
          title: value['title'],
          url: value['url'],
          urlToImage: value['urlToImage'],
        );
        news.add(newsModel);
      });
    });
    print(news[0]);
    setState(() {});
  }
}
