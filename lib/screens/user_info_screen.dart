import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/add_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class UserInfoScreen extends StatefulWidget {
  static const routeName = "/user_info";
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageUrl: "",
  );
  var _initValues = {
    "title": "",
    "imageUrl": "",
    "description": "",
    "price": "",
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "imageUrl": "",
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (err) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An error ocurred!"),
            content: Text("somthing went wrong!"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddNewProductScreen.routeName);
                },
                child: Text("Hokey"),
              )
            ],
          ),
        );
      }
      //finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }

    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Item"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: [
                        // isim alan
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            initialValue: "jfdgshf",
                            //  _initValues["title"],
                            decoration: InputDecoration(
                              labelText: "Isim",
                            ),
                          ),
                        ),
                        // soyisim alan
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            initialValue: "Soyisim",
                            //  _initValues["title"],
                            decoration: InputDecoration(
                              labelText: "Soyisim",
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      // kimlik alan
                      child: TextFormField(
                        enabled: false,
                        readOnly: true,
                        initialValue: "32165498726",
                        //  _initValues["title"],
                        decoration: InputDecoration(
                          labelText: "T.C Kimlik",
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                        left: 5,
                        right: 50,
                        bottom: 20,
                        top: 10,
                      ),
                      child: Column(
                        children: [
                          // 1. telefon no alan
                          TextFormField(
                            enabled: false,
                            readOnly: true,
                            initialValue: "05326549817",
                            //  _initValues["title"],
                            decoration: InputDecoration(
                              labelText: "Birnci telefon No. ",
                            ),
                          ),
                          // 2. tlelfon no. alan
                          TextFormField(
                            enabled: false,
                            readOnly: true,
                            initialValue: "05326549817",
                            //  _initValues["title"],
                            decoration: InputDecoration(
                              labelText: "Ikinci telefon No.",
                            ),
                          ),
                        ],
                      ),
                    ),

                    // adress alan
                    TextFormField(
                      enabled: false,
                      readOnly: true,
                      initialValue: "sahduygfdshfgdshvdsghfvdhgsvf",
                      //  _initValues["title"],
                      decoration: InputDecoration(
                        labelText: "adres",
                      ),
                      maxLines: 3,
                    ),

                    // urun fotograf
                    Container(
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.purple,
                        ),
                      ),
                      child:
                          // _imageUrlController.text.isEmpty
                          //     ? Text("fotograf yoktur!!")
                          //     :
                          FittedBox(
                              child: Image.network(
                        "https://i.pinimg.com/550x/bc/7e/d3/bc7ed3958d72396f9144bb15c466614c.jpg",
                        fit: BoxFit.cover,
                      )),
                    ),

                    // kiralama sursi
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            initialValue: "iki hafta",
                            //  _initValues["title"],
                            decoration: InputDecoration(
                              labelText: "kiralama suresi",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            initialValue: "10 gun",
                            //  _initValues["title"],
                            decoration: InputDecoration(
                              labelText: "Kalan sure",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
