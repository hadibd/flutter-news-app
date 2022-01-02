import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class DetailsView extends StatefulWidget {
  const DetailsView({
    Key? key,
    required this.author,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url
  }) : super(key: key);

  final String author, title, description, urlToImage, url;

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.grey.shade200,
        constraints: const BoxConstraints.expand(),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(widget.urlToImage),
              const SizedBox(height: 16,),
              Text(widget.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18), ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  Text(widget.author, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),),
                  const SizedBox(width: 10,),
                  Text('Published: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.normal, fontSize: 15),),
                ],
              ),
              const SizedBox(height: 16,),
              Text(widget.description, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal, fontSize: 16),),
              const SizedBox(height: 16,),
              InkWell(
                onTap: () async {
                  if(await url_launcher.canLaunch(widget.url)){
                    await url_launcher.launch(widget.url);
                  }
                  print('clicked');
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,

                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Text('See more: ${widget.url}', style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.normal, fontSize: 16),)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
