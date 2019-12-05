####Setup####
# Install packages
pacman::p_load(polite, rvest, demeter, tidyr)

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







