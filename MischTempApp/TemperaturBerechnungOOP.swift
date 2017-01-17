//
//  TemperaturBerechnungOOP.swift
//  MischTempMitSlider
//
//  Created by Michael Decker on 03/01/17.
//  Copyright © 2017 MDe. All rights reserved.
//

import Foundation


/// Berechnung mit Richmann-Formel (Misch-Temperatur) als Klasse. Einem Objekt werden die Temperaturen für das heiße
/// und das kalte Wasser übergeben (die als "fest" angenommen werden), mit der Methode `berecheKaltwassermenge()`
/// kann dann für die gewünschte Zieltemperatur und die Menge heißen Wassers die benötigte Kaltwassermenge
/// berechnet werden.
///
/// Diese Klasse hat eine Unterklasse namens `MischTemperaturRechnerMitGuard`, in der die Methode 
/// `berecheKaltwassermenge()` überschrieben ist.
class MischTemperaturRechner {

    /// Temperatur kaltes Wasser in Grad Celsius.
    var temperaturKaltesWasser:Int
    
    /// Temperatur heißes Wasser in Grad Celsius.
    var temperaturHeissesWasser:Int
    
    
    /// Dieser Initialisierer können dem Aufrufer (der ein Objekt zu erzeugen versucht) einen
    /// Fehler signalisieren:
    ///
    /// * Die Initialisierung kann mit `return nil` abgebrochen werden. Im vorliegenden Beispiel
    ///   wird dies für eine ungültige Heißwasser-Temperatur gemacht oder wenn die Heißwasser-Temperatur
    ///   nicht echt-größer als die Kaltwasser-Temperatur ist.
    ///   Man spricht dann von einem **failable Initializer**.
    ///
    /// * Wie "normale" Methoden kann ein Initialisierer einen Fehler mit `throw` werfen
    ///   (zwischen Ende Parameterliste und Beginn Rump muss Schlüsselwort `throws` stehen).
    ///   Im vorliegenden Fall wird bei einer ungültigen Kaltwassertemperatur ein Fehler geworfen.
    ///
    /// - important: Im vorliegenden Beispiel werden zu Demonstrations-Zwecken beide Möglichkeiten
    ///              für sehr ähnliche Fehler verwendet. In der Praxis wäre dies schlechter Stil.
    ///
    /// - parameters:
    ///   - tempKaltesWasser:  Temperatur des kälteren Wassers in Grad Celsius.
    ///   - tempHeissesWasser: Temperatur des heißeren Wassers in Grad Celsius.
    ///
    /// - throws: Bei einer ungültigen Kaltwasser-Temperatur wird ein Fehler vom Typ
    ///           `TemperaturError.TempKaltesWasserUngueltig` geworfen.
    ///
    init?(tempKaltesWasser:Int, tempHeissesWasser:Int) throws {
        
        // Die Properties müssen initialisiert worden sein, sonst ist ein "return nil"
        // nicht erlaubt.
        self.temperaturKaltesWasser  = 0
        self.temperaturHeissesWasser = 0
        
        if tempKaltesWasser  <= 0 || tempKaltesWasser  >= 100 {
           throw TemperaturError.tempKaltesWasserUngueltig
        }
        
        if tempHeissesWasser <= 0 || tempHeissesWasser >= 100 ||
           tempHeissesWasser <= tempKaltesWasser {
           return nil
        }
        
        self.temperaturKaltesWasser  = tempKaltesWasser
        self.temperaturHeissesWasser = tempHeissesWasser
    }
    
    
    /// Methode zur Berechnung der beizumischenden Kaltwassermenge zur Erreichung der
    /// Zieltemperatur bei einer bestimmten Menge Heißwasser. Die Temperaturen für das
    /// heiße und das kalte Wasser sind als Objekt-Properties gespeichert.
    ///
    /// - parameters:
    ///   - fuerZieltemperatur:   Gewünschte Zieltemperatur nach Mischen in Grad Celsius.
    ///   -  mitHeisswassermenge: Heißwassermenge in Liter.
    /// - returns: Benötigte Kaltwassermenge in Liter zur Erreichung der Ziel-Temperatur.
    /// - throws: Es wird ein Fehler vom Typ `TemperaturError.TempMischungNichtZwischenKaltUndHeissTemp`
    ///           geworfen, wenn die Zieltemperatur nicht zwischen den Temperaturen für Kalt- und Heißwasser
    ///           liegen. 
    ///           Wenn die Heißwassermenge kleiner-gleich 0 Liter ist, dann wird ein Fehler vom Typ
    ///           `WasserMengenError.MengeWarmesWasserUngueltig` geworfen.
    func berecheKaltwassermenge(fuerZieltemperatur:Int, mitHeisswassermenge:Double) throws -> Double {
        
        // Zulässigkeit Parameter 1 prüfen
        if (fuerZieltemperatur <= 0 || fuerZieltemperatur >= 100) {
            throw TemperaturError.tempMischungUngueltig
        }
        if fuerZieltemperatur <= self.temperaturKaltesWasser ||
           fuerZieltemperatur >= self.temperaturHeissesWasser {
            throw TemperaturError.tempMischungNichtZwischenKaltUndHeissTemp
        }
        
        // Zulässigkeit Parameter 2 prüfen
        if mitHeisswassermenge <= 0.0 {
            throw WasserMengenError.mengeHeissesWasserUngueltig
        }
        
        return mitHeisswassermenge *
            ( Double(self.temperaturHeissesWasser) - Double(fuerZieltemperatur)         )  /
            ( Double(fuerZieltemperatur)           - Double(self.temperaturKaltesWasser ) )
    }

}
