//
//  ViewController.swift
//  MischTempMitSlider
//
//  Created by Michael Decker on 29/12/16.
//  Copyright © 2016 MDe. All rights reserved.
//

import UIKit


/// Einzige ViewController-Klasse der App.
/// Die Klasse enthält mehrere Methoden, die alle dieselbe Berechnung durchführen,
/// aber die Fehlerbehandlung auf unterschiedliche Weisen implementieren; für jede
/// dieser Berechnungs-Methoden gibt es einen Button auf der Oberfläche.
class ViewController: UIViewController, UITextFieldDelegate {

    /// String-Konstante mit Temperatur-Einheit "°C" (Grad Celsius), zum Anhängen an Anzeige-Texte.
    let gradCelsiusString = "°C"
    
    /// Formatierer-Objekt für den Ergebniswert (Liter kaltes Wasser), 
    /// für Darstellung mit immer genau einer Nachkommastelle.
    /// Wird mit einem Closure initialisiert.
    let ergebnisWertFormatierer:NumberFormatter = {
       let formatter = NumberFormatter()
       formatter.minimumFractionDigits = 1
       formatter.maximumFractionDigits = 1
       formatter.minimumIntegerDigits  = 1
       return formatter
    }()
    

    // MARK: Outlets
    
    /// UI-Element zum Einstellen der Heißwassertemperatur; Bereich: 0°C bis 100°C, jeweils einschließlich.
    @IBOutlet weak var sliderTempHeissesWasser: UISlider!
    
    /// UI-Element zum Einstellen der Kaltwassertemperatur; Bereich: 0°C bis 100°C, jeweils einschließlich.
    @IBOutlet weak var sliderTempKaltesWasser : UISlider!
    
    /// UI-Element zum Einstellen der Zieltemperatur (gewünschte Misch-Temperatur);
    /// Bereich: 0°C bis 100°C, jeweils einschließlich.
    @IBOutlet weak var sliderTempZiel         : UISlider!
    
    /// UI-Element zur Anzeige der mit zugehörigem Slider aktuell eingestellten Heißwassertemperatur.
    @IBOutlet weak var labelTempHeissesWasser:  UILabel!
    
    /// UI-Element zur Anzeige der mit zugehörigem Slider aktuell eingestellten Kaltwassertemperatur.
    @IBOutlet weak var labelTempKaltesWasser :  UILabel!
    
    /// UI-Element zur Anzeige der mit zugehörigem Slider aktuell eingestellten Zieltemperatur (Mischtemperatur).
    @IBOutlet weak var labelTempZiel         :  UILabel!
    
    /// Textfeld zur Eingabe der Heißwassermenge; wird in Methode `viewDidLoad()`
    /// so konfiguriert, dass nur Ganzzahlwerte in dieses Feld eingegeben
    /// werden können.
    /// Die in diesem Feld eingegebene Wassermenge kann mit der Methode
    /// `getHeisswasserLiter()` ausgelesen werden.
    @IBOutlet weak var textFieldMengeHeissesWasser: UITextField!

    
    // MARK: Actions (Event-Handler-Methoden)
    
    /// Event-Handler-Methode für Änderung Kaltwasser-Temperatur mit Slider-Element.
    @IBAction func onSliderTempKaltWasserChanged(_ sender: UISlider) {
        let temperaturAlsInt = Int(sliderTempKaltesWasser.value)
        labelTempKaltesWasser.text = "\(temperaturAlsInt) \(gradCelsiusString)"
    }
    
    /// Event-Handler-Methode für Änderung Heißwasser-Temperatur mit Slider-Element.
    @IBAction func onSliderTempHeissesWasserChanged(_ sender: UISlider) {
        let temperaturAlsInt = Int(sliderTempHeissesWasser.value)
        labelTempHeissesWasser.text = "\(temperaturAlsInt) \(gradCelsiusString)"
    }
    
    /// Event-Handler-Methode für Änderung Ziel-Temperatur (Misch-Temperatur) mit Slider-Element.
    @IBAction func onSliderTempZielTempChanged(_ sender: UISlider) {
        let temperaturAlsInt = Int(sliderTempZiel.value)
        labelTempZiel.text = "\(temperaturAlsInt) \(gradCelsiusString)"
    }
    
    /// Event-Handler-Methode für Button "Catch 1", führt Formel-Berechnung aus.
    @IBAction func onButtonBerechnungMitCatch1(_ sender: UIButton) {
        berechnungDurchfuehren_Catch1()
    }
    
    /// Event-Handler-Methode für Button "Catch 2", führt Formel-Berechnung aus.
    @IBAction func onButtonBerechnungMitCatch2(_ sender: UIButton) {
        berechnungDurchfuehren_Catch2()
    }
    
    /// Event-Handler-Methode für Button "Catch 3", führt Formel-Berechnung aus.
    @IBAction func onButtonBerechnungMitCatch3(_ sender: UIButton) {
        berechnungDurchfuehren_Catch3()
    }
    
    /// Event-Handler-Methode für Button "Try?" (optional try), führt Formel-Berechnung aus.
    @IBAction func onButtonBerechnungMitTryOpt(_ sender: UIButton) {
        berechnungDurchfuehren_OptionalTry()
    }
    
    /// Event-Handler-Methode für Button "Try!" (forced try), führt Formel-Berechnung aus.
    @IBAction func onButtonBerechnungMitTryForce(_ sender: UIButton) {
        berechnungDurchfuehren_ForcedTry()
    }
    
    /// Event-Handler-Methode für Button "Defer", führt Formel-Berechnung durch.
    /// Unabhängig vom Erfolg der Berechnung (d.h. auch dann wenn ein
    /// Fehler geworfen wird) werden die drei Slider auf zulässige
    /// Start-Werte gesetzt.
    @IBAction func onButtonBerechnungMitDefer(_ sender: UIButton) {
        do {
            try berechnungDurchfuehren_Defer()
        }
        catch {
            zeigeDialog("Fehler während Berechnung: \(error)")
        }
    }
    
    /// Event-Handler-Methode für Button "OOP", führt Formel-Berechnung aus.
    @IBAction func onButtonBerechnungMitOOP(_ sender: UIButton) {
        berechnungDurchfuehren_OOP()
    }
    
    /// Event-Handler-Methode für Button "Guard", führt Formel-Berechnung aus.
    @IBAction func onButtonBerechnungMitGuard(_ sender: UIButton) {
        berechnungDurchfuehren_Guard()
    }
    
    /// Event-Handler-Methode für Button "Assert", führt Formel-Berechnung durch.
    /// Wenn eine der drei Temperatur-Werte außerhalb des zulässigen Bereichs 
    /// von echt-größer 0°C und echt-kleiner 100°C liegt, dann wird die App
    /// abgebrochen (aber nur wenn für Konfiguration `DEBUG` gebaut).
    ///
    /// Bitte in der Doku zu Methode `berechnungDurchfuehren_Assert()` nachlesen
    /// wie das Projekt für einen `DEBUG`-Build zu konfigurieren ist.
    @IBAction func onButtonBerechnungMitAssert(_ sender: UIButton) {
        berechnungDurchfuehren_Assert()
    }
    
    /// Event-Handler-Methode für Button "FatalError", führt Formel-Berechnung durch.
    /// Wenn eine der drei Temperatur-Werte außerhalb des zulässigen Bereichs
    /// von echt-größer 0°C und echt-kleiner 100°C liegt, dann wird die App
    /// abgebrochen, und zwar unabhängig von der Build-Konfiguration.
    @IBAction func onButtonBerechnungMitFatalError(_ sender: UIButton) {
        berechnungDurchfuehren_FatalError()
    }
    
    
    // MARK: "Normale" Methoden
    
    /// Methode sorgt dafür, dass zum Start die drei Textfelder den aktuellen Wert der jeweiligen Slider anzeigen.
    /// Außerdem wird das Textfeld für die Eingabe der Heißwassermenge so konfiguriert, dass nur zulässige Ganzzahlen
    /// eingegeben werden können.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.onSliderTempKaltWasserChanged   ( self.sliderTempKaltesWasser  )
        self.onSliderTempHeissesWasserChanged( self.sliderTempHeissesWasser )
        self.onSliderTempZielTempChanged     ( self.sliderTempZiel          )
        
        // TextField für Eingabe Heißwasser-Menge konfigurieren
        textFieldMengeHeissesWasser.keyboardType = UIKeyboardType.decimalPad // wie numberPad, aber noch mit einem Punkt
        textFieldMengeHeissesWasser.delegate     = self  // siehe Implementierung Protocol-Methode textField
        
        // Hide keyboard, see also http://stackoverflow.com/a/27079103
        let hideKeyboardTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.keyboardVerschwindenLassen)) // action is name of method to invoke
        self.view.addGestureRecognizer(hideKeyboardTapRecognizer)
    }
    
    /// Funktion zur Anzeige eines Textes mit einem modalen Dialog (ohne Titel).
    ///
    /// - parameter meldung : Eigentlicher Meldungs-Text, der mit einem Dialog angezeigt werden soll.
    private func zeigeDialog(_ meldung:String) {
        let meinAlert = UIAlertController(title         : "", // wird sowieso nicht angezeigt
                                          message       : meldung,
                                          preferredStyle: UIAlertControllerStyle.alert)
        
        // Button zum Schließen Dialog
        meinAlert.addAction(UIAlertAction(title  : "OK", // Button-Label
                                          style  : UIAlertActionStyle.default,
                                          handler: nil))
        
        self.present(meinAlert, animated: true, completion: nil)
    }
    
    /// Methode zum Auslesen der Kaltwassermenge in Liter, die im vom Outlet
    /// `textFieldMengeHeissesWasser` repräsentierten Textfeld gerade eingegeben
    /// ist. Dieses Textfeld ist so konfiguriert, dass nur positive Ganzzahlwerte
    /// (Milli-Liter) eingegeben werden können.
    ///
    /// - returns: Heißwassermenge in Liter
    private func getHeisswasserLiter() -> Double {
        let textStr = self.textFieldMengeHeissesWasser.text!
        let milliLiterOpt = Double(textStr) // kann nil zurueckgeben, wenn Textfeld gerade ganz leer ist
        if let milliLiter = milliLiterOpt {
           return milliLiter / 1000.0 // Umrechnung in Liter
        } else {
           return 0.0
        }
    }
    
    /// Methode zur Formatierung der Ergebnismenge (Liter kaltes Wasser)
    /// in einen Anzeige-String mit immer genau einer Nachkommastelle.
    ///
    /// - parameter liter: Menge kaltes Wasser in Liter
    /// - returns: String mit formatierter Liter-Angabe, z.B. "0.3" oder "2.0".
    private func formatiereErgebnis(_ liter:Double) -> String {
        return ergebnisWertFormatierer.string(from:NSNumber(value:liter))!
    }
    
    
    // MARK: Berechnungs-Methoden
    
    /// Methode zur Durchführung der eigentlichen Berechnung.
    /// 
    /// **Catch 1:** Nur Default-Catch.
    func berechnungDurchfuehren_Catch1() {
        do {
            let ergebnisMenge =
                try berechneWassermenge(tempHeissesWasser:  Int(sliderTempHeissesWasser.value ),
                                        tempKaltesWasser:   Int(sliderTempKaltesWasser.value  ),
                                        tempZiel:           Int(sliderTempZiel.value          ),
                                        literHeissesWasser: getHeisswasserLiter()             )
            
            let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
            
            zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
        }
        catch { // Default-Catch
            zeigeDialog("Fehler während Berechnung: \(error)")
        }
    }
    
    /// Methode zur Durchführung der eigentlichen Berechnung.
    ///
    /// **Catch 2:** Mehrere Catch-Blöcke für verschiedene Fehler-Typen.
    func berechnungDurchfuehren_Catch2() {
      do {
        let ergebnisMenge =
            try berechneWassermenge(tempHeissesWasser:  Int(sliderTempHeissesWasser.value ),
                                    tempKaltesWasser:   Int(sliderTempKaltesWasser.value  ),
                                    tempZiel:           Int(sliderTempZiel.value          ),
                                    literHeissesWasser: getHeisswasserLiter()             )
            
        let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
            
        zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
      }
      catch TemperaturError.kaltHeissTempUngueltig {
        zeigeDialog("Fehler: Temperatur heißes Wasser liegt unter der von kaltem Wasser.")
      }
      catch is WasserMengenError {
        zeigeDialog("Fehler: Ungültige Heißwassermenge eingegeben.")
      }
      catch { // Default-Catch
         zeigeDialog("Fehler während Berechnung: \(error)")
      }
    }
    
    /// Methode zur Durchführung der eigentlichen Berechnung.
    ///
    /// **Catch 3:** Ein Catch-Block mit Switch-Case zur Unterscheidung der verschiedenen Temperatur-Fehler.
    func berechnungDurchfuehren_Catch3() {
      do {
        let ergebnisMenge =
            try berechneWassermenge(tempHeissesWasser:  Int(sliderTempHeissesWasser.value ),
                                    tempKaltesWasser:   Int(sliderTempKaltesWasser.value  ),
                                    tempZiel:           Int(sliderTempZiel.value          ),
                                    literHeissesWasser: getHeisswasserLiter()             )
            
        let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
        zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
      }
      catch let tempFehler as TemperaturError {
            
        switch tempFehler {
          case .tempHeissesWasserUngueltig:
            zeigeDialog("Fehler: Ungültige Heißwasser-Temperatur.")
                
          case .tempKaltesWasserUngueltig:
            zeigeDialog("Fehler: Ungültige Kaltwasser-Temperatur.")
                
          case .tempMischungUngueltig:
            zeigeDialog("Fehler: Ungültige Zieltemperatur für Mischung.")
                
          case .tempMischungNichtZwischenKaltUndHeissTemp:
            zeigeDialog("Fehler: Zieltemperatur liegt nicht zwischen Heiß- und Kaltwasser-Temperatur.")
                
          case .kaltHeissTempUngueltig:
            zeigeDialog("Fehler: Temperatur heißes Wasser ist nicht höher als Kaltwassertemperatur.")
        }
      }
      catch is WasserMengenError {
        zeigeDialog("Fehler: Ungültige Heißwassermenge eingegeben.")
      }
      catch { // Default-Catch
        zeigeDialog("Fehler während Berechnung: \(error)")
      }
    }
    
    /// Methode zur Durchführung der eigentlichen Berechnung.
    ///
    /// Fehlerbehandlung mit sog. *Optional Try* (`try?`).
    func berechnungDurchfuehren_OptionalTry() {
        
        let ergebnisMengeOpt =
            try? berechneWassermenge(tempHeissesWasser:  Int(sliderTempHeissesWasser.value ),
                                     tempKaltesWasser:   Int(sliderTempKaltesWasser.value  ),
                                     tempZiel:           Int(sliderTempZiel.value          ),
                                     literHeissesWasser: getHeisswasserLiter()             )
        
        if let ergebnisMenge = ergebnisMengeOpt {
            
            let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
            zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
            
        } else {
            zeigeDialog("Fehler: Berechnung konnte nicht durchgeführt werden.")
        }
    }
    
    /// Methode zur Durchführung der eigentlichen Berechnung.
    ///
    /// Fehlerbehandlung mit sog. *Forced try* (`try!`).
    ///
    /// - attention: Wenn die Berechnungs-Funktion einen Fehler wirft, dann stürzt die App ab.
    func berechnungDurchfuehren_ForcedTry() {
        
        let ergebnisMenge =
            try! berechneWassermenge(tempHeissesWasser:  Int(sliderTempHeissesWasser.value ),
                                     tempKaltesWasser:   Int(sliderTempKaltesWasser.value  ),
                                     tempZiel:           Int(sliderTempZiel.value          ),
                                     literHeissesWasser: getHeisswasserLiter()             )
        
        let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
        zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
    }
    
    /// Durchführung der Berechnung mit einem `defer`-Block, der unmittelbar vor
    /// Verlassen des umgebenden Blocks (hier: Rumpf der Methode) ausgeführt wird,
    /// egal wie der Block beendet wurde. Für die Fehlerbehandlung kann `defer`
    /// deshalb in etwa die Funktion des aus dem Exception-Handling bei anderen
    /// Programmiersprachen bekannten `finally`-Blocks übernehmen.
    /// In der Methode wird `defer` dafür verwendet, die Eingabewerte der
    /// drei Slider auf (zulässige) Start-Werte zu setzen, egal ob die
    /// Berechnung durchgeführt werden konnte oder ein Fehler an den
    /// Aufrufer hochgereicht wird.
    ///
    /// - attention: `defer` kann auch für andere Dinge als Fehlerbehandlung
    ///              eingesetzt werden.
    ///
    /// - attention: Defer-Block wird nur dann wirksam, wenn er vor dem Verlassen
    ///              des Blocks abgearbeitet wurde (er darf deshalb hier nicht
    ///              nach dem Aufruf der Berechnungs-Methode, die einen Fehler
    ///              werfen kann, stehen).
    ///
    /// - SeeAlso: Siehe [diesen Gist](https://gist.github.com/MDecker-MobileComputing/b572bc0fbf166d1179a93716153c8470) 
    ///            für ein Java-Beispiel mit `finally`-Block.
    ///
    /// - throws: Wenn die in dieser Methode aufgerufene Funktion `berechneWassermenge()`
    ///           einen Fehler wirft, dann wird dieser einach an die aufrufende Methode
    ///           (die Event-Handler-Methode) durchgereicht.
    func berechnungDurchfuehren_Defer() throws {
        
        // Defer-Block, wird auf jeden Fall vor Beendigung der Methode ausgeführt
        // (egal ob diese normal oder mit einem Fehler beendet wurde).
        defer {
            self.sliderTempKaltesWasser.value  = 10
            self.sliderTempHeissesWasser.value = 95
            self.sliderTempZiel.value          = 70
            
            // Events für Wert-Änderung manuell auslösen
            self.sliderTempKaltesWasser.sendActions (for: .valueChanged)
            self.sliderTempHeissesWasser.sendActions(for: .valueChanged)
            self.sliderTempZiel.sendActions         (for: .valueChanged)
        }
        
        // Durchführung der eigentlichen Berechnung
        let ergebnisMenge =
            try berechneWassermenge(tempHeissesWasser:  Int(sliderTempHeissesWasser.value ),
                                    tempKaltesWasser:   Int(sliderTempKaltesWasser.value  ),
                                    tempZiel:           Int(sliderTempZiel.value          ),
                                    literHeissesWasser: getHeisswasserLiter()             )
        
        let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
        
        zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
    }
    
    /// Diese Methode macht dasselbe wie die Methode `berechnungDurchfuehren`, verwendet statt der **Funktion**
    /// `berechneWassermenge` aber die **Klasse** `MischTemperaturRechner`.
    func berechnungDurchfuehren_OOP() {
        do {
            
            let mischTempRechnerOpt =
                try MischTemperaturRechner(tempKaltesWasser: Int(sliderTempKaltesWasser.value ),
                                           tempHeissesWasser:Int(sliderTempHeissesWasser.value))
            
            if let mischTempRechner = mischTempRechnerOpt {
                let ergebnisMenge =
                    try mischTempRechner.berecheKaltwassermenge(fuerZieltemperatur:  Int(sliderTempZiel.value ),
                                                                mitHeisswassermenge: getHeisswasserLiter()    )
                
                let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
                
                zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
                
            } else {
                zeigeDialog("Berechnungs-Objekt konnte nicht erzeugt werden.")
            }
        }
        catch {
            zeigeDialog("Fehler während Berechnung (OOP): \(error)")
        }
    }
    
    /// Wie Methode `berechnungDurchfuehren_OOP()`, nur dass jetzt eine Instanz der Klasse
    /// `MischTemperaturRechnerMitGuard` verwendet wird, in der die Methode `berecheKaltwassermenge()`
    /// so überschrieben ist, dass die Fehler unter Verwendung des Schlüsselworts `guard`ausgelöst
    /// werden.
    func berechnungDurchfuehren_Guard() {
        do {
            
            let mischTempRechnerOpt =
                try MischTemperaturRechnerMitGuard(tempKaltesWasser: Int(sliderTempKaltesWasser.value ),
                                                   tempHeissesWasser:Int(sliderTempHeissesWasser.value))
            
            if let mischTempRechner = mischTempRechnerOpt {
                let ergebnisMenge =
                    try mischTempRechner.berecheKaltwassermenge(fuerZieltemperatur:  Int(sliderTempZiel.value ),
                                                                mitHeisswassermenge: getHeisswasserLiter()    )
                
                let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
                
                zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
                
            } else {
                zeigeDialog("Berechnungs-Objekt konnte nicht erzeugt werden.")
            }
        }
        catch {
            zeigeDialog("Fehler während Berechnung (OOP): \(error)")
        }
    }
    
    /// Die Variante der Fehlerbehandlung verwendet zu Beginn einige `assert`-Statements,
    /// um Bedingungen (bool'scher Ausdrücke) zu definieren, die erfüllt sein müssen;
    /// ist eine dieser Bedingungen nicht erfällt, dann wird eine für die Konfiguration
    /// `DEBUG` gebaute App abgebrochen. Die im `assert`-Statement als zweiter Parameter
    /// übergebene Fehlerbeschreibung wird dabei auf der XCode-Konsole ausgegeben.
    /// Wenn die App für die Konfiguration `RELEASE` gebaut wurde, dann wird ein `assert`
    /// mit nicht erfüllter Bedingung einfach ignoriert.
    ///
    ///
    /// ### Konsole sichtbar machen: ###
    ///
    /// Die XCode-Konsole kann ggf. mit einer der folgenden beiden Möglichkeiten
    /// eingeblendet werden:
    ///
    /// * Menü-Eintrag: `View | Debug Area | Activate Console` 
    /// * Tasten-Kombination: `Shift+Cmd+C`
    ///
    /// Die Konsole sollte rechts unten in XCode erscheinen.
    ///
    ///
    /// ### Build-Konfiguration einstellen: ###
    ///
    /// * Im "Project Navigation" auf den obersten Eintrag klicken (Projekt selbst).
    /// * In Hauptfenster auf Tab "Build Settings".
    /// * Mit Suchfunktion nach `SWIFT_OPTIMIZATION_LEVEL` suchen.
    /// * Wenn als Wert “None [-Onone]“ eingestellt ist, dann wird ein `DEBUG`-Build
    ///   erstellt, d.h. die App bricht bei einer nicht erfüllten Assertion ab.
    /// * Für einen anderen Wert ("Fast, Single-File Optimization [-O]" oder 
    ///   “Fast, Whole Module Optimization [-O -whole-module-optimization]“ wird ein
    ///   `RELEASE`-Build erzeugt.
    /// * Über einen App-Store können nur `RELEASE`-Builds verteilt werden, d.h. das `assert`-
    ///   Statement zur Fehlersuche kann nur für Haus-interne Tests verwendet werden.
    /// * Siehe auch [diesen Blog-Artikel](http://blog.krzyzanowskim.com/2015/03/09/swift-asserts-the-missing-manual/).
    func berechnungDurchfuehren_Assert() {
            
        let tempHeissesWasser = Int(sliderTempHeissesWasser.value)
        assert(tempHeissesWasser > 0 && tempHeissesWasser < 100,
               "Heißwasser-Temperatur \(tempHeissesWasser)°C nicht zulässig.")
        
        let tempKaltesWasser = Int(sliderTempKaltesWasser.value)
        assert(tempKaltesWasser > 0 && tempKaltesWasser < 100,
               "Kaltwasser-Temperatur \(tempKaltesWasser)°C nicht zulässig.")
        
        let tempZiel = Int(sliderTempZiel.value)
        assert(tempZiel > 0 && tempZiel < 100,
               "Ziel-Temperatur \(tempZiel)°C nicht zulässig.")
        
        do {
            let ergebnisMenge =
                try berechneWassermenge(tempHeissesWasser:  tempHeissesWasser,
                                        tempKaltesWasser:   tempKaltesWasser,
                                        tempZiel:           tempZiel,
                                        literHeissesWasser: getHeisswasserLiter())
                
            let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
            zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
        }
        catch { // Default-Catch
            zeigeDialog("Fehler während Berechnung: \(error)")
        }
    }
    
    /// Diese Variante der Fehlerbehandlung verwendet die Funktion `fatalError()`,
    /// um bei einem ungültigen Wert für eine der drei Temperaturen die App
    /// abzubrechen (unbhängig von der Build-Konfiguration). Ein `fatalError` kann
    /// nicht abgefangen werden. Die der Funktion `fatalError()` übergebene
    /// Fehlermeldung wird in der XCode-Konsole ausgegeben; siehe Erklärung
    /// in Dokumentation zu Methode `berechnungDurchfuehren_Assert()`, wie diese
    /// Konsole eingeblendet werden kann.
    func berechnungDurchfuehren_FatalError() {
        
        let tempHeissesWasser = Int(sliderTempHeissesWasser.value)
        if tempHeissesWasser <= 0 || tempHeissesWasser >= 100 {
           fatalError("Heißwasser-Temperatur \(tempHeissesWasser)°C ist nicht im zulässigen Bereich.")
        }
        
        let tempKaltesWasser = Int(sliderTempKaltesWasser.value)
        if tempKaltesWasser <= 0 || tempKaltesWasser >= 100 {
           fatalError("Kaltwasser-Temperatur \(tempKaltesWasser)°C ist nicht im zulässigen Bereich.")
        }
        
        let tempZiel = Int(sliderTempZiel.value)
        if tempZiel <= 0 || tempZiel >= 100 {
            fatalError("Ziel-Temperatur \(tempZiel)°C ist nicht im zulässigen Bereich.")
        }
        
        do {
            let ergebnisMenge =
                try berechneWassermenge(tempHeissesWasser:  tempHeissesWasser,
                                        tempKaltesWasser:   tempKaltesWasser,
                                        tempZiel:           tempZiel,
                                        literHeissesWasser: getHeisswasserLiter())
            
            let ergebnisFormatiertStr = formatiereErgebnis(ergebnisMenge)
            
            zeigeDialog("Benötigte Menge kaltes Wasser:\n\n\(ergebnisFormatiertStr) Liter")
        }
        catch { // Default-Catch
            zeigeDialog("Fehler während Berechnung: \(error)")
        }
    }
    
    /// Event-Handler-Methode für den in der Methode `viewDidLoad()` definierten Tap-Recognizer,
    /// um das Keyboard wieder verschwinden zu lassen,
    /// wenn nach Eingabe in UITextField-Instanz an eine Stelle außerhalb des Keyboards getappt wird.
    /// Ruft auch Berechnung auf.
    @objc func keyboardVerschwindenLassen() {
        view.endEditing(true)
    }
    
    /// Methode aus Protocol `UITextFieldDelegate` überschreiben, damit nur Zahlen eingegeben werden können.
    /// Siehe auch [diese Antwort auf stackoverflow.com](http://stackoverflow.com/a/40989129/1364368).
    /// Methode wird für jeden Tastendruck (auch Loeschung) aufgerufen, also sind in replacementString einzelne Zeichen.
    ///
    /// - returns: `false` wenn die Textänderung verworfen werden soll.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Null als erste Ziffer verhindern
        if let currentDisplayText = textField.text {
            if currentDisplayText.count == 0 && string == "0" {
                return false
            }
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    /// Nicht benötigte Methode
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

