import 'package:flutter/material.dart';
import 'package:man_uang/components/our_button.dart';
import 'package:man_uang/utils/api_provider.dart';

import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? transaction;

  const TransactionForm({super.key, this.transaction});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final api = APIProvider();
  late String _description;
  late int _amount;
  late DateTime _date;
  late String _type;
  Category? _selectedCategory;
  List<Category> categories = [];

  Future<void> getCategories() async {
    api.getCategories().then((categories) {
      // print('get categories');
      setState(() {
        this.categories = categories;
        if (widget.transaction == null) {
          _selectedCategory = categories[0];
        } else {
          _selectedCategory = widget.transaction!.category;
        }
      });
    });
  }

  Future<void> insertTransaction() async {
    Transaction trans = Transaction(
      id: 0,
      amount: _amount,
      description: _description,
      type: _type,
      category: _selectedCategory!,
      transactionDate: _date,
    );
    api.addTransaction(trans);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await insertTransaction();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    if (widget.transaction != null) {
      _description = widget.transaction!.description;
      _amount = widget.transaction!.amount;
      _date = widget.transaction!.transactionDate;
      _type = widget.transaction!.type;
    } else {
      _description = '';
      _amount = 0;
      _date = DateTime.now();
      _type = '1';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          widget.transaction == null ? 'Tambah Transaksi' : 'Edit Transaksi',
        ),
        actions: [
          if (widget.transaction != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.orange[400]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: Container(
        height: double.infinity,
        color: Colors.green[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green[700]!),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _amount.toString(),
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green[700]!),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Jumlah tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Masukkan jumlah yang valid';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = int.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: "${_date.toLocal()}".split(' ')[0],
                  ),
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: InputDecoration(
                    labelText: 'Jenis Transaksi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Pemasukan')),
                    DropdownMenuItem(value: '2', child: Text('Pengeluaran')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  items:
                      categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                OurButton(
                  onPressed: () => _submitForm(),
                  title: "Simpan",
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
