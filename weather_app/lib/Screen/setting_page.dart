import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/theme_provider.dart';

class SettingPages extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Setting"),

      ),
      body: Consumer<ThemeProvider>(
          builder:(ctx, provider, __){

       return SwitchListTile.adaptive(
         title: Text("Light Theme"),
         subtitle: Text("Change theme mode here"),
         onChanged: (value){
            provider.updateTheme(value:value);

         },
         value: provider.getThemeValue(),
       );
      })
    );
  }
}


