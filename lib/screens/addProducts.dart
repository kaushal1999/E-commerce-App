import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class AddProduct extends StatefulWidget {
  static const routeName = '/add-product';
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _priceFocusNode = FocusNode();
  var _descriptionFocusNode = FocusNode();
  var _imageUrlController = TextEditingController();
  var _imageUrlFocusNode = FocusNode();
  var _formKey = GlobalKey<FormState>();
  var _addedProduct =
      Product(description: '', id: '', imageUrl: '', price: 0, title: '');

  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  // void _showDialog(){

  // }
  var _isLoading = false;
  var _initState = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_showUrlImage);
  }

  String? productId;

  @override
  void didChangeDependencies() {
    if (_initState) {
      super.didChangeDependencies();
      final modal = ModalRoute.of(context);
      if (modal != null) {
        productId = modal.settings.arguments as String?;
      }
      if (productId != null) {
        var product =
            Provider.of<Products>(context, listen: false).findById(productId!);
        _addedProduct = Product(
            description: product.description,
            id: product.id,
            imageUrl: product.imageUrl,
            price: product.price,
            title: product.title,
            isFav: product.isFav);
        _imageUrlController.text = product.imageUrl;
      }

      _initState = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_showUrlImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void _showUrlImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    _formKey.currentState!.save();

    if (productId == null) {
      // print('kadjj');
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_addedProduct);
      } catch (error) {
        // print(error);
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An error occured!'),
                content: Text('something went wrong!'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'))
                ],
              );
            });
      } finally {
        _isLoading = false;
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Products>(context, listen: false)
          .updateProduct(productId!, _addedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
        title: Text('Add your product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _addedProduct.title,
                      decoration: InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _addedProduct = Product(
                            description: _addedProduct.description,
                            id: _addedProduct.id,
                            imageUrl: _addedProduct.imageUrl,
                            price: _addedProduct.price,
                            title: newValue!,
                            isFav: _addedProduct.isFav);
                      },
                    ),
                    TextFormField(
                      initialValue: _addedProduct.price.toString(),
                      decoration: InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a  price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please provide a valid no.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Provide a no. greater than 0';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (newValue) {
                        _addedProduct = Product(
                            description: _addedProduct.description,
                            id: _addedProduct.id,
                            imageUrl: _addedProduct.imageUrl,
                            price: double.parse(newValue!),
                            title: _addedProduct.title,
                            isFav: _addedProduct.isFav);
                      },
                    ),
                    TextFormField(
                      initialValue: _addedProduct.description,
                      decoration: InputDecoration(labelText: 'description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a description';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _addedProduct = Product(
                            description: newValue!,
                            id: _addedProduct.id,
                            imageUrl: _addedProduct.imageUrl,
                            price: _addedProduct.price,
                            title: _addedProduct.title,
                            isFav: _addedProduct.isFav);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey)),
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  'Enter url',
                                )
                              : Image.network(_imageUrlController.text),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'imageUrl'),
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a url';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _addedProduct = Product(
                                  description: _addedProduct.description,
                                  id: _addedProduct.id,
                                  imageUrl: newValue!,
                                  price: _addedProduct.price,
                                  title: _addedProduct.title,
                                  isFav: _addedProduct.isFav);
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
