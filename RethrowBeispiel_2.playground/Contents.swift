//: Playground - noun: a place where people can play

import Foundation


/// Fehler-Enum mit zwei Fehler-Konstanten.
enum FehlerTyp : Error {
    
    /// Fehler mit Parameter wenn negative Zahl gefunden
    case negativeZahl(dieBoeseZahl:Int)
    
    /// Fehler zum Weiterwerfen eines Fehlers
    case boeseZahlWeiterwerfen(dieBoeseZahl:Int)
}


/// Klasse, deren Objekte jeweils genau drei Int-Zahlen speichern können.
class DreiIntWerte {
    
    var zahl1:Int
    var zahl2:Int
    var zahl3:Int
    
    /// Initialisierer, um drei Int-Werte in die entsprechenden Properties zu kopieren.
    init(i1:Int, i2:Int, i3:Int) {
        self.zahl1 = i1
        self.zahl2 = i2
        self.zahl3 = i3
    }
    
    /// Methode, um eine als Parameter übergebene Funktion auf alle drei Zahlenwerte anzuwenden.
    /// Methode ist mit `rethrows` deklariert, es darf also nur innerhalb von `catch`-Block
    /// ein Fehler geworfen werden.
    ///
    /// - parameter dieFunktion: Funktion (kann *throwing* sein), die auf die drei Zahlenwerte anzuwenden ist.
    func anwenden( dieFunktion:(Int) throws -> () ) rethrows {
        do {
            try dieFunktion(self.zahl1)
            try dieFunktion(self.zahl2)
            try dieFunktion(self.zahl3)
            
        } catch FehlerTyp.negativeZahl(let boeseZahl) {
            throw FehlerTyp.boeseZahlWeiterwerfen(dieBoeseZahl:boeseZahl)
        }
    }
}

/// Erste Funktion, die keinen Fehler werfen kann;
/// deshalb muss Aufruf von `anwenden()` nicht mit einem
/// do-try-catch-Block versehen werden.
///
/// - parameter dieZahl: Zahl, die auf *STDOUT* geschrieben wird.
func funktion1(dieZahl:Int) {
    print("Funktion auf Zahl \(dieZahl) angewendet.")
}

/// Zweite Funktion, kann Fehler werfen.
///
/// - parameter dieZahl: Zahl, die auf *STDOUT* geschrieben wird.
/// - throws: Wirft einen Fehler, wenn die übergebene Zahl echt kleiner als 0 ist.
func funktion2(dieZahl:Int) throws {
    if dieZahl < 0 { throw FehlerTyp.negativeZahl(dieBoeseZahl:dieZahl) }
    print("Funktion auf Zahl \(dieZahl) angewendet.")
}


// ****** "Haupt"-Programm ******

let dreiWerte = DreiIntWerte(i1:123, i2:42, i3:-9999)

// Methode `anwenden()` mit non-throwing Funktion aufrufen.
dreiWerte.anwenden(dieFunktion:funktion1)

// Methode `anwenden()`mit throwing Funktion aufrufen.
do {
    try dreiWerte.anwenden(dieFunktion:funktion2)
    
} catch FehlerTyp.boeseZahlWeiterwerfen(let boeseZahl) {
    print("Fehler weitergeworfen worden; boeseZahl=\(boeseZahl).")
}

