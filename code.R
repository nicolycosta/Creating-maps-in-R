install.packages('raster')
install.packages('shapefile') #open file shp
install.packages('tmap') #map
library(tmap)
library(sp)
library(raster)
library(readxl) #open xlsx file

# loading the file
# the file was downloaded from the website: http://www.ipea.gov.br/ipeageo/malhas.html
# On the aforementioned site, the archive of the state of Pará was uploaded
MAPARS =shapefile("PA_Mun97_region.shp")
head(MAPARS@data)


#Next, the plot() function can be used to plot the loaded map:
plot(MAPARS)

# Merging the "arr" database with "MAPARS" by the name of the municipality

arr = read_excel('Arrecadação de ICMS no Pará.xlsx')
MAPA =merge(MAPARS,arr,by="SEM_ACENTO") 
head(MAPA@data)



############## turning NA into 0 ##############
i= 1
for (j in MAPA$'2022') {
  if (is.na(MAPA$'2022')[i] != 'TRUE'){
    MAPA$'2022'[i] <- MAPA$'2022'[i]
  } else{ 
    MAPA$'2022'[i] <- 0}
  i <- i+1
}


############## choosing chart scale ################
#creating mylist with values other than 0, for choosing the numeric scale.
mylist <- c()
i= 1
for (j in MAPA$'2022') {
  if (MAPA$'2022'[i] != 0){
    mylist <- c(mylist, MAPA$'2022'[i])
  }
  else{}
  i <- i+1
}
#determining the scales through the boxplot
boxplot(mylist, outline=FALSE)
quantile(mylist, probs = 0.25)
quantile(mylist, probs = 0.50)
quantile(mylist, probs = 0.70)


tm_shape(MAPA)+ 
  tm_fill("2022", title="Collection in Millions of ICMS in Pará, 2021",
          breaks=c(0.,quantile(mylist, probs = 0.25),
                   quantile(mylist, probs = 0.50),
                   quantile(mylist, probs = 0.65),
                   quantile(mylist, probs = 0.80),
                   quantile(mylist, probs = 0.95),
                   max(MAPA$'2022')), 
          legend.format = list(),  
          legend.show= TRUE,
          legend.is.portrait = TRUE,
          legend.hist = FALSE,
          alfa= 9) +
  tm_compass(type="arrow", position=c("right", "top"), show.labels = 1, size = 1)+
  tm_borders()+ 
  tm_basemap(server="OpenStreetMap",alpha=0.5) +
  tm_legend(legend.outside = FALSE, legend.outside.position="right")+
  tm_logo("LOGO.png", height = 2, position = 'LEFT' )

################################### População vs PIB #########################################

pibxpop = read_excel('C:/Users/sedap/Documents/Cacau Nicoly/Projeto Cacau- projeto 2/Criação de mapa/Mapa Git/PIB-POPULAÇÃO.xlsx')
data.frame(pibxpop)

MAPA3 =merge(MAPARS,pibxpop,by="SEM_ACENTO") 
print(data.frame(MAPA3))


tm_shape(MAPA3) +
  tm_polygons(c("PIB", "POPULACAO"), 
              style=c("kmeans","fixed"),
              palette=list("Reds", "Blues"),
              auto.palette.mapping=FALSE,
              breaks=list(quantile(MAPA3$POPULACAO),
                          c(-Inf,100000,200000,Inf)),
              title=c("PIB", "População")) +
  #tm_format_World() + 
  #tm_style_grey()+
  tm_compass()+
  tm_scale_bar()+
  tm_legend(legend.format = list(text.separator= "a"))+
  tm_layout(legend.position = c("LEFT","BOTTOM"),
            legend.frame = FALSE, 
            title = c("PIB a preços correntes (Mil Reais), 2020"," População residente estimada, 2020"))+
  tm_logo("LOGO.png", height = 2, position = c("RIGHT", "TOP"))

################################### PIB Brasil ############################################

MAPARSBR =shapefile("BR_UF_2022/BR_UF_2022.shp")
head(MAPARSBR@data)

pib = read_excel('pib-brasil.xlsx')
MAPA =merge(MAPARSBR,pib,by="NM_UF") 
MAPA@data


tm_shape(MAPA) +
  tm_polygons("PIB", title="PIB (1.000.000 R$)", 
              style="kmeans", text="Label_N", palette="Blues") +
  tm_text("SIGLA_UF", scale=0.55)+
  tm_layout(main.title = "PIB dos Estados do Brasil, em 2020.",
            main.title.position = 'center')+
  tm_legend(legend.format = list(text.separator= "a"))





