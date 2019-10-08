import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';

class TelaValores extends StatefulWidget {
  @override
  _TelaValoresState createState() => _TelaValoresState();
}

class _TelaValoresState extends State<TelaValores> {
  final MAX_NUMERO_PLAYERS_PERMITIDO = 5;
  List<TextEditingController> wastes = [];
  List<TextEditingController> loots = [];
  int numeroDePlayersEscolhido = 2;
  String compartilhamento;
  bool calculado = false;
  List<Widget> listaResultado() {
    int wasteTotal = 0;
    int lootTotal = 0;
    for (int i = 0; i < numeroDePlayersEscolhido; i++) {
      try {
        wasteTotal += int.parse(wastes[i].text);
      } catch (e) {}
      try {
        lootTotal += int.parse(loots[i].text);
      } catch (e) {}
    }
    compartilhamento = "";
    int profitDaHunt = lootTotal - wasteTotal;
    double paraCadaUm = profitDaHunt / numeroDePlayersEscolhido;
    List<Widget> lista = [];
    String textoGeral =
        'Cada um ficará com ${paraCadaUm.toStringAsFixed(2)}, de forma que:';
    lista.add(Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        textoGeral,
        style: TextStyle(fontSize: 20.0),
      ),
    ));
    compartilhamento += textoGeral + '\n';
    for (int i = 0; i < numeroDePlayersEscolhido; i++) {
      int profitDoPlayer = 0;
      int lootPlayer = 0;
      int wastePlayer = 0;
      try {
        lootPlayer = int.parse(loots[i].text);
      } catch (e) {}
      try {
        wastePlayer = int.parse(wastes[i].text);
      } catch (e) {}

      profitDoPlayer = lootPlayer - wastePlayer;

      String textoDoPlayer = calculado
          ? 'Player ${i + 1}: ${(profitDoPlayer > paraCadaUm) ? 'paga ${(profitDoPlayer - paraCadaUm).toStringAsFixed(2)}' : 'recebe ${(paraCadaUm - profitDoPlayer).toStringAsFixed(2)}'}'
          : '';
      compartilhamento += textoDoPlayer + '\n';
      lista.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            textoDoPlayer,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );
    }
    return lista;
  }

  List<Widget> listaTelaCompleta() {
    List<Widget> lista = [];
    lista += listaTextEdits();
    lista.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (numeroDePlayersEscolhido > 1)
                setState(() {
                  calculado = false;
                  numeroDePlayersEscolhido--;
                });
            }),
        Text(
          'Número de players: $numeroDePlayersEscolhido',
          style: TextStyle(fontSize: 18.0),
        ),
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                if (numeroDePlayersEscolhido < MAX_NUMERO_PLAYERS_PERMITIDO) {
                  calculado = false;
                  numeroDePlayersEscolhido++;
                }
              });
            })
      ],
    ));
    lista.add(Divider());
    lista.add(Center(
      child: Text(
        (calculado ? 'Resultado:' : ''),
        style: TextStyle(fontSize: 22.0),
      ),
    ));
    if (calculado) lista += listaResultado();
    if (calculado)
      lista.add(Center(
        child: IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(compartilhamento);
            }),
      ));

    return lista;
  }

  List<Widget> listaTextEdits() {
    List<Widget> lista = [];
    for (int i = 0; i < numeroDePlayersEscolhido; i++) {
      lista.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Text(
                'Player ${i + 1}:',
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(),
                    hintText: 'Loot',
                    hintStyle: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black),
                onChanged: (valor) {
                  setState(() {
                    calculado = false;
                  });
                },
                controller: loots[i],
              )),
              Icon(
                Icons.money_off,
                color: Colors.black,
              ),
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(),
                    hintText: 'Waste',
                    hintStyle: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black),
                onChanged: (valor) {
                  setState(() {
                    calculado = false;
                  });
                },
                controller: wastes[i],
              )),
            ],
          ),
        ),
      ));
    }
    return lista;
  }

  @override
  void initState() {
    for (int i = 0; i < MAX_NUMERO_PLAYERS_PERMITIDO; i++) {
      wastes.add(TextEditingController());
      loots.add(TextEditingController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            calculado = true;
          });
        },
        child: Icon(Icons.check),
      ),
      appBar: AppBar(
        //TODO fazer tela de ajuda e dicas
        //actions: <Widget>[IconButton(icon: Icon(Icons.help), onPressed: () {})],
        title: Text('Calculadora de Loot'),
      ),
      body: ListView(
        children: listaTelaCompleta(),
      ),
    );
  }
}

//
//ListTile(
//leading: ,
//title: Row(
//children: <Widget>[
//Expanded(
//child: ListTile(
//leading: Icon(
//Icons.attach_money,
//color: Colors.black,
//),
//title: TextField(
//keyboardType: TextInputType.numberWithOptions(),
//inputFormatters: [
//WhitelistingTextInputFormatter.digitsOnly
//],
//decoration: InputDecoration(
//enabledBorder: UnderlineInputBorder(),
//hintText: 'Loot',
//hintStyle: TextStyle(color: Colors.black)),
//style: TextStyle(color: Colors.black),
//onChanged: (valor) {
//setState(() {
//calculado = false;
//});
//},
//controller: loots[i],
//),
//),
//),
//Expanded(
//child: ListTile(
//leading: Icon(
//Icons.money_off,
//color: Colors.black,
//),
//title: TextField(
//keyboardType: TextInputType.numberWithOptions(),
//inputFormatters: [
//WhitelistingTextInputFormatter.digitsOnly
//],
//decoration: InputDecoration(
//enabledBorder: UnderlineInputBorder(),
//hintText: 'Waste',
//hintStyle: TextStyle(color: Colors.black)),
//style: TextStyle(color: Colors.black),
//controller: wastes[i],
//onChanged: (valor) {
//setState(() {
//calculado = false;
//});
//}),
//),
//)
//],
//),
//)
