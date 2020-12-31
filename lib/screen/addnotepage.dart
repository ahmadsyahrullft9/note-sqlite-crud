import 'package:flutter/material.dart';
import 'package:note_app/notedb/note.dart';
import 'package:note_app/notedb/notedb.dart';
import 'package:note_app/widget/confirm_dialog.dart';

class Addnotepage extends StatefulWidget {
  Addnotepage({Key key, this.title, this.note}) : super(key: key);

  Note note;
  final String title;

  @override
  _AddnotepageState createState() => _AddnotepageState();
}

class _AddnotepageState extends State<Addnotepage> {
  var notedb = Notedb();

  String title, desc;
  TextEditingController _title_controller = TextEditingController();
  TextEditingController _desc_controller = TextEditingController();
  bool _is_tittle_valid = true;

  final TextStyle _label_style = TextStyle(
      color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w800);

  bool check_form() {
    setState(() {
      if (title.length < 1) {
        _is_tittle_valid = false;
      } else {
        _is_tittle_valid = true;
      }
    });

    return _is_tittle_valid;
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title_controller.text = widget.note.title;
      _desc_controller.text = widget.note.desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Note tittle", style: _label_style),
              SizedBox(height: 2),
              TextField(
                controller: _title_controller,
                onChanged: (value) {
                  title = _title_controller.text;
                  desc = _desc_controller.text;
                  check_form();
                },
                decoration: InputDecoration(
                    hintText: "put yout note title here",
                    hintStyle:
                        TextStyle(color: Colors.black54.withOpacity(0.4)),
                    errorText: _is_tittle_valid ? null : "title is invalid"),
              ),
              SizedBox(height: 30),
              Text("Note desc", style: _label_style),
              SizedBox(height: 2),
              TextField(
                controller: _desc_controller,
                onChanged: (value) {
                  title = _title_controller.text;
                  desc = _desc_controller.text;
                  check_form();
                },
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: "put yout note desc here",
                    hintStyle:
                        TextStyle(color: Colors.black54.withOpacity(0.4))),
              ),
              SizedBox(height: 30),
              widget.note != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: RaisedButton(
                            onPressed: () {
                              if (check_form()) {
                                widget.note.title =
                                    _title_controller.text.toString();
                                widget.note.desc =
                                    _desc_controller.text.toString();
                                try {
                                  notedb.updateNote(
                                      widget.note.id, widget.note);
                                } finally {
                                  Navigator.of(context)
                                      .pop("note was successfully updated");
                                }
                              }
                            },
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Update",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 4,
                          child: RaisedButton(
                            onPressed: () {
                              Confirmdialog(
                                  title: "Delete Note Confirmation",
                                  message: 'Do you want to delete this note ?',
                                  confirm_button: "Delete",
                                  cancel_button: "Cancel",
                                  onConfirmation: () {
                                    try {
                                      notedb.deleteNote(widget.note.id);
                                    } finally {
                                      Navigator.of(context)
                                          .pop("note was successfully deleted");
                                    }
                                  }).showAlertDialog(context);
                            },
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Delete",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(minWidth: double.infinity),
                      child: RaisedButton(
                        onPressed: () {
                          title = _title_controller.text;
                          if (check_form()) {
                            try {
                              notedb.addItem(Note(title: title, desc: desc));
                            } finally {
                              Navigator.of(context)
                                  .pop("note was successfully added");
                            }
                          }
                        },
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16)),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
