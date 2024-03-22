import 'package:flutter/material.dart';

class HoverSearchResults extends StatefulWidget {
  final List<String> searchResults;
  final ValueChanged<String> onResultTap;

  const HoverSearchResults({
    Key? key,
    required this.searchResults,
    required this.onResultTap,
  }) : super(key: key);

  @override
  _HoverSearchResultsState createState() => _HoverSearchResultsState();
}

class _HoverSearchResultsState extends State<HoverSearchResults> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: _isHovering ? 200 : 0),
        child: ListView.builder(
          itemCount: widget.searchResults.length,
          itemBuilder: (context, index) {
            final result = widget.searchResults[index];
            return ListTile(
              title: Text(result),
              onTap: () => widget.onResultTap(result),
            );
          },
        ),
      ),
    );
  }
}
