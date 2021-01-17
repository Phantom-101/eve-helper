import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final VoidCallback onTap;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final EdgeInsets padding;

  CardTile({
    this.onTap,
    this.leading,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.all(16),
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = Padding(
      padding: padding,
      child: Row(
        children: [
          SizedBox(width: 8),
          leading == null ? Container() : leading,
          leading == null ? Container() : SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title == null ? Container() : DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  child: title,
                ),
                subtitle == null ? Container() : SizedBox(height: 4),
                subtitle == null ? Container() : DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                  child: subtitle,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
    return Card(
      child: onTap == null ? InkWell(child: widget) : InkWell(onTap: onTap, child: widget),
    );
  }
}