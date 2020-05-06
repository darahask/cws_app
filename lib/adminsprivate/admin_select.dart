import 'package:cws_app/adminsprivate/admin_display.dart';
import 'package:cws_app/adminsprivate/adminschat.dart';
import 'package:flutter/material.dart';

class AdminChatSelect extends StatelessWidget {
  final String type;
  AdminChatSelect(this.type);

  getWidget(String type){
    if(type == 'overall'){
      return AdminSelect();
    }else
    return AdminsChat(type);
  }

  @override
  Widget build(BuildContext context) {
    return getWidget(type);
  }
}