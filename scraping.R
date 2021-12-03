library(tidyverse)
library(rvest)
library(dplyr)
library(xml2)

url <- "https://be.indeed.com/jobs?q=%22project+Manager%22&l=Belgi%C3%AB&rbl=Gent&jlid=37bffe97fc19aea0&lang=en"
page <- xml2::read_html(url)

job_title = page %>% 
  html_nodes(".jobTitle") %>% 
  html_text()
  
company_name = page %>% 
  html_nodes(".companyName") %>% 
  html_text()

location = page %>% 
  html_nodes(".companyLocation") %>% 
  html_text()

links <- page %>% 
  html_nodes(".tapItem") %>% 
  html_attr("href")

job_description <- c()

for(i in seq_along(links)) {
  
  url <- paste0("https://be.indeed.com", links[i])
  page <- xml2::read_html(url)
  
  job_descripition[[i]] = page %>% 
    html_nodes(".jobsearch-JobComponent-description") %>% 
    html_text() %>% 
    stringi::stri_trim_both()
}

df = data.frame(location, company_name, job_title, job_descripition)


