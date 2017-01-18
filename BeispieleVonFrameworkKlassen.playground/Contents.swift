
import Foundation

// Verwendung einer von Apple gelieferten Framework-Klasse, die
// Fehler werfen kann.
// API-Doku zu Methode write(toFile:atomically:encoding:) in Klasse String:
// https://developer.apple.com/reference/swift/string/1643084-write


let einString = "Dieser String soll in eine Datei geschrieben werden."
do {
  try einString.write(toFile:"datei-1.txt", atomically: true, encoding: .utf8)
  print("String wurde in Datei im Sandbox-Container geschrieben.")
}
catch {
  print("Exception beim Schreiben einer Datei aufgetreten: \(error)")
}

// Playground hat nur auf ein Sandbox-Container-Dateisystem Zugriff,
// Datei wird z.B. geschrieben unter:
// /var/folders/63/26kb00c11ybfl5ww4ntpwkkm0000gn/T/com.apple.dt.Xcode.pg/containers/com.apple.dt.playground.stub.iOS_Simulator.BeispieleVonFrameworkKlassen-9A7E6C95-B85D-46E3-983E-0963EC5D0DEC/datei.txt


// Selbes Beispiel, aber jetzt mit NSError-objekt, das Zusatz-Infos enthalten kann

let nochEinString = "Dieser String soll auch n eine Datei geschrieben werden."
do {
    try einString.write(toFile:"datei-2.txt", atomically: true, encoding: .utf8)
    print("Zweiter String wurde in Datei im Sandbox-Container geschrieben.")
}
catch let nserr as NSError{
    print("Exception beim Schreiben einer Datei aufgetreten: \(nserr.localizedDescription)")
}



