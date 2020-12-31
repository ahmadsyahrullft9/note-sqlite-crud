import 'package:flutter/material.dart';
import 'package:note_app/notedb/note.dart';
import 'package:note_app/notedb/notedb.dart';
import 'package:note_app/screen/addnotepage.dart';

typedef StringValue = String Function(String);

class Notelistpage extends StatefulWidget {
  Notelistpage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _NotelistpageState createState() => _NotelistpageState();
}

class _NotelistpageState extends State<Notelistpage> {
  var notedb = Notedb();

  String _searchText = "";
  bool _isSearching = false;

  Widget actionIcon = Icon(Icons.search);
  Widget appBarTitle = Text("Sqlite Note Demo");
  Color appBarColor = Colors.blue;
  final TextEditingController _searchQuery = new TextEditingController();

  _NotelistpageState() {
    _isSearching = false;
    _searchQuery.addListener(() {
      setState(() {
        if (_searchQuery.text.isEmpty) {
          _isSearching = false;
          _searchText = "";
        } else {
          _isSearching = true;
          _searchText = _searchQuery.text;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  this.actionIcon = new Icon(
                    Icons.search,
                    color: Colors.white,
                  );
                  this.appBarTitle = new Text(
                    "Sqlite Note Demo",
                    style: new TextStyle(color: Colors.white),
                  );
                  this.appBarColor = Colors.blue;
                  _searchText = "";
                  _isSearching = false;
                } else {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    autofocus: true,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: new TextStyle(
                            color: Colors.white.withOpacity(0.77))),
                  );
                  this.appBarColor = Colors.grey;
                  _isSearching = true;
                }
              });
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: notedb.fetchNotes(_searchText),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Note> noteList = snapshot.data;
              if (noteList.length > 0) {
                return Container(
                    child: Notelist(snapshot.data, (value) {
                      setState(() {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(value.toString()),
                        ));
                      });
                    }),
                    margin: EdgeInsets.symmetric(vertical: 8));
              } else {
                return Center(
                  child: Text("Data notes kosong"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Addnotepage(title: "Form Add Note"))).then((value) {
            setState(() {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(value.toString()),
              ));
            });
          });
        },
      ),
    );
  }
}

class Notelist extends StatelessWidget {
  List<Note> noteList;

  StringValue callback;

  Notelist(this.noteList, this.callback);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Addnotepage(
                        title: "Form Update Note",
                        note: noteList[index]))).then((value) {
              callback(value);
            });
          },
          child: Card(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 10),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(noteList[index].title,
                            style: Theme.of(context).textTheme.title),
                        Text(noteList[index].desc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.black.withOpacity(0.7)))
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_right)
                ],
              ),
            ),
          ),
        );
      },
      itemCount: noteList.length,
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
