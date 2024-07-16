import 'package:flutter/material.dart';

class Product {
  final String name;
  const Product({required this.name});

}

typedef CartChanged = Function(Product product, bool inCart);
typedef RemoveObject = Function(Product product);

class ShoppingListItem extends StatelessWidget{
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChange,
    required this.objectremover,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChanged onCartChange;
  final RemoveObject objectremover;

  Color _getColor(BuildContext context){
    return inCart
      ? Colors.black38
      : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context){
    return inCart
      ? const TextStyle(
        color: Colors.black87,
        decoration: TextDecoration.lineThrough,
        )
      : null;
  }

  @override
  Widget build(BuildContext context){
    return ListTile(
      onTap: (){ 
        onCartChange(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0].toUpperCase()),
        ),

      title: Text(product.name, style:_getTextStyle(context)),
      trailing:IconButton(
              onPressed: (){objectremover(product);},
              icon: const Icon(Icons.close_rounded, semanticLabel: "Remove Object From List"),
            ) ,
    );


  }



}

class ShoppingList extends StatefulWidget{
   const ShoppingList({required this.products, super.key});
   final List<Product> products;
  
  @override
  State<ShoppingList> createState() => _ShoppingListState();

}

class _ShoppingListState extends State<ShoppingList> {
  final _shoppingCart = <Product>{};
  final _fullcart = <Product>[];
  final fieldText = TextEditingController();
  void _handleCartChanged(Product product, bool inCart){
    setState(() {

      if (!inCart){ 
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  void _removeItem(Product product){
    setState(() {
      _fullcart.remove(product);
    });
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('ShoppingList'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Expanded(child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children:_fullcart.map((product){
              return ShoppingListItem(
                product: product,
                inCart: _shoppingCart.contains(product),
                onCartChange: _handleCartChanged,
                objectremover: _removeItem);
            }).toList()),
          ),
          Expanded(child:  TextField(
            decoration: const InputDecoration(border: OutlineInputBorder(),
              hintText: 'Enter your Item here'),
            autocorrect: true,
            controller: fieldText,
            onSubmitted: (text) {   
              Product newProd = Product(name: text);           
              _fullcart.add(newProd);
              fieldText.clear();
              setState(() {
                
              });
              },
            ),
          ),
        ], 
      ),
    );
  }
}




myApp(){
  const List<Product> prodList = [

    ];
  return const MaterialApp(
    title: 'Shopping App',
    home: ShoppingList(products: prodList),
  );
}

void main()=> runApp(myApp());