import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_app/api_service/api_helper.dart';
import 'package:ecommerce_app/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/order_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  /*List<OrderDataModel> orderList = [];

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    orderList = await ApiHttpService().getAllOrderDatas();
    setState(() {});
  }
*/

  var connectivityResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<OrderProvider>(context,listen: false).getorderDataListFromProvider();
  }

  @override
  Widget build(BuildContext context) {
    var orderProviderDataList = Provider.of<OrderProvider>(context).orderList;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              orderProviderDataList.isNotEmpty?Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade200,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Name: ${orderProviderDataList[index].user!.name}"),
                              Text("Payment Status: ${orderProviderDataList[index].payment!.paymentStatus}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Price: ${orderProviderDataList[index].price} tk"),
                              Text("-  ${orderProviderDataList[index].quantity}  +"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${orderProviderDataList[index].orderStatus!.orderStatusCategory!.name}"),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: orderProviderDataList.length,
                  shrinkWrap: true,
                ),
              ):
              Container(child: CircularProgressIndicator(),)

            ],
          ),
        ),
      ),
    );
  }
}
