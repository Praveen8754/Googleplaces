import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as GeoCoading;
import 'package:google_place/google_place.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  googleplace(),
    );
  }
}



//TextEditingController searchCtrl = TextEditingController();

class googleplace extends StatefulWidget {
/*  final TextEditingController searchCtrl;
  final String hint;
  final Function callbackReload;
  final index;
  Function validate;*/
  googleplace(
     /* {Key key,
        this.searchCtrl,
        this.hint,
        this.callbackReload,
        this.index,
        this.validate})
      : super(key: key*/);
  @override
  _googleplaceState createState() => _googleplaceState();
}

class _googleplaceState extends State<googleplace> {
  late GooglePlace googlePlace;

  List<AutocompletePrediction> predictions = [];
  bool show = true;

 TextEditingController searchCtrl= TextEditingController();
    String? hint;
  Function? callbackReload;
  String? index;
   Function? validate;








  @override
  void initState() {
    String apiKey = 'Paste your Api key';
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // String hinttxt = widget.hint;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              RichText(text: const TextSpan( text: 'Search Place ',)),
              TextFormField(
                controller: searchCtrl,
               // style: Styles.regular12black,
                validator: (val) => validate!(val/*, hinttxt*/),
                decoration: InputDecoration(
                //  labelText: hinttxt,
                 // labelStyle: Styles.regular12lgrey2,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                  fillColor: Colors.transparent,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide:
                    BorderSide(width: 0.5, color: Color(0xffBCBCBC).withOpacity(0.5)),),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide:
                    BorderSide(width: 0.5, color: Color(0xffBCBCBC).withOpacity(0.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    borderSide:
                    BorderSide(width: 0.5, color: Color(0xffBCBCBC).withOpacity(0.5)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      borderSide: BorderSide(
                          width: 0.5, color: Color(0xffBCBCBC).withOpacity(0.5))),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 0.5, color: Colors.redAccent),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 15,
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      onPressed: () {
                        searchCtrl.text = "";
                        print('object');
                      }),
                ),
                onChanged: (value) {
                  print('one');
                  if (value.isNotEmpty && value.length > 2) {
                    print('three');
                    search(value);
                    show = true;

                    autoCompleteSearch(value);

                    print(value);
                  } else {
                    print('two');
                    if (predictions.length > 0 && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    } else {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
              ),
              show
                  ? ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      predictions[index].description!,
                      style:TextStyle(
                        color: Color(0xff707070),
                        fontSize: 12,
                      //  fontFamily: regularFont,
                      //  fontWeight: getFontWeight('Regular'),
                      ),
                    ),
                    onTap: () {
                      debugPrint(predictions[index].placeId);
                      print('${predictions[index].description}');
                      show = false;
                      searchCtrl.text = predictions[index].description!;

                      callbackPrevious();
                    },
                  );
                },
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  callbackPrevious() async {
    var addresses =
    await GeoCoading.locationFromAddress(searchCtrl.text);
    var latitude = '${addresses.first.latitude}';
    var longitude = '${addresses.first.longitude}';
    final coordinates = new GeoCoading.Location(
        latitude: double.parse('${addresses.first.latitude}'),
        longitude: double.parse('${addresses.first.longitude}'),
        timestamp: DateTime.now());
    var addr = await GeoCoading.placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {});
// print(first.coordinates);
    callbackReload!(searchCtrl.text, addr.first.postalCode,
        latitude, longitude, index);
  }
//    callbackPrevious() async{
//      print('---${searchCtrl.text}');
//    var addresses = await Geocoder.local.findAddressesFromQuery(searchCtrl.text);
// var first = addresses.first;
//    print(first.coordinates);

//                         FocusScopeNode currentFocus = FocusScope.of(context);
//                         if (!currentFocus.hasPrimaryFocus) {
//                           currentFocus.unfocus();
//                         }
//                         setState(() {});
//    print(first.coordinates);
// widget.callbackReload(searchCtrl.text,first.postalCode);

//    }

  void search(String value) async {
    var result =
    await googlePlace.search.getFindPlace(value, InputType.TextQuery);
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(
      value,
      components: [
        Component("country", "in"),
      ],
    );

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
