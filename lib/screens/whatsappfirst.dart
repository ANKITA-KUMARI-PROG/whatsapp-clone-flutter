import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/whatsmodle.dart';
import 'package:http/http.dart' as http;

class Whatsappfirst extends StatefulWidget {
  const Whatsappfirst({super.key});

  @override
  State<Whatsappfirst> createState() => _WhatsappfirstState();
}

class _WhatsappfirstState extends State<Whatsappfirst> {
  Future<whatsmodle> apimodle() async {
    var url =
        "https://newsapi.org/v2/everything?q=tesla&from=2024-11-15&sortBy=publishedAt&apiKey=cf2fa996a6d84b68a69dee136effba77";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return whatsmodle.fromJson(result);
    } else {
      return whatsmodle();
    }
  }

  @override
  void initState() {
    super.initState();
    apimodle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "WhatsApp",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
          SizedBox(width: 10),
          Icon(Icons.camera_alt_sharp, color: Colors.white),
          SizedBox(width: 10),
          Icon(Icons.more_vert_sharp, color: Colors.white),
          SizedBox(width: 10),
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Ask Meta AI or Search',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    decorationColor: Colors.white,
                  ),
                  prefixIcon: Icon(
                    Icons.blur_circular_rounded,
                    color: Colors.blue,
                    size: 20,
                    shadows: [Shadow(color: Colors.black)],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: apimodle(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.hasData && snapshot.data?.articles != null) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height, // Set height
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              "${snapshot.data?.articles![index].urlToImage}",
                            ),
                          ),
                          title: Text(
                            '${snapshot.data?.articles![index].author}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${snapshot.data?.articles![index].source}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            "${snapshot.data?.articles![index].publishedAt}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data?.articles?.length ?? 0,
                    ),
                  );
                }

                return Center(child: Text('No Data Available'));
              }
            ),
          ],
        ),
      ),
      bottomNavigationBar: 
        BottomNavigationBar(
          items: [
            BottomNavigationBarItem(backgroundColor: Colors.blueGrey,
              icon: Icon(Icons.chat_sharp, color: Colors.white),
              label: 'chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.update_sharp, color: Colors.white),
              label: 'updates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined, color: Colors.white),
              label: 'group',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call, color: Colors.white,),
              label: 'call',
              
            ),
             ],
             
        ),
     floatingActionButton: FloatingActionButton(onPressed: (){},
     child: Icon(Icons.add_a_photo),backgroundColor: Colors.green,),
    );
  }
}
