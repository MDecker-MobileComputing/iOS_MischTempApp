// Playground-Datei mit Beispiel zu Verwendung von rethrows.
//
// Es werden zwei Funktionen definiert, die jeweils einen Int-Array als
// Parameter übergeben bekommen. Die zweite dieser Funktion ist eine
// "throwing function", kann also Fehler werfen.
//
// Diese beiden Funktionen werden dann nacheinander der `map()`-Methode
// einer Array-Instanz mit Int-Zahlen übergeben.
// API-Doku zu Methode Array::map(): https://developer.apple.com/reference/swift/array/1688519-map
// func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]
//
// Siehe auch Playground "RethrowBeispiel_2".

import Foundation


/// Fehler-Enum mit nur einem Fehler-Typ, nämlich für negative Zahl.
enum FehlerTyp : Error { case negativeZahl }


/// Erste Funktion für Anwendung auf Int-Array,
/// kann *KEINE* Fehler werfen.
func mapFunktion_1(dieZahlen:[Int]) {
    
    print("Anwendung von Funktion 1:")
    
    for zahl in dieZahlen {
        print("Zahl im Array: \(zahl)")
    }
}

/// Zweite Funktion: Wie Funktion `mapFunktion_1(dieZahlen)`, wirft aber
/// einen Fehler wenn der Array eine negative Zahl enthält.
func mapFunktion_2(dieZahlen:[Int]) throws {
    
    print("Anwendung von Funktion 2:")
    
    for zahl in dieZahlen {
        if zahl < 0 { throw FehlerTyp.negativeZahl }
        print("Zahl im Array: \(zahl)")
    }
}


// ****** "Haupt"-Programm ******

var zahlenArray = Array(arrayLiteral: [ 12, 42, -3, 99] )


// Da `mapFunktion1` keine Fehler werfen kann muss dieser Aufruf von Array::map()
// NICHT in einen do-try-catch-Block gepackt werden.
zahlenArray.map(mapFunktion_1)


// `mapFunktion2` kann einen Fehler werfen, also muss dieser Aufruf in einen
// do-try-catch-Block gepackt werden.
do {
    try zahlenArray.map(mapFunktion_2)
}
catch {
    print("Exception bei Anwendung von Funktion 2 auf Int-Array aufgetreten.")
}
