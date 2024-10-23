import 'package:flutter/material.dart';
import 'soldpet.dart';

void main() {
  runApp(const MaterialApp(home: PetWidget()));
}

class Pet {
  final String name;
  final String price;
  final String imageUrl;

  Pet(this.name, this.price, this.imageUrl);
}

class PetopiaModel {
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  String? Function(BuildContext, String?)? textControllerValidator;

  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
  }
}

extension ListSpacingExtension on List<Widget> {
  List<Widget> divide(Widget separator) {
    if (length <= 1) return this;

    final items = <Widget>[];
    for (int i = 0; i < length; i++) {
      items.add(this[i]);
      if (i < length - 1) {
        items.add(separator);
      }
    }
    return items;
  }
}

T createModel<T>(BuildContext context, T Function() builder) {
  return builder();
}

class PetWidget extends StatefulWidget {
  const PetWidget({super.key});

  @override
  State<PetWidget> createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget> {
  late PetopiaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Pet> allPets = [
    Pet('Golden Retriever', '\$800', 'https://images.unsplash.com/photo-1627323721367-94128c3fa0f7?w=500&h=500'),
    Pet('Persian Cat', '\$600', 'https://images.unsplash.com/photo-1675191855420-c6735aa50c8f?w=500&h=500'),
    Pet('Mini Lop Rabbit', '\$150', 'https://images.unsplash.com/photo-1560648028-2e201cb1d2ee?w=500&h=500'),
    Pet('Siamese Kitten', '\$500', 'https://images.unsplash.com/photo-1608879551824-8073466bf2a9?w=500&h=500'),
    Pet('Beagle Puppy', '\$700', 'https://images.unsplash.com/photo-1633603064416-806a49c74224?w=500&h=500'),
    // Add more pets here...
  ];

  List<Pet> filteredPets = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PetopiaModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // Initially, show all pets
    filteredPets = allPets;
  }

  void _filterPets(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredPets = allPets
          .where((pet) => pet.name.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Petopia'),
          backgroundColor: const Color(0xFF6658E6),
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle profile icon press
                print('Profile icon pressed');
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildFeaturedPetsSection(),
                _buildAvailablePetsList(),
              ].divide(const SizedBox(height: 24)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 12, 4, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Search for pets...',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                            ),
                            onChanged: (query) {
                              _filterPets(query);
                            },
                          ),
                        ),
                      ].divide(const SizedBox(width: 8)),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => NewPageWidget()));
                  print('Filter button pressed');
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF6658E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ].divide(const SizedBox(width: 12)),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedPetsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Pets',
            style: TextStyle(
              fontFamily: 'Inter Tight',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: filteredPets.map((pet) {
                return _buildFeaturedPetCard(
                  pet.name,
                  pet.price,
                  pet.imageUrl,
                );
              }).toList().divide(const SizedBox(width: 16)),
            ),
          ),
        ].divide(const SizedBox(height: 16)),
      ),
    );
  }

  Widget _buildFeaturedPetCard(String name, String price, String imageUrl) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF6658E6),
                    ),
                  ),
                ].divide(const SizedBox(height: 4)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailablePetsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Pets',
            style: TextStyle(
              fontFamily: 'Inter Tight',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredPets.length,
            itemBuilder: (context, index) {
              final pet = filteredPets[index];
              return _buildAvailablePetRow(pet.name, pet.price, pet.imageUrl);
            },
          ),
        ].divide(const SizedBox(height: 16)),
      ),
    );
  }

  Widget _buildAvailablePetRow(String name, String price, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF6658E6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      body: Center(
        child: Text('This is the new page.'),
      ),
    );
  }
}
