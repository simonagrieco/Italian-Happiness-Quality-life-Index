# Importa il modulo di QGIS
from qgis.core import *

# Ottieni il gruppo chiamato "indici"
group_name = "Indicatore:"
group = QgsProject.instance().layerTreeRoot().findGroup(group_name)

# Verifica se il gruppo esiste
if group:
    for layer_node in group.children():
        if isinstance(layer_node, QgsLayerTreeLayer):
            layer = layer_node.layer()

            # Crea un nuovo layout di stampa
            layout = QgsPrintLayout(QgsProject.instance())
            layout.initializeDefaults()

            # Imposta il nome del layout uguale al nome del layer (senza estensione)
            layout_name = layer.name().split(".")[0]
            layout.setName(layout_name)

            # Aggiungi una mappa al layout
            map = QgsLayoutItemMap(layout)
            map.setRect(20, 20, 160, 160)
            map.setScale(10549853)
            map.setLayers([layer])

            # Imposta l'estensione della mappa
            map_extent = QgsRectangle(307495.068, 4370920.891, 2085272.828, 6422556.593)  # Imposta l'estensione desiderata
            map.setExtent(map_extent)

            layout.addLayoutItem(map)


            # Rimuovi tutte le altre legende
            for item in layout.items():
                if isinstance(item, QgsLayoutItemLegend) and item != legend:
                    layout.removeItem(item)


            # Crea una legenda specifica per il layer
            legend = QgsLayoutItemLegend(layout)
            layout.addLayoutItem(legend)
            legend.attemptMove(QgsLayoutPoint(185, 50, QgsUnitTypes.LayoutMillimeters))
            legend.setLinkedMap(map)
            legend.setLegendFilterByMapEnabled(True)  # Abilita il filtro della legenda in base alla mappa corrente

            # Imposta l'etichetta "UNITA_DI_MISURA" come elemento della legenda
            unita_misura = layer.fields().lookupField("UNITA_DI_MISURA")
            if unita_misura >= 0:
                feature = next(layer.getFeatures())
                label_text = feature["UNITA_DI_MISURA"]
                legend.setTitle(label_text)  # Imposta "UNITA_DI_MISURA" come titolo della legenda


            # Aggiungi il layout al progetto
            QgsProject.instance().layoutManager().addLayout(layout)

    # Salva il progetto
    QgsProject.instance().write()
else:
    print(f"Gruppo '{group_name}' non trovato nel progetto.")


# Imposta il percorso di output per le immagini
output_path = "C:/Users/simon/OneDrive/Desktop/layout_stampa/"

# Itera attraverso tutti i layout di stampa nel progetto
for layout in QgsProject.instance().layoutManager().printLayouts():
    # Imposta il nome del file di immagine (usa il nome del layout con estensione .png)
    image_file = output_path + layout.name() + ".png"

    # Imposta le impostazioni di esportazione
    exporter = QgsLayoutExporter(layout)
    exporter.exportToImage(image_file, QgsLayoutExporter.ImageExportSettings())

    print(f"Layout '{layout.name()}' esportato come {image_file}")

print("Tutti i layout di stampa sono stati esportati come immagini.")

