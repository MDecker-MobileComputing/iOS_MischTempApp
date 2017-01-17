import Foundation

// Wie Playground "Vergleich_OhneThrows", aber mit "Exceptions"
// zur Vermeidung der "Pyramid of Doom".
//
// Mit dem Menü-Punkt "Editor | Execute Playground" kann der Quellcode mit neuen
// Zufallswerten ausgeführt werden.

enum SchrittFehler : Error {
    case fehlerBeiSchritt1
    case fehlerBeiSchritt2
    case fehlerBeiSchritt3
    case fehlerBeiSchritt4
}

func schritt1() throws {
  let restwert = arc4random() % 9
  if  restwert == 0 { throw SchrittFehler.fehlerBeiSchritt1 }
}
func schritt2() throws {
  let restwert = arc4random() % 9
  if  restwert == 0 { throw SchrittFehler.fehlerBeiSchritt2 }
}
func schritt3() throws {
  let restwert = arc4random() % 9
  if  restwert == 0 { throw SchrittFehler.fehlerBeiSchritt3 }
}
func schritt4() throws {
  let restwert = arc4random() % 9
  if  restwert == 0 { throw SchrittFehler.fehlerBeiSchritt4 }
}


// ****** Haupt-Programm ******

do {
    try schritt1()
    try schritt2()
    try schritt3()
    try schritt4()
    print("Alle vier Schritte erfolgreich!")
}
catch {
    print("Es ist ein Fehler aufgetreten: \(error)")
}