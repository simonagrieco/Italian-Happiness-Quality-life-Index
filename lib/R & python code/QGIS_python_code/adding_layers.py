import os
from qgis.core import QgsVectorLayer, QgsProject
from qgis.core import QgsGraduatedSymbolRenderer
from qgis.gui import *

# Imposta il percorso della cartella contenente i file GeoJSON
cartella_geojson = 'C:/Users/simon/OneDrive/Desktop/json3'

# Ottieni una lista di tutti i file GeoJSON nella cartella
files_geojson = [f for f in os.listdir(cartella_geojson) if f.endswith('.geojson')]

# Inizializza il progetto di QGIS
project = QgsProject.instance()

# Cicla attraverso i file GeoJSON e aggiungi ciascun file come un layer separato
for file_geojson in files_geojson:
    path_geojson = os.path.join(cartella_geojson, file_geojson)

    # Rimuovi l'estensione ".geojson" dal nome del file
    layer_name = os.path.splitext(file_geojson)[0]

    # Crea il layer vettoriale da file GeoJSON
    layer = QgsVectorLayer(path_geojson, layer_name, 'ogr')

    if not layer.isValid():
        print(f"Impossibile aprire il file GeoJSON {file_geojson}")
    else:
        # Aggiungi il layer al progetto di QGIS
        project.addMapLayer(layer)

        # Imposta la tipologia di simbologia a "Graduato"
        renderer = QgsGraduatedSymbolRenderer('', [])
        layer.setRenderer(renderer)

        # Imposta il campo di valore per la simbologia graduata
        field_name = f"MEDIA_VALORE_{layer_name}"
        renderer.setClassAttribute(field_name)

        # Imposta il numero di classi a 20
        #renderer.setGraduatedMethod(QgsGraduatedSymbolRenderer.EqualInterval)
        renderer.updateClasses(layer, QgsGraduatedSymbolRenderer.EqualInterval, 20)

        # Imposta la scala colori "Blues" come scala di colore
        color_ramp = QgsStyle().defaultStyle().colorRamp('Blues')
        renderer.updateColorRamp(color_ramp)


        # Applica le impostazioni del renderer al layer
        layer.triggerRepaint()

print("Aggiunta dei layer completata.")



