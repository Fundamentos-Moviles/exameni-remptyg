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
  static const int bombQuant = 9;

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
            icon: const Icon(Icons.add, color: cons.NotAp),
            onPressed: () {
              setState(() {
                // Boton para reiniciar el juego
                cartas = List.generate(
                  fila,
                  (_) => List.generate(col, (_) => Blanks()),
                );
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
                var carta = cartas[filaIndex][colIndex];
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: Card(
                    color: carta.clicked ? carta.bomba ? cons.NotAp : cons.Aprov : cons.tarjeta,
                    child: AspectRatio(
                      // Es 1 para tener cuadrados que me gustan mas 
                      // que los rectangulos de las fotos del profe
                      aspectRatio: 1.0,
                      child: InkWell(
                        onTap: carta.clicked
                            ? null : () { // Si ya esta clickeada no hacer nada
                                setState(() {
                                  carta.clicked = true; // Si no cambiarla a true
                                });
                              },
                        child: const SizedBox.expand(),
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