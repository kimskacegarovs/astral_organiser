import 'package:flutter/material.dart';
import 'package:astral_organiser/quantified/repository.dart';
import 'package:astral_organiser/quantified/main_class.dart';

class QuantifiedScreen extends StatefulWidget {
  const QuantifiedScreen({super.key});

  @override
  QuantifiedScreenState createState() => QuantifiedScreenState();
}

class QuantifiedScreenState extends State<QuantifiedScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();

  final List<Quantified> _quantifieds = [];
  final List<QuantifiedCategory> _quantifiedCategories = [];
  QuantifiedCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadQuantifieds();
    _loadQuantifiedCategories();
    if (_quantifiedCategories.isNotEmpty) _selectedCategory = _quantifiedCategories[0];
  }

  void _loadQuantifieds() async {
    var quantifieds = await QuantifiedRepository().readQuantified();
    setState(() => _quantifieds.addAll(quantifieds));
  }

  void _loadQuantifiedCategories() async {
    var quantifiedCategories = await QuantifiedCategoryRepository().read();
    print(quantifiedCategories);
    setState(() => _quantifiedCategories.addAll(quantifiedCategories));
  }

  void _addQuantified() {
    final newQuantified = Quantified(amount: int.parse(_numberController.text), category: _selectedCategory!);
    setState(() => _quantifieds.add(newQuantified));
    QuantifiedRepository().writeQuantified(_quantifieds);
  }

  void _addCategory() {
    final newCategory = QuantifiedCategory(title: _categoryNameController.text);
    setState(() => _quantifiedCategories.add(newCategory));
    QuantifiedCategoryRepository().write(_quantifiedCategories);
    _categoryNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Quantified')),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _quantifieds.length,
                  itemBuilder: (context, index) => QuantifiedListItem(quantified: _quantifieds[index]))),
          quantifiedAdder(),
          categoryAdder()
        ]));
  }

  Container categoryAdder() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(
                    controller: _categoryNameController,
                    decoration: const InputDecoration(hintText: 'New category name'))),
            IconButton(icon: const Icon(Icons.add), onPressed: () => _addCategory()),
          ],
        ));
  }

  Container quantifiedAdder() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: TextField(controller: _numberController, decoration: const InputDecoration(hintText: 'amount'))),
            Expanded(
                child: DropdownButtonFormField<QuantifiedCategory>(
              value: _selectedCategory,
              onChanged: (QuantifiedCategory? newValue) => setState(() => _selectedCategory = newValue),
              items: _quantifiedCategories.map((QuantifiedCategory category) {
                return DropdownMenuItem<QuantifiedCategory>(value: category, child: Text(category.title));
              }).toList(),
            )),
            IconButton(icon: const Icon(Icons.add), onPressed: () => _addQuantified()),
          ],
        ));
  }
}

class QuantifiedListItem extends StatelessWidget {
  const QuantifiedListItem({super.key, required this.quantified});

  final Quantified quantified;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(quantified.category.title),
      subtitle: Text(quantified.amount.toString()),
      trailing: Text(quantified.createdAt.toIso8601String()),
    );
  }
}
