import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/common/constant/color_res.dart';
import 'package:user_auth/common/constant/image_res.dart';
import 'package:user_auth/common/widget/widget.dart';
import 'package:user_auth/model/jokes_response.dart';
import 'package:user_auth/providers/jokes_provider.dart';

// ignore: must_be_immutable
class JokeList extends StatefulWidget {
  String selectedCategory;

  JokeList({
    this.selectedCategory,
  });

  @override
  _JokeListState createState() => _JokeListState();
}

class _JokeListState extends State<JokeList> {
  JokesResponse jokesResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topMenuBar(context, '${widget.selectedCategory} \'s Jokes'),
      body: FutureBuilder<JokesResponse>(
        future: Provider.of<JokesProvider>(context, listen: false)
            .fetchJokes(widget.selectedCategory),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text(
                  'Fetch chuck joke.',
                  textAlign: TextAlign.center,
                ),
              );
            case ConnectionState.active:
              return Center(
                child: Text(''),
              );
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Connection waiting.',
                  textAlign: TextAlign.center,
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return showAPILoader(context);
              } else {
                jokesResponse = snapshot.data;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: jokesResponse.categories.length,
                  itemBuilder: (context, index) => ListView(
                    shrinkWrap: true,
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorResource.White,
                        radius: 70,
                        child: CircleAvatar(
                          backgroundImage: jokesResponse.iconUrl == null
                              ? AssetImage(ImageResources.Avatar)
                              : NetworkImage(jokesResponse.iconUrl),
                          radius: 60,
                        ), //CircleAvatar
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Container(
                          child: Text(
                            '${jokesResponse.value}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: ColorResource.Black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '${widget.selectedCategory}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: ColorResource.White,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              }
          }
          return showAPILoader(context);
        },
      ),
    );
  }
}

