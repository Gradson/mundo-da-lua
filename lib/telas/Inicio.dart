import 'package:flutter/material.dart';
import 'package:mundo_da_lua/Api.dart';
import 'package:mundo_da_lua/model/Video.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class Inicio extends StatefulWidget {

  String _query;

  Inicio(this._query);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  _listarVideos(String search){
    return Api().pesquisar(search);
  }

  @override
  Widget build(BuildContext context) {



    return FutureBuilder<List<Video>>(
      future: _listarVideos(widget._query),
      builder: (context, snapshot){
        switch( snapshot.connectionState ){
          case ConnectionState.none :
          case ConnectionState.waiting :
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active :
          case ConnectionState.done :
            return showData(snapshot);
            break;
        }
        return Center(
          child: Text("Nenhum dado a ser exibido!"),
        );
      },
    );
  }

  Widget showData(AsyncSnapshot<List<Video>> snapshot) {
    {
      if (snapshot.hasData && snapshot.data.length > 0) {
        return ListView.separated(

            itemBuilder: (context, index) {
              List<Video> videos = snapshot.data;
              Video video = videos[ index ];

              return GestureDetector(

                onTap: () {
                  FlutterYoutube.playYoutubeVideoById(
                      apiKey: CHAVE_YOUTUBE_API,
                      videoId: video.id,
                    autoPlay: true,
                    appBarColor: Colors.lightBlue
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(video.imagem)
                          )
                      ),
                    ),
                    ListTile(
                      title: Text(video.titulo),
                      subtitle: Text(video.canal),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) =>
                Divider(
                  height: 2,
                  color: Colors.grey,
                ),
            itemCount: snapshot.data.length
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Nenhum data exibido para a pesquisa: " + widget._query, ),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      widget._query = "";
                    });
                  },
                  child: Text("recarregar novamente")
              ),
            ],
          ),
        );
      }
    }
  }
}
