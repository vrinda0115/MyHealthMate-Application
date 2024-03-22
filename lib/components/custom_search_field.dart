import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final List<String> searchResults;
  final ValueChanged<String> onResultTap;
  final bool showResults;

  const CustomSearchField({
    Key? key,
    required this.onChanged,
    required this.searchResults,
    required this.onResultTap,
    required this.showResults,
  }) : super(key: key);

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: (value) {
            widget.onChanged(value);
          },
          decoration: InputDecoration(
            hintText: 'How can we help you?',
            icon: Icon(Icons.search),
          ),
        ),
        SizedBox(height: 4),
        if (widget.showResults) 
        _buildSearchResults(),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_controller.text.isEmpty || widget.searchResults.isEmpty) {
      return SizedBox.shrink();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        constraints: BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListView.builder(
          itemCount: widget.searchResults.length,
          itemBuilder: (context, index) {
            final result = widget.searchResults[index];
            return ListTile(
              title: Text(result),
              onTap: () {
                widget.onResultTap(result);
                _controller.clear();
              },
            );
          },
        ),
      ),
    );
  }
}


