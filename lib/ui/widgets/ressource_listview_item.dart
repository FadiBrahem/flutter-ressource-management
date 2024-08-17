import 'package:flutter/material.dart';

class RessourceListViewItem extends StatefulWidget {
  
    final String ressourceName;
    final String ressourceRole;
    final String urlImgRessource;
    final bool isChecked;
    final ValueChanged<bool> onChanged;
    
    RessourceListViewItem({this.ressourceName,this.isChecked,this.onChanged,this.ressourceRole,this.urlImgRessource});

  @override
  _RessourceListViewItemState createState() => _RessourceListViewItemState();
}

class _RessourceListViewItemState extends State<RessourceListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: ConstrainedBox(constraints: BoxConstraints(
          maxHeight: 50,
          maxWidth: 50,
          minHeight: 50,
          minWidth: 50,
        ),
        child: FadeInImage.assetNetwork(
          placeholder: "lib/assets/loadingImage.gif",
          image: widget.urlImgRessource,
        ),
        ),
        title: Row(
          children: <Widget>[
             Expanded(child: Text(widget.ressourceName)),
             Checkbox(
               value: widget.isChecked,
               onChanged: widget.onChanged,
             ),
          ],
        ),
        subtitle: Text(widget.ressourceRole),
      ),
    );
  }
}