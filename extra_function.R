
stem_hunspell <- function(term) {
  # look up the term in the dictionary
  stems <- hunspell_stem(term)[[1]]
  
  if (length(stems) == 0) { # if there are no stems, use the original term
    stem <- term
  } else { # if there are multiple stems, use the last one
    stem <- stems[[length(stems)]]
  }
  return(stem)
}


topic_cloud <- function(lda, n){
  
  word_topic <- GetTopTerms(lda$phi, n) %>% 
    as.data.frame() %>% 
    setNames( 
      paste("Topic", 1:(length(.)) )
    )
  
  word_topic %>% 
    mutate(id = rownames(.),
           id = as.numeric(id)) %>% 
    pivot_longer(-id, names_to = "topic", values_to = "term") %>% 
    mutate(topic = factor(topic, levels = paste("Topic", 1:(length(word_topic)) ))) %>% 
    ggplot(aes(label = term, size = rev(id), color = topic, alpha = rev(id))) +
    geom_text_wordcloud(seed = 123) +
    facet_wrap(~topic, scales = "free", ncol = 4) +
    scale_alpha_continuous(range = c(0.4, 1)) +
    theme_void()
  
}


get_top_news <- function(lda, topic, data){
  
  doc_topic <- lda$theta %>% 
    as.data.frame() %>% 
    mutate(document_id = rownames(.)) 
  
  doc_topic %>% 
    arrange(
      desc( doc_topic[, paste0("t_", topic)] )
      ) %>% 
    left_join(data) %>% 
    select(-document_id) 
}
