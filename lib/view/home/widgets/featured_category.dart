import 'package:flutter/material.dart';

class FeaturedCategories extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {
      "name": "Beauty",
      "image":
          "https://miro.medium.com/v2/resize:fit:11126/1*L9h4Ojj_Hy9b87BOz3ph4Q.jpeg",
    },
    {
      "name": "Fashion",
      "image":
          "https://media1.popsugar-assets.com/files/thumbor/zvdPA4DRjOwiZe4tpT_udMCePVg=/fit-in/792x1190/filters:format_auto():upscale()/2023/05/11/713/n/1922564/c207bb40d43e6fe4_netimgAF5n1Z.png",
    },
    {
      "name": "Kids",
      "image":
          "https://media.post.rvohealth.io/wp-content/uploads/2020/05/kid-bedtime-pajamas-bed-732x549-thumbnail.jpg",
    },
    {
      "name": "Mens",
      "image":
          "https://n.nordstrommedia.com/it/34df5c66-2066-4784-95d0-4f66c15fd790.jpeg?h=750&w=750",
    },
    {
      "name": "Womens",
      "image":
          "https://www.lavanyathelabel.com/cdn/shop/files/1_eb7dccc7-cb9a-4a54-a36e-9fbb32da21ed_1200x.jpg?v=1740035363",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Sort & Filter Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Featured",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.sort, size: 16),
                    label: Text("Sort"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.filter_alt, size: 16),
                    label: Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Horizontal Category List
        SizedBox(
          height: 100, // Adjust based on image size
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    // Category Image
                    ClipOval(
                      child: Image.network(
                        categories[index]["image"]!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Category Name
                    Text(
                      categories[index]["name"]!,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
