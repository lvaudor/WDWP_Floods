linkify=function(url,text="🔗"){
  linkify_one=function(url,text){
    url=stringr::str_replace(url,"^wd:", "https://www.wikidata.org/wiki/")
    result=glue::glue("<a href='{url}' target='_blank'>{text}</a>")
    return(result)
  }
  if(length(text)==1){text=rep(text,length(url))}
  result=purrr::map2_chr(url,text,linkify_one)
  return(result)
}
