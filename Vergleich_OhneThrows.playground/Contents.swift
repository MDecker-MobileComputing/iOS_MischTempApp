import Foundation

// Es werden zunächst vier Funktionen für aufeinanderfolgende Schritte definiert.
// Jede dieser Funktionen liefert genau sann `true` zurück, wenn sie erfolgreich
// ausgeführt wurde. 
// Ein Schritt darf nur dann ausgeführt werden, wenn der vorherige Schritt
// erfolgreich war.
// Alle "Schritt"-Funktionen liefern false für einen Fehlerhafte Ausführung zurück,
// wenn sich eine Zufallszahl ohne Rest durch 9 teilen lässt.
//
// Mit dem Menü-Punkt "Editor | Execute Playground" kann der Quellcode mit neuen
// Zufallswerten ausgeführt werden.


func schritt1() -> Bool {
  let restwert = arc4random() % 9
  return restwert != 0
}

func schritt2() -> Bool {
  let restwert = arc4random() % 9
  return restwert != 0
}

func schritt3() -> Bool {
  let restwert = arc4random() % 9
  return restwert != 0
}

func schritt4() -> Bool {
  let restwert = arc4random() % 9
  return restwert != 0
}



// ****** Haupt-Programm ******

let erg1 = schritt1()
if  erg1 == true {
    let erg2 = schritt2()
    if  erg2 == true {
        let erg3 = schritt3()
        if  erg3 == true {
            let erg4 = schritt4()
            if  erg4 == true {
                print("Alle vier Schritte erfolgreich!")
            }
        }
    }
}

// Viele verschachtelte if-Blöcke => Anti-Pattern "Pyramid of Doom"
// http://www.thomashanning.com/the-pyramid-of-doom/
