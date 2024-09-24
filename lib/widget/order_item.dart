import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  var _exbanded = false;

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(-1.5, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    //_heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return AnimatedContainer(
      height: _exbanded
          ? min(widget.order.products.length * 20.0 + 120, 200)
          : 105.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      constraints: BoxConstraints(minHeight: 50, maxHeight: 200),
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            ListTile(
              title: Text("\$ ${widget.order.amount.toStringAsFixed(2)}"),
              subtitle: Text(DateFormat("dd/MM/yyyy hh:mm ")
                  .format(widget.order.dateTime)),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _exbanded = !_exbanded;
                    });
                  },
                  icon:
                      Icon(_exbanded ? Icons.expand_less : Icons.expand_more)),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              height: _exbanded
                  ? min(widget.order.products.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${prod.quantity}x  \$ ${prod.price}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ))
                      .toList()),
            )
          ]),
        ),
      ),
    );
  }
}
