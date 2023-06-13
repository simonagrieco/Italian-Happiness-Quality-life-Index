library(dplyr)
library(ggplot2)
library(mongolite)


# Connessione a MongoDB Atlas
mongo_conn <- mongo(url = "mongodb+srv://sgrieco13:37B6MJgVg65dASHk@cluster0.web9clt.mongodb.net/")


# Importazione dei datasets
qualita <- read.csv("C:/Users/simon/OneDrive/Documenti/Python/italian_happiness_index_py/datasets/20201214_QDV2020_001.csv")
province <- read.csv("C:/Users/simon/OneDrive/Documenti/Python/italian_happiness_index_py/datasets/Provincia.csv", sep = ";")

qualita$INDICATORE <- as.factor(qualita$INDICATORE)
qualita$UNITA_MISURA <- as.factor(qualita$UNITA_MISURA)
df <- province[, c(3, 6)]
colnames(qualita)[1] <- "DescrProvincia"
qualita <- merge(qualita, df, by.x = "DescrProvincia")
qualita$DescrRegione <- as.factor(qualita$DescrRegione)




# Specifica il percorso e il nome del file di output
output_file <- "C:/Users/simon/OneDrive/Documenti/Python/italian_happiness_index_py/datasets/risultati.txt"
file_conn <- file(output_file, open = "w")  # Apre il file in modalità scrittura


indici <- levels(qualita$INDICATORE)
indici_ordinati <- indici[order(indici, decreasing = TRUE)] #ordinamento degli indici in modo decrescente



# Creazione del vettore di indicatori positivi
indicatori_positivi <- c("Tasso di natalita'", "Assegni sociali", "Assorbimento del settore residenziale",
  "Banda larga", "Bar","Biblioteche","Cie erogate","Cinema","Depositi bancari",
  "Diffusione del reddito di cittadinanza","Eventi sportivi","Fondi europei 2014-2020 per l'Agenda digitale",
  "Fondi europei 2014-2020 per l'ambiente e la prevenzione dei rischi","Fondi europei 2014-2020 per l'attrazione culturale, naturale e turistica",
  "Imprenditorialita' giovanile","Il trend del Pil pro capite","Imprese che fanno ecommerce",
  "Imprese femminili","Imprese in rete","Imprese straniere","Indice di lettura dei quotidiani","Indice trasormazione digitale",
  "Infermieri","Internet ≥ 100 Mbit/s - abbonamenti","Iscrizioni anagrafiche","Librerie","Medici di medicina generale",
  "Nuove iscrizioni di imprese","Nuovi mutui per l'acquisto di abitazioni","Offerta culturale","Pago Pa - enti attivi",
  "Palestre ogni 100mila abitanti","Partecipazione alla formazione continua","Partecipazione elettorale","Pediatri",
  "Pensioni di vecchiaia (settore privato)","Persone con almeno il diploma","Piscine","Popolazione con crediti attivi","Pos attivi",
  "Reddito disponibile","Riqualificazioni energetiche degli immobili","Ristoranti","Spazio abitativo medio","Spettacoli - Spesa al botteghino",
  "Sportivita' 2020 - \"effetto Covid-19\"","Startup innovative","Tasso di occupazione","Spesa sociale degli enti locali",
  "Quota di export sul Pil","Ecosistema urbano","Spid erogate"
  )



#Divisione in categorie
macroCategorie <- list(
  'Sicurezza' = vector(),
  'Ambiente' = vector(),
  'Salute' = vector(),
  'Istruzione e cultura' = vector(),
  'Lavoro, guadagni e ricchezza' = vector(),
  'Politica, diritti e cittadinanza' = vector(),
  'Societa\' e comunita\'' = vector(),
  'Benessere percepito' = vector(),
  'Altro' = vector()
)

#Divisione degli indici nelle rispettive macrocategorie
for (ind in indici_ordinati) {
  if (grepl("Furti", ind) ||
      grepl("Estorsioni", ind) ||
      grepl("Truff", ind) ||
      grepl("criminal", ind) ||
      grepl("Omicidi", ind) ||
      grepl("cause", ind) ||
      grepl("Incidenti", ind) ||
      grepl("Incendi", ind) ||
      grepl("litig", ind) ||
      grepl("Violenz", ind)) {
    macroCategorie$Sicurezza <- c(macroCategorie$Sicurezza, ind)
  } else if (grepl("Ambiente", ind) ||
             grepl("Climatico", ind) ||
             grepl("Ecosistema", ind) ||
             grepl("Riqualificazioni", ind) ||
             grepl("Riciclaggio", ind) ||
             grepl("motorizzazione", ind) ||
             grepl("Energetico", ind)) {
    macroCategorie$Ambiente <- c(macroCategorie$Ambiente, ind)
  } else if (grepl("Farmaco", ind) ||
             grepl("Salute", ind) ||
             grepl("Consumo", ind) ||
             grepl("Calmanti", ind) ||
             grepl("Mortalit", ind) ||
             grepl("Pediatri", ind) ||
             grepl("Medici", ind) ||
             grepl("vecchiaia", ind) ||
             grepl("Covid", ind) ||
             grepl("Infermieri", ind) ||
             grepl("morta", ind) ||
             grepl("Violenza sessuale", ind)) {
    macroCategorie$Salute <- c(macroCategorie$Salute, ind)
  } else if (grepl("Istruzione", ind) ||
             grepl("ultura", ind) ||
             grepl("Biblioteca", ind) ||
             grepl("diploma", ind) ||
             grepl("lettura", ind) ||
             grepl("Teatro", ind)) {
    macroCategorie$`Istruzione e cultura` <- c(macroCategorie$`Istruzione e cultura`, ind)
  } else if (grepl("Imprese", ind) ||
             grepl("imprese", ind) ||
             grepl("Cig", ind) ||
             grepl("Reddito", ind) ||
             grepl("Giovani", ind) ||
             grepl("Fatture", ind) ||
             grepl("Imprenditorialita'", ind) ||
             grepl("Pil", ind) ||
             grepl("Assegni", ind) ||
             grepl("crediti", ind) ||
             grepl("occupazione", ind) ||
             grepl("Soldi", ind) ||
             grepl("Spesa", ind) ||
             grepl("Prezzo", ind) ||
             grepl("Fondi", ind) ||
             grepl("banca", ind) ||
             grepl("Startup", ind) ||
             grepl("Pos", ind) ||
             grepl("Imprese", ind) ||
             grepl("reddito", ind) ||
             grepl("mutui", ind) ||
             grepl("Gap", ind) ||
             grepl("Pago", ind) ||
             grepl("Economia", ind)) {
    macroCategorie$`Lavoro, guadagni e ricchezza` <- c(macroCategorie$`Lavoro, guadagni e ricchezza`, ind)
  } else if (grepl("Politica", ind) ||
             grepl("Diritti", ind) ||
             grepl("Densita'", ind) ||
             grepl("Partecipazione", ind) ||
             grepl("Reddito", ind) ||
             grepl("Cittadinanza", ind)) {
    macroCategorie$`Politica, diritti e cittadinanza` <- c(macroCategorie$`Politica, diritti e cittadinanza`, ind)
  } else if (grepl("Societa'", ind) ||
             grepl("Comunita'", ind) ||
             grepl("Event", ind) ||
             grepl("Spid", ind) ||
             grepl("natalit", ind) ||
             grepl("Cie", ind) ||
             grepl("Associazione", ind)) {
    macroCategorie$`Societa' e comunita'` <- c(macroCategorie$`Societa' e comunita'`, ind)
  } else if (grepl("Benessere", ind) ||
             grepl("Spesa famiglie", ind) ||
             grepl("Banda", ind) ||
             grepl("Assorbimento", ind) ||
             grepl("Locazione", ind) ||
             grepl("Canoni", ind) ||
             grepl("Cinema", ind) ||
             grepl("Bar", ind) ||
             grepl("Biblioteche", ind) ||
             grepl("Piscine", ind) ||
             grepl("Librerie", ind) ||
             grepl("Ristoranti", ind) ||
             grepl("Internet", ind) ||
             grepl("bitativo", ind) ||
             grepl("Palestre", ind) ||
             grepl("Rata", ind) ||
             grepl("digitale", ind) ||
             grepl("Partecipazione elettorale", ind)) {
    macroCategorie$`Benessere percepito` <- c(macroCategorie$`Benessere percepito`, ind)
  } else {
    macroCategorie$Altro <- c(macroCategorie$Altro, ind)
  }
}

print(macroCategorie)


for (ind in indici_ordinati) {
  unita <- as.character(unique(qualita$UNITA_MISURA[qualita$INDICATORE == ind]))

  risultati <- qualita %>%
    filter(INDICATORE == ind) %>%
    group_by(DescrRegione) %>%
    summarise(Totale = mean(VALORE)) %>%
    mutate(DescrRegione = reorder(DescrRegione, Totale))


  #calcolo fasce (versione 2)
  risultati <- risultati %>%
    mutate(Fascia = ntile(Totale, 3))

  # Aggiunta del nome dell'indicatore accanto a ogni riga
  Indicatore <- rep(ind, nrow(risultati))
  risultati <- cbind(Indicatore, risultati)

 # Aggiunta della colonna "Esito"
  if (any(grepl(paste(trimws(ind), collapse = "|"), trimws(indicatori_positivi), ignore.case = TRUE))) {
    risultati$Esito <- "Positivo"
  } else {
    risultati$Esito <- "Negativo"
  }


  # Aggiunta della colonna "Macrocategoria"
  risultati$Macrocategoria <- sapply(ind, function(x) {
    for (categoria in names(macroCategorie)) {
      if (x %in% macroCategorie[[categoria]]) {
        return(categoria)
      }
    }
    return("Nessuna categoria")
  })

  # Inserimenti dei dati nel file
  #cat(paste("Indicatore:", ind), file = file_conn, append = TRUE)
  cat("\n", file = file_conn, append = TRUE)
  write.table(risultati[order(-risultati$Totale), ], file = file_conn, append = TRUE, row.names = FALSE)
  cat("\n\n", file = file_conn, append = TRUE)

  # Inserisci i dati in MongoDB Atlas
  mongo_conn$insert(risultati)
}

print("Fatto!")


# Chiude il file di output
close(file_conn)

# Inserisci i dati in MongoDB Atlas
mongo_conn$insert(risultati)







#per la  visualizzazione dei plot
if(FALSE) {

  colore<-2
  suppressMessages(
    for (ind in levels(qualita$INDICATORE)) {
      unita <-as.character(unique(qualita$UNITA_MISURA[qualita$INDICATORE==ind]))
      g<-qualita %>%
      filter(INDICATORE==ind) %>%
      group_by(DescrRegione) %>%
      summarise(Totale=mean(VALORE)) %>%
      mutate(DescrRegione=reorder(DescrRegione,Totale))  %>%
      ggplot(aes(DescrRegione,Totale))+
      geom_bar(stat="identity", fill=colore, colour="white")+
      coord_flip()+
      geom_text(aes(label=round(Totale,2)), hjust=0, size=2)+
      guides(fill=FALSE)+
      ylab(unita) +
      xlab("Regione") +
      ggtitle(ind)
      print(g)
      colore <- colore +1
    }
  )
}
 #calcolo varie fasce
if(FALSE){

  max_val <- max(risultati$Totale)
  min_val <- min(risultati$Totale)

  fascia1 <- (max_val - min_val) / 3 + min_val
  fascia2 <- (max_val - min_val) * 2 / 3 + min_val

  risultati <- risultati %>%
    mutate(Fascia = case_when(
      Totale <= fascia1 ~ "Fascia 1",
      Totale <= fascia2 ~ "Fascia 2",
      TRUE ~ "Fascia 3"
    )
   )
}
