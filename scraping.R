library(tidyverse)
library(rvest)
library(dplyr)
library(xml2)
webshot::install_phantomjs()

page_result_start <- 10 # starting page 
page_result_end <- 100 # last page results
page_results <- seq(from = page_result_start, to = page_result_end, by = 10)

full_df <- data.frame()

for(i in seq_along(page_results)) {
  
  first_page_url <- "https://be.indeed.com/jobs?q=%22project+Manager%22&l=Belgi%C3%AB&lang=en"
  url <- paste0(first_page_url, "&start=", page_results[i])
  page <- xml2::read_html(url)
  
  # Sys.sleep pauses R for two seconds before it resumes
  # Putting it there avoids error messages such as "Error in open.connection(con, "rb") : Timeout was reached"
  Sys.sleep(2)
 
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
  
  links
  job_description <- c()
  
  for(i in seq_along(links)) {
    
    url <- paste0("https://be.indeed.com", links[i])
    page <- xml2::read_html(url)
    
    job_description[i] = page %>% 
      html_nodes(".jobsearch-JobComponent-description") %>% 
      html_text() %>% 
      stringi::stri_trim_both()
  }
  df = data.frame(location, company_name, job_title,  )
  full_df <- rbind(full_df, df)
}

View(full_df)

write.csv(full_df,".\\full_df.csv", row.names = FALSE)
