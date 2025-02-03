import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yousef_nour/components/itemProduct.dart';
import 'package:yousef_nour/components/ProductDetails.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  final List<Image> A = [
    Image.asset("assets/L3PRO_4.webp"),
    Image.asset("assets/wall_2_1.webp"),
    Image.asset("assets/hh.webp"),
  ];

  String cat = "Smart Watch"; // Ensure the initial category is valid
  final List<Map<String, String>> categories = [
    {"name": "Smart Watch", "image": "assets/L3PRO_4.webp"},
    {"name": "Air Pods", "image": "assets/wall_2_1.webp"},
    {"name": "Power Bank", "image": "assets/hh.webp"},

 
     
  ];

  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate category dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double categoryWidth = screenWidth / 3; // Example: 3 categories per row
    double categoryHeight = categoryWidth * 1; // Aspect ratio (height/width)

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Section with caption and shadow
            CarouselSlider(
              items: A.map((image) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        image,
                      ],
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 20),

            // Categories Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Categories",
                    
                      style: TextStyle(
                        
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Horizontal Category List with Enhanced Card Styles
            SizedBox(
              height: categoryHeight, // Set the height of the category row
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal scroll
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = categories[index]['name'] == cat;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        cat = categories[index]['name']!;
                      });
                    },
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          // Set the hovered index to apply hover effects
                          hoveredIndex = index;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          // Reset hovered index when mouse leaves
                          hoveredIndex = -1;
                        });
                      },
                      child: Container(
                        width: categoryWidth, // Width of each category tile
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 11, 14, 14)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                          boxShadow: [
                            if (isSelected)
                              const BoxShadow(
                                color:  Color(0xFF2F019E),
                                offset: Offset(0, 5),
                                blurRadius: 10,
                              ),
                            // Shadow effect when hovered
                            if (hoveredIndex == index)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 8),
                                blurRadius: 10,
                              ),
                          ],
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2.0)
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center, // Center the text on the image
                          children: [
                            // Image as background with hover effect
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: AnimatedScale(
                                scale: hoveredIndex == index ? 1.05 : 1.0, // Scale effect on hover
                                duration: const Duration(milliseconds: 200),
                                child: Image.asset(
                                  categories[index]['image']!,
                                  width: categoryWidth, // Full width
                                  height: categoryHeight, // Full height
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Text on top of the image
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  categories[index]['name']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 5.0,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center, // Center the text
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Products Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Products Section with improved grid and shadow
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where("category", isEqualTo: cat)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading products. Please try again.'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found for this category.'));
                }

                final products = snapshot.data!.docs;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.9,
                    mainAxisExtent: 130,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    return ItemProduct(
                      image: product['imageProduct'],
                      nameProduct: product['nameProduct'],
                      Ontap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return ProductDetails(
                            imageProduct: product['imageProduct'],
                            nameProduct: product['nameProduct'],
                          );
                        }));
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
