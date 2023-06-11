library(dplyr)
library(ggplot2)
library(mongolite)

# Connessione a MongoDB Atlas
mongo_conn <- mongo(url = "mongodb+srv://***:***@***/")

# Importazione dei datasets
qualita <- read.csv("/datasets/20201214_QDV2020_001.csv")
province <- read.csv("/datasets/Provincia.csv", sep = ";")

qualita$INDICATORE <- as.factor(qualita$INDICATORE)
qualita$UNITA_MISURA <- as.factor(qualita$UNITA_MISURA)
df <- province[, c(3, 6)]
colnames(qualita)[1] <- "DescrProvincia"
qualita <- merge(qualita, df, by.x = "DescrProvincia")
qualita$DescrRegione <- as.factor(qualita$DescrRegione)

#print(levels(qualita$INDICATORE))

# Specifica il percorso e il nome del file di output
output_file <- "../risultati.txt"
file_conn <- file(output_file, open = "w")  # Apre il file in modalità scrittura

indici <- levels(qualita$INDICATORE)
indici_ordinati <- indici[order(indici, decreasing = TRUE)]

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


for (ind in indici_ordinati) {
  unita <- as.character(unique(qualita$UNITA_MISURA[qualita$INDICATORE == ind]))

  risultati <- qualita %>%
    filter(INDICATORE == ind) %>%
    group_by(DescrRegione) %>%
    summarise(Totale = mean(VALORE)) %>%
    mutate(DescrRegione = reorder(DescrRegione, Totale))


  if(FALSE){
  #calcolo varie fasce
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
