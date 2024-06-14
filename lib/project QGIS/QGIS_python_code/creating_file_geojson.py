import pandas as pd
import geopandas as gpd
import re
import shutil
import zipfile
import os


data = pd.read_csv("indici.csv")
indicatori = data['INDICATORE'].unique()

#AGGIUNGO LA REGIONE
data['REGIONE'] = data['NOME PROVINCIA (ISTAT)'].apply(lambda x: "Piemonte" if x in ["Biella","Verbano-Cusio-Ossola","Torino","Vercelli","Novara","Cuneo","Asti","Alessandria"] else "Campania" if x in ["Caserta","Benevento","Napoli","Avellino","Salerno"] else "Liguria" if x in ["Imperia","Savona","Genova","La Spezia"] else "Valle d'Aosta" if x in ["Valle d'Aosta"] else "Lombardia" if x in ["Lecco","Lodi","Monza e della Brianza","Varese","Como","Sondrio","Milano","Bergamo","Brescia","Pavia","Cremona","Mantova"] else "Trentino-Alto Adige" if x in ["Bolzano/Bozen","Trento"] else "Veneto" if x in ["Verona","Vicenza","Belluno","Treviso","Venezia","Padova","Rovigo"] else "Friuli Venezia Giulia" if x in ["Pordenone","Udine","Gorizia","Trieste"] else "Emilia-Romagna" if x in ["Rimini","Piacenza","Parma","Reggio nell'Emilia","Modena","Bologna","Ferrara","Ravenna","Forli-Cesena"] else "Marche" if x in ["Fermo","Pesaro e Urbino","Ancona","Macerata","Ascoli Piceno"] else "Toscana" if x in ["Prato","Massa-Carrara","Lucca","Pistoia","Firenze","Livorno","Pisa","Arezzo","Siena","Grosseto"] else "Umbria" if x in ["Perugia","Terni" ] else "Lazio" if x in ["Viterbo","Rieti","Roma","Latina","Frosinone"] else "Abruzzo" if x in ["L'Aquila","Teramo","Pescara","Chieti"] else "Molise" if x in ["Isernia","Campobasso" ] else "Puglia" if x in ["Barletta-Andria-Trani","Foggia","Bari","Taranto","Brindisi","Lecce"] else "Basilicata" if x in ["Potenza","Matera"] else "Calabria" if x in ["Vibo Valentia","Crotone","Cosenza","Catanzaro","Reggio Calabria"] else "Sicilia" if x in ["Trapani","Palermo","Messina","Agrigento","Caltanissetta","Enna","Catania","Ragusa","Siracusa"] else "Sardegna" if x in ["Sud Sardegna","Oristano","Sassari","Nuoro","Cagliari"] else 'Boh')

#RAGGRUPPO PER INDICATORE
gruppi= data.groupby('INDICATORE')
geojson_file = 'Regioni.geojson'
gdf = gpd.read_file(geojson_file)

# Rinomina la colonna "UNITA' DI MISURA" in una versione senza apici singoli
data.rename(columns={"UNITA' DI MISURA": "UNITA_DI_MISURA"}, inplace=True)
#print(data['UNITA_DI_MISURA'])

# Funzione per pulire il nome dell'indicatore e renderlo valido come nome di file
def clean_indicator_name(indicator_name):
    # Rimuovi caratteri non validi sostituendoli con un trattino basso
    cleaned_name = re.sub(r'[^a-zA-Z0-9_]', '_', indicator_name)
    return cleaned_name


# Definire una funzione per eseguire le operazioni per ciascun indicatore
def process_indicator(indicatore, cleaned_name):
    df = gruppi.get_group(indicatore)
    df = df.groupby('REGIONE')['VALORE'].mean().reset_index()  # Faccio la media dei valori di tutte le regioni
    df.rename(columns={'VALORE': f'MEDIA_VALORE_{cleaned_name}'}, inplace=True)  # Assegno il valore a MEDIA_VALORE

    # Aggiungi le colonne INDICATORE e UNITA' DI MISURA al DataFrame
    df['INDICATORE'] = indicatore
    df['UNITA_DI_MISURA'] = data.loc[data['INDICATORE'] == indicatore, 'UNITA_DI_MISURA'].iloc[0]  # Aggiungi UNITA_DI_MISURA

    gdf_indicatore = gdf.merge(df, left_on='DEN_REG', right_on='REGIONE', how='left') #etichetta regione

    # Creare un nome di file valido per il GeoJSON
    geojson_file_name = f'{cleaned_name}.geojson'

    # Salvare il GeoDataFrame in un file GeoJSON
    gdf_indicatore.to_file(geojson_file_name, driver='GeoJSON')

    # Scaricare il file GeoJSON
    # files.download(geojson_file_name)

    # Crea un link scaricabile per il file GeoJSON
    # display(FileLink(geojson_file_name))


# Iterare attraverso gli indicatori e applicare la funzione
for indicatore in indicatori:
    cleaned_indicator_name = clean_indicator_name(indicatore)
    process_indicator(indicatore, cleaned_indicator_name)