  import 'package:flutter/material.dart';
  import 'package:buscaminas/constantes.dart' as cons;
  import 'package:buscaminas/blanks.dart';
  import 'dart:math' as math; // Para las funciones de random

  class Buscaminas extends StatefulWidget {
    const Buscaminas({super.key});

    @override
    State<Buscaminas> createState() => _BuscaminasState();
  }

  class _BuscaminasState extends State<Buscaminas> {
    // Espacio para variables
    static const int fila = 6;
    static const int col = 6;
    static const int bombQuant = 5;

    late List<List<Blanks>> cartas;

    // Funcion para generar el estado de mis cartas y definir sus
    // diferentes estados en falso
    @override
    void initState() {
      super.initState();
      cartas = List.generate(
        fila,
        (filaIndex) => List.generate(
          col,
          (colIndex) => Blanks()),
      );
      generaBombas();
    }

    void generaBombas()  {
      var random = math.Random();
      for (var i = 0; i < bombQuant; i++) {
        var filaIndex = random.nextInt(fila);
        var colIndex = random.nextInt(col);
        if (!cartas[filaIndex][colIndex].bomba) {
          cartas[filaIndex][colIndex].bomba = true; //  Si no tiene bomba mete una
        } else {
          i--;  // Si tiene ya una, regresa a poner otra
        }
      }
    }

    int cuentaBombas(int f, int c) {  
      int cont = 0;
      if (f > 0 && cartas[f - 1][c].bomba) cont++;
      if (f < fila - 1 && cartas[f + 1][c].bomba) cont++;
      if (c > 0 && cartas[f][c - 1].bomba) cont++;
      if (c < col - 1 && cartas[f][c + 1].bomba) cont++;
      return cont;
    }

    void detenerJuego() {
      setState(() {
        for (var filaIndex = 0; filaIndex < fila; filaIndex++) {
          for (var colIndex = 0; colIndex < col; colIndex++) {
            cartas[filaIndex][colIndex].clicked = true;
          }
        }
      });
    }

    // Algoritmo obtenido de https://www.geeksforgeeks.org/dsa/flood-fill-algorithm/
    // Llamado Flood Fill aparentemente usado en algunos juegos de buscaminas de python
    void floodfill(int x, int y) {
      // Checa limites y casos finales
      if (x  < 0 || x >= fila || y < 0 || y >= col) return;
      var carta = cartas[x][y];
      if (carta.clicked || carta.bomba) return;
      // Si no es limite ni caso final entonces los pinta o en este caso
      // Establece como clickeados
      setState(() {
      carta.clicked = true;
      });

      // Checa el contador para saber donde parar (otro caso final)
      var cont = cuentaBombas(x, y);
      if (cont > 0) return;

      // Itera recursivamente sobre los 4 direcciones cardinales
      floodfill(x + 1, y);
      floodfill(x - 1, y);
      floodfill(x, y - 1);
      floodfill(x, y + 1);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: cons.Fondo,
        appBar: AppBar(
          backgroundColor: cons.Princ,
          title: const Text(
            'Buscaminas',
            style: TextStyle(color: cons.Fondo),
          ),
          actions: [
            IconButton(
              icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.refresh, color: Colors.pink),
              ),
              onPressed: () {
                setState(() {
                  // Boton para reiniciar el juego
                  cartas = List.generate(
                    fila,
                    (_) => List.generate(col, (_) => Blanks()),
                  );
                  generaBombas();
                });
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: fila,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, filaIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                col,
                (colIndex) {
                  // Variables de cada carta
                  var carta = cartas[filaIndex][colIndex];
                  var cont = cuentaBombas(filaIndex, colIndex);
                  return SizedBox(
                    // El sized box aqui me funciona como el contenedor con tamaños especificos
                    // En este caso controlar el tamaño de los botones ya que en mi laptop
                    // las medidas de las tarjetas originales se ve demasiado grande
                    width: 80,
                    height: 80,
                    child: Card(
                      color: carta.clicked ? carta.bomba ? cons.NotAp : cons.Aprov : cons.tarjeta,
                      child: Center(
                        child: InkWell(
                          onTap: carta.clicked
                              ? null : () { // Si ya esta clickeada no hacer nada
                                  setState(() {
                                    debugPrint("Carta ($filaIndex,$colIndex) presionada, bombas alrededor = $cont"); // DEBUG
                                  });
                                  if (carta.bomba)
                                    detenerJuego();
                                  else
                                    floodfill(filaIndex, colIndex);
                                },
                          child: Center(
                            child: carta.clicked && !carta.bomba && cont!=0
                              ? Text('$cont',
                                style: TextStyle(
                                  fontSize: 25,
                                  color:Colors.white,
                                ),
                              )
                              : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            );
          },
        ),
      );
    }
  }