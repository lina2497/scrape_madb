####Setup####
# Install packages
pacman::p_load(polite, rvest, demeter, tidyr, purrr, dplyr)

#Function for scraping madb.europa.eu 
mad_scraper<-function(session,country,hscode){
  df<-polite::scrape(session, query = list(countries=country,hscode=hscode))%>%
    rvest::html_node("#tarrifsTable")%>%
    rvest::html_table(fill = T)%>%
    tidyr::drop_na("Code")
  
  df <- df[!is.na(names(df))]
  
  return(df)
}

####Workflow####

# connect to proxy
# install demeter package from here: https://github.com/lina2497
demeter::proxy_connect()

#Target url
host<-"https://madb.europa.eu/madb/atDutyOverviewPubli.htm"

##Establish connection with site
session<-polite::bow(host)

#This website has not stated "don't scrape us"
#Therefore scraping is complient with ONS policy:
#https://www.ons.gov.uk/aboutus/transparencyandgovernance/lookingafterandusingdataforpublicbenefit/policies/policieswebscrapingpolicy

#Example for live sheep from GB
mad_scraper(session = session, country = "GB", hscode = "010410")


# for mutltiple countries

countries<-list("EG","GB")
output<-list()
for (i in seq_along(countries)) {
  output[[i]]<-(mad_scraper(session = session, country = countries[i], hscode = "01"))
  
}


map2_df(output, countries, ~mutate(.x,Code = as.character(Code),country = .y ))




