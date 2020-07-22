import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:tweet_ui/models/api/entieties/hashtag_entity.dart';
import 'package:tweet_ui/models/api/entieties/mention_entity.dart';
import 'package:tweet_ui/models/api/entieties/symbol_entity.dart';
import 'package:tweet_ui/models/api/entieties/url_entity.dart';
import 'package:tweet_ui/models/viewmodels/tweet_vm.dart';
import 'package:tweet_ui/src/url_launcher.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class TweetText extends StatelessWidget {
  TweetText(
    this.tweetVM, {
    Key key,
    this.textStyle,
    this.clickableTextStyle,
    this.padding,
  }) : super(key: key);

  final TweetVM tweetVM;
  final TextStyle textStyle;
  final TextStyle clickableTextStyle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    var spans = _getSpans(context);
    if (spans.isNotEmpty) {
      return Padding(
        padding: padding,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(children: spans),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  List<TextSpan> _getSpans(BuildContext context) {
    List<TextSpan> spans = [];
    int boundary = tweetVM.startDisplayText;
    var unescape = new HtmlUnescape();

    if (tweetVM.startDisplayText == 0 && tweetVM.endDisplayText == 0) return [];

    if (tweetVM.allEntities.isEmpty) {
      spans.add(TextSpan(
        text: unescape.convert(tweetVM.text),
        style: textStyle,
      ));
    } else {
      tweetVM.allEntities.asMap().forEach((index, entity) {
        // look for the next match
        final startIndex = entity.start;

        // respect the `display_text_range` from JSON.
        if (startIndex > tweetVM.endDisplayText) return;

        // add any plain text before the next entity
        if (startIndex > boundary) {
          spans.add(TextSpan(
            text: unescape.convert(String.fromCharCodes(tweetVM.textRunes,
                boundary, min(startIndex, tweetVM.endDisplayText))),
            style: textStyle,
          ));
        }

        if (entity.runtimeType == UrlEntity) {
          UrlEntity urlEntity = (entity as UrlEntity);
          final spanText = unescape.convert(urlEntity.displayUrl);
          spans.add(TextSpan(
            text: spanText,
            style: clickableTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                print('brosss');
                openUrl(urlEntity.url);
              },
          ));
        } else {
          final spanText = unescape.convert(
            String.fromCharCodes(tweetVM.textRunes, startIndex,
                min(entity.end, tweetVM.endDisplayText)),
          );
          spans.add(TextSpan(
            text: spanText,
            style: clickableTextStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (entity.runtimeType == MentionEntity) {
                  MentionEntity mentionEntity = (entity as MentionEntity);
                  _launchURL(context,
                      "https://twitter.com/${mentionEntity.screenName}");
                } else if (entity.runtimeType == SymbolEntity) {
                  SymbolEntity symbolEntity = (entity as SymbolEntity);
                  _launchURL(context,
                      "https://twitter.com/search?q=${symbolEntity.text}");
                } else if (entity.runtimeType == HashtagEntity) {
                  HashtagEntity hashtagEntity = (entity as HashtagEntity);
                  _launchURL(context,
                      "https://twitter.com/hashtag/${hashtagEntity.text}");
                }
              },
          ));
        }

        // update the boundary to know from where to start the next iteration
        boundary = entity.end;
      });

      spans.add(TextSpan(
        text: unescape.convert(String.fromCharCodes(tweetVM.textRunes, boundary,
            min(tweetVM.textRunes.length, tweetVM.endDisplayText))),
        style: textStyle,
      ));
    }

    return spans;
  }

  void _launchURL(BuildContext context, String link) async {
    try {
      await launch(
        link,
//      'https://www.twitter.com/COVIDNewsByMIB',
//      'https://www.instagram.com/p/CCLazYdDWlWmbulkq6jwvB3biebM-rw-aUb4H00/',
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          // or user defined animation.
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
