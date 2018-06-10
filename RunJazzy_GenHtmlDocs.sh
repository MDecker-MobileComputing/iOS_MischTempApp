#!/bin/bash

# Ruby-Skript "Jazzy" ausfuehren, um aus Markdown-Kommentaren in den Swift-Dateien
# HTML-Doku zu erzeugen. Jazzy benoetigt fuer seine Arbeit eine XCode-Installation,
# kann also nur unter MacOS verwendet werden.
#
# Die Konstrukte, die (noch) nicht dokumentiert wurden, werden in der Datei
# undocumented.json aufgelistet.
#
# Installation von jazzy mit Ruby-Paketverwaltung "gem": sudo gem install jazzy
# Nachschauen, ob und wenn ja welche Version von jazzy installiert ist: gem list jazzy
#
# Dieses Bash-Skript muss sich im Verzeichnis mit der xcodeproj-Datei befinden, sonst
# findet jazzy den Quellcode nicht.
#
# Tutorial zu Swift-Markdown-Doku inkl. Jazzy: http://www.appcoda.com/swift-markdown/
# Homepage von Jazzy: https://github.com/realm/jazzy
#
# 1.2017, 6.2018.

# Verzeichnis fuer Ergebnis-Dateien, wird ggf. erstellt.
ORDNER_OUTPUT=../JazzyOutput/

# Swift-Version auf Konsole ausgeben
SWIFT_VERSION=$(xcrun swift -version | cut -d " " -f4)

echo -e "\nSwift-Version gefunden: "${SWIFT_VERSION}"\n"

jazzy --output $ORDNER_OUTPUT --min-acl private  --swift-version $SWIFT_VERSION
# --output <ORDNER>   : Ordner, in den erzeugte Dateien geschrieben werden.
# --min-acl <LEVEL>   : Auch non-public Klassen und Structs beruecksichtigen.
# --clean             : Ausgabe-Ordner vor Erzeugung neuer Dateien loeschen -- gefaehrlich!
# --skip-undocumented : Nicht-dokumentierte Konstrukte ueberspringen.
#
# Ausgabe aller Kommandozeilen-Optionen von jazzy: jazzy --help


# Erzeugte Dokumentation in Browser oeffnen
open -a Safari $ORDNER_OUTPUT/index.html
# -a: Programm, mit dem die Datei geoeffnet werden soll.

echo
