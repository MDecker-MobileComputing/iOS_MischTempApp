// Playground-Datei mit Beispiel zu Error-Typen mit Parametern.

import Foundation


/// Fehler-Typen und Berechnungs-Funktion wie in `TemperaturBerechnung.swift`, aber alle
/// geworfenen Fehler enthalten jetzt noch den ungültigen Wert.

/// Fehlertyp für ungültige Wassertemperaturen bei Mischtemperaturberechnung;
/// alle Fehler können jetzt den ungültigen Wert als Parameter mitgegeben bekommen.
enum TemperaturError : Error {
    
    /// Temperatur für heißes Wasser liegt nicht im zulässigen Bereich.
    case tempHeissesWasserUngueltig(ungueltigeTemperatur:Int)
    
    /// Temperatur für kaltes Wasser liegt nicht im zulässigen Bereich.
    case tempKaltesWasserUngueltig(ungueltigeTemperatur:Int)
    
    /// Ziel-Temperatur liegt nicht im zulässigen Bereich.
    case tempMischungUngueltig(ungueltigeTemperatur:Int)
    
    /// Ziel-Temperatur liegt nicht zwischen den beiden anderen Temperaturen.
    case tempMischungNichtZwischenKaltUndHeissTemp(ungueltigeTemperatur:Int)
    
    /// Heißes Wasser ist kälter als kaltes Wasser.
    case kaltHeissTempUngueltig(tempKalt:Int, tempHeiss:Int)
}

/// Fehlertyp für ungültige Wassermengen bei Mischtemperaturberechnung.
enum WasserMengenError : Error {
    case mengeHeissesWasserUngueltig(ungueltigeWassermenge:Double)
}


/// Funktion für Berechnung von Menge kaltes Wasser, die dem heißen Wasser zur Erreichung
/// der Zieltemperatur beizumischen ist.
///
/// - parameter tempHeissesWasser:  Temperatur des heißen Wassers in Grad Celsius.
/// - parameter tempKaltesWasser:   Temperatur des kalten Wassers in Grad Celsius;
///                                 muss niedriger als Temperatur des heißen Wassers sein.
/// - parameter tempZiel:           Gewünschte Temperatur (Grad Celsius), die durch
///                                 Mischen erreicht werden soll.
/// - parameter literHeissesWasser: Menge heißes Wasser in Liter.
/// - returns: Menge kaltes Wasser, die beizumischen ist, um die Zieltemperatur zu erhalten.
/// - throws: Fehler aus Enum `TemperaturError`, wenn eine der als Parameter übergebenen Temperaturen 
///           einen ungültigen Wert hat.
///           `WasserMengenError.MengeWarmesWasserUngueltig`, wenn die Heißwassermenge nicht > 0 Liter ist.
func berechneWassermenge(tempHeissesWasser:Int,
                         tempKaltesWasser:Int,
                         tempZiel:Int,
                         literHeissesWasser:Double) throws -> Double {
    
    if tempKaltesWasser  <= 0 || tempKaltesWasser  > 100 {
        throw TemperaturError.tempKaltesWasserUngueltig(ungueltigeTemperatur:tempKaltesWasser)
    }
    if tempHeissesWasser <= 0 || tempHeissesWasser > 100 {
        throw TemperaturError.tempHeissesWasserUngueltig(ungueltigeTemperatur:tempHeissesWasser)
    }
    if tempZiel          <= 0 || tempZiel          > 100 {
        throw TemperaturError.tempMischungUngueltig(ungueltigeTemperatur:tempZiel)
    }
    if tempHeissesWasser <= tempKaltesWasser {
        throw TemperaturError.kaltHeissTempUngueltig(tempKalt:tempKaltesWasser, tempHeiss:tempHeissesWasser)
    }
    if tempZiel >= tempHeissesWasser || tempZiel <= tempKaltesWasser {
        throw TemperaturError.tempMischungNichtZwischenKaltUndHeissTemp(ungueltigeTemperatur:tempZiel)
    }
    if literHeissesWasser <= 0.0 {
        throw WasserMengenError.mengeHeissesWasserUngueltig(ungueltigeWassermenge:literHeissesWasser)
    }
    
    return literHeissesWasser *
        ( Double(tempHeissesWasser) - Double(tempZiel)         ) /
        ( Double(tempZiel)          - Double(tempKaltesWasser) )
}



// ****** Aufruf der "throwing" Function ******
do {
    
    let ergebnis = try berechneWassermenge(tempHeissesWasser:95,
                                           tempKaltesWasser:10,
                                           tempZiel:70,
                                           literHeissesWasser:2.0)
    print("Ergebnis: \(ergebnis)")
    
} catch TemperaturError.tempKaltesWasserUngueltig(let ungueltigerWert) {
        
    print("Ungültige Kaltwasser-Temperatur: \(ungueltigerWert)")
    
} catch TemperaturError.tempHeissesWasserUngueltig(let ungueltigerWert) {

    print("Ungültige Heißwasser-Temperatur: \(ungueltigerWert)")
    
} catch TemperaturError.tempMischungUngueltig(let ungueltigerWert) {
    
    print("Ungültige Ziel-Temperatur: \(ungueltigerWert)")
    
} catch TemperaturError.kaltHeissTempUngueltig(let tempKalt, let tempHeiss) {

    print("Heißwasser-Temperatur \(tempHeiss) passt nicht zu Kaltwasser-Temperatur \(tempKalt).")
    
} catch TemperaturError.tempMischungNichtZwischenKaltUndHeissTemp(let tempZiel) {
    
    print("Ziel-Temperatur \(tempZiel) liegt nicht zwischen Heiß- und Kaltwasser-Temperatur.")
    
} catch WasserMengenError.mengeHeissesWasserUngueltig(let ungueltierWert) {
    
    print("Ungültige Menge an Heißwasser: \(ungueltierWert)")
}


