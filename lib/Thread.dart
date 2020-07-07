import 'package:flutter/material.dart';

class Thread extends StatefulWidget {
  String link;

  Thread({this.link});

  @override
  _ThreadState createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thread'),
      ),
      body: new Center(
        child: new FlatButton(
          child: new Text('Show Flutter homepage'),
//          onPressed: () => _launchURL(context, widget.link),
        ),
      ),

//        body: WebviewScaffold(url: 'https://github.com/')
//      body: Center(
//        child: RaisedButton(
//            onPressed: () async {
//              await widget.browser.open(
//                  url: "https://flutter.dev/",
//                  options: ChromeSafariBrowserClassOptions(
//                      android: AndroidChromeCustomTabsOptions(
//                          addDefaultShareMenuItem: false),
//                      ios: IOSSafariOptions(barCollapsingEnabled: true)));
//            },
//            child: Text("Open Chrome Safari Browser")),
//      ),

//      body: ListTile(
//        title: Text("Launch Web Page"),
//        onTap: () async {
//          const url =
//              'https://medium.com/flutter-community/how-to-modify-an-existing-pub-package-to-use-in-your-flutter-project-4e909452ee66';
//
//          if (await canLaunch(url)) {
//            await launch(url, forceWebView: true);
//          } else {
//            throw 'Could not launch $url';
//          }
//        },
//      ),
//      body: Stack(
//        children: <Widget>[
//          WebView(
//            initialUrl: widget.link,
//            onPageFinished: (finish) {
//              setState(() {
//                isLoading = false;
//              });
//            },
//            javascriptMode: JavascriptMode.unrestricted,
//          ),
//          isLoading
//              ? Center(
//                  child: CircularProgressIndicator(),
//                )
//              : Container(),
//        ],
//      ),
    );
  }
}
