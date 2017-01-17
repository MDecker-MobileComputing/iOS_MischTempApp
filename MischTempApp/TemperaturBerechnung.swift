//
//  TemperaturBerechnung.swift
//
//  Created by Michael Decker on 27/12/16.
//  Copyright © 2016 MDe. All rights reserved.
//

import Foundation


// MARK: Fehler-Typen

/// Fehlertyp für ungültige Wassertemperaturen bei Mischtemperaturberechnung.
/// Laut Swift3-Konvention müssen die Bezeichner für die Enum-Elemente mit einem
/// Kleinbuchstaben anfangen.
enum TemperaturError : Error {
    
    /// Temperatur für heißes Wasser liegt nicht im zulässigen Bereich (>0°C und <100°C).
    case tempHeissesWasserUngueltig
    
    /// Temperatur für kaltes Wasser liegt nicht im zulässigen Bereich (>0°C und <100°C).
    case tempKaltesWasserUngueltig
    
    /// Ziel-Temperatur liegt nicht im zulässigen Bereich (>0°C und <100°C).
    case tempMischungUngueltig
    
    /// Ziel-Temperatur liegt nicht zwischen den beiden anderen Temperaturen.
    case tempMischungNichtZwischenKaltUndHeissTemp
    
    /// Heißes Wasser ist kälter als kaltes Wasser.
    case kaltHeissTempUngueltig
}

/// Fehlertyp für ungültige Wassermengen bei Mischtemperaturberechnung (Mengen kleiner-gleich 0 Liter).
enum WasserMengenError : Error {
    
    /// Fehler wenn Wassermenge kleiner-gleich 0 Liter ist.
    case mengeHeissesWasserUngueltig
}


// In einigen Beispielen wird statt "Error" noch "ErrorType" verwendet; letzteres ist aber veraltet:
// Fehlermeldung: 'ErrorType' has been renamed to 'Error'.


// MARK: Funktionen

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
/// - throws: Fehler aus Enum `TemperaturError`, wenn eine der als Parameter übergebenen Temperaturen einen ungültigen Wert hat.
///           `WasserMengenError.MengeHeissesWasserUngueltig`, wenn die Heißwassermenge nicht > 0 Liter ist.
func berechneWassermenge(tempHeissesWasser:Int,
                         tempKaltesWasser:Int,
                         tempZiel:Int,
                         literHeissesWasser:Double) throws -> Double {
    
    if tempKaltesWasser  <= 0 || tempKaltesWasser  >= 100 {
        throw TemperaturError.tempKaltesWasserUngueltig
    }
    if tempHeissesWasser <= 0 || tempHeissesWasser >= 100 {
        throw TemperaturError.tempHeissesWasserUngueltig
    }
    if tempZiel          <= 0 || tempZiel          >= 100 {
        throw TemperaturError.tempMischungUngueltig
    }
    if tempHeissesWasser <= tempKaltesWasser {
        throw TemperaturError.kaltHeissTempUngueltig
    }
    if tempZiel >= tempHeissesWasser || tempZiel <= tempKaltesWasser {
        throw TemperaturError.tempMischungNichtZwischenKaltUndHeissTemp
    }
    if literHeissesWasser <= 0.0 {
        throw WasserMengenError.mengeHeissesWasserUngueltig
    }
    
    return literHeissesWasser *
           ( Double(tempHeissesWasser) - Double(tempZiel)         ) /
           ( Double(tempZiel)          - Double(tempKaltesWasser) )
}


