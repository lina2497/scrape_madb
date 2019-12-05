x<-XML::htmlParse("countries.html")

country_codes<-xml2::read_html("countries.html")%>%html_node(".notNone")%>%
  html_children()

lookup<-tibble(Country=country_codes%>%html_text(),
       Code= country_codes%>%
         html_attr("value"))%>%
  filter(Country!="")


write.csv(lookup, file="Country_lookup.csv")
