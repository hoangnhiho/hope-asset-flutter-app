import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hope Asset Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Hope Asset Management App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var assets;
  bool _isLoading = false;

  _fetchData() async{
    setState(() {
      _isLoading = true;
    });

    var url = "http://13.239.113.45/api/v1/hardware";

  // Await the http get response, then decode the json-formatted responce.
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQyMWIzZmMyMGE3MTVlODM2YzBhNDhlOGY2MDk5N2Q4ZjVmZjE5MzJkMzk1MWI0ZjhhOGZlNDUzODJmMTdiOTQ5OWJmY2I4NGE0MjFiMzA4In0.eyJhdWQiOiIxIiwianRpIjoiZDIxYjNmYzIwYTcxNWU4MzZjMGE0OGU4ZjYwOTk3ZDhmNWZmMTkzMmQzOTUxYjRmOGE4ZmU0NTM4MmYxN2I5NDk5YmZjYjg0YTQyMWIzMDgiLCJpYXQiOjE1NTQ3OTE3NDcsIm5iZiI6MTU1NDc5MTc0NywiZXhwIjoxNTg2NDE0MTQ3LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.Cay8KtLYIHFCTqstBvj816qUdLfhAeSL4tTPL77X6ev1ajdOinUWNzqvFk0Z89E8o7wQu7gt7NGn7VzIncJ7NuZZ8K_2-16JTknA1_n1irIVpAKr37zhAfqABH9IMTVk7OOn2wq6RBdB1ZMzjI3EHbOiUJcpaur0C80aANk3uiHLa0sdvnET-LSJxIDbmJ34TPzFPWsNTRp0cA-_8DV4jkyCVfz3eVI6-IJDFp8Y6XJLEQpHUfy4FjqwaoDL4yDLXba1Aswjtw9PVqQ2MUsa1HxezKxcs1efDySDBjr8FtxFf4Fy5jFlqLtwMo3jh0onRtIlqOtz_IJndn2STq2TkYEUUSiPLjf4lALbF3tSYZbejrfsQe9bfpmObuZCFxUYm5Xxf9VLYDQikIyPOghTlmD3GXDgyC3ayYwO4lqfny6L_tY3fV32r6u96SdFjPA8BI53QFNWg6yUlXIeLgcMcvo9KeCXOPoEUXG0PVe3WP7jxKUKUPJrcCO7G5cW72yfT9wEnCCDeMDKkotlJlItq-pZFK9kVm-NhxcVy97T8-T4krX2Iw-1q4WUDWoBoDUgu-8m0rWN8iGWRN6l7FZyqRjGhviwCePCkVsrQ2ZPy6ae7jndtys2xcrlrGnM_lX6Z-pFvuf5lOhr5vahWHG7AsO7Wc5JPFNvJcQzm5no8E4',
    };
    var response = await http.get(url, 
      headers: requestHeaders
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      this.assets = jsonResponse['rows'];
      setState(() {
        _isLoading = false;
      });
      // print(assets);
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading ? new CircularProgressIndicator() : 
          new ListView.builder(
            itemCount: this.assets != null ? this.assets.length : 0,
            itemBuilder: (context, i){
              final asset = this.assets[i];
              return FlatButton(
                child: new AssetCell(asset), 
                padding: new EdgeInsets.all(0.0),
                onPressed: (){
                  Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new AssetPage(asset)
                  ));
                },
              );
              // return new AssetCell(asset);
            }
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class AssetCell extends StatelessWidget{
  final asset;
  AssetCell(this.asset);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Row(children: <Widget>[
                new Image.network(asset["image"], fit: BoxFit.cover, height: 100.0),
                new Container(width: 8.0),
                new Text(
                  asset["name"],
                  style: Theme.of(context).textTheme.headline
                ),
              ]),
              new Divider()
            ],
          ),
        )
      ],
    );
  }
}

class AssetPage extends StatelessWidget{
  final asset;
  AssetPage(this.asset);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(this.asset["name"])
      ),
      body: new Center(
        child: new AssetCell(this.asset),
      ),
    );
  }
}