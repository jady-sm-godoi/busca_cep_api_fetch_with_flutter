import 'package:flutter/material.dart';
import 'package:busca_cep/services/via_cep_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String _result = '';

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar CEP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : const Text('Consultar'),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return const SizedBox(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);
    print(resultCep.localidade); // Exibindo somente a localidade no terminal

    setState(() {
      _result = resultCep.toJson().toString();
    });

    _searching(false);
  }

  Widget _buildResultForm() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(_result),
    );
  }
}
