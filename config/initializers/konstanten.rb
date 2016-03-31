VERSION = "1.0.4"

# Version 1.0.4 (31.03.16)
# - Vor Beenden der Schicht müssen ein Rapport und eine Checkliste angelegt sein
# - Schichten können nachträglich verändert werden (nur offline)
# Version 1.0.3 (05.11.15)
# - BUGFIX: Nur Dokumente des aktuellen Objekts anzeigen
# Version 1.0.2 (3.9.15)
# - BUGFIX: Beschraenkung auf 1 Jahr nur fuer Infos und Schichten
# 
# Version 1.0.1 (3.9.15)
# - BUGFIX: Geloeschte PDFs wurden in DB verdoppelt

# Benutzer-Typen
VERWALTER = 1
MITARBEITER = 2
KUNDE = 3

# Info-Arten
INFO_ART_NORMAL = 0
INFO_ART_PERSOENLICH = 1
INFO_ART_OBJEKT = 2
INFO_ART_NEUES_DOKUMENT = 3
INFO_ART_WICHTIG = 4

INFO_ART_STRING=["<keine Art>", "Persönlich", "Objekt", "Neues Dokument", "Wichtig"]
INFO_ART_TEXTFARBE=["black", "blue", "green", "purple", "red"]
INFO_ART_HINTERGRUNDFARBE=["white", "lightblue", "lightgreen", "plum", "tomato"]

CHECKLISTE_TYP_JA_NEIN = 1
CHECKLISTE_TYP_DATUM = 2
CHECKLISTE_TYP_UHRZEIT = 3
CHECKLISTE_TYP_FREITEXT = 4

CHECKLISTE_WERT_JA = "ja"
CHECKLISTE_WERT_NEIN = "nein"
CHECKLISTE_WERT_NULL = ""

PDF_DATEI_ART_ARB_ANW_ALLG = "1"
PDF_DATEI_ART_ARB_ANW_OBJ = "2"
PDF_DATEI_ART_SONST_OBJ = "3"

# Datum_Uhzeit-Format
FORMAT_INFO_DATUM = "%d.%m.%Y %H:%M"
FORMAT_SCHICHT_DATUM = "%d.%m.%Y"
FORMAT_UHRZEIT = "%H:%M"
