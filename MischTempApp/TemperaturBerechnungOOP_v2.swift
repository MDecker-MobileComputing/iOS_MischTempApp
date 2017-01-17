//
//  TemperaturBerechnungOOP_v2.swift
//  MischTempApp
//
//  Created by Michael Decker on 08.01.17.
//  Copyright © 2017 MDe. All rights reserved.
//

import Foundation


/// Unterklasse von `MischTemperaturRechner`, überschreibt (nur) die Berechnungs-Methode
/// so, dass die Fehler jetzt unter Verwendung eines `guard`-Statements geworfen werden.
///
/// Der Initialisierer wird geerbt, da in dieser Unterklasse keine neuen Properties
/// und Initialiserer definiert werden
/// ([siehe auch hier](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html)).
class MischTemperaturRechnerMitGuard : MischTemperaturRechner {
    
    
    /// Wie überschriebene Methode in Oberklasse, nur dass jetzt die Fehler unter
    /// Verwendung von `guard`-Statements ("Inverse Logik") ausgelöst werden.
    /// Ein `guard`-Statement führt den `else`-Zweig aus, wenn seine Bedinung(en)
    /// nicht erfüllt ist/sind.
    override func berecheKaltwassermenge(fuerZieltemperatur: Int, mitHeisswassermenge: Double)
             throws -> Double {
        
        guard fuerZieltemperatur > 0 && fuerZieltemperatur < 100
        else {
           throw TemperaturError.tempMischungUngueltig
        }
        
        // Es können auch mehrere durch Komma getrennte Bedingungen angegeben werden
        guard fuerZieltemperatur > self.temperaturKaltesWasser,
              fuerZieltemperatur < self.temperaturHeissesWasser
        else {
           throw TemperaturError.tempMischungNichtZwischenKaltUndHeissTemp
        }
    
        guard mitHeisswassermenge > 0.0
        else {
            throw WasserMengenError.mengeHeissesWasserUngueltig
        }
        
        return mitHeisswassermenge *
            ( Double(self.temperaturHeissesWasser) - Double(fuerZieltemperatur)         )  /
            ( Double(fuerZieltemperatur)           - Double(self.temperaturKaltesWasser ) )
    }
    
}
