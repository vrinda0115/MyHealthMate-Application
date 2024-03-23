import 'package:flutter/material.dart';
import 'package:uipages/utils/category_list_page.dart';

class CategoryCard extends StatelessWidget {
  final String iconImagePath;
  final String categoryName;

  CategoryCard({
    required this.categoryName,
    required this.iconImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryListPage(categoryName: categoryName),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurple[100],
          ),
          child: Row(
            children: [
              Image.asset(
                iconImagePath,
                height: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(categoryName),
            ],
          ),
        ),
      ),
    );
  }
}
