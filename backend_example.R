# LOAD DATA 
# IT SHOULD BE ALREADY PREPROCESSED TO REDUCE THE TIME

library(dplyr)
library(tidyr)
library(lsa)

# Загрузка Данных
data = read.csv("/students/bulygind/friends_groups.csv")[,-1]
data$count = 1
data = spread(data,user_id,count,fill=0)

# если не делать фильтр, то оно очень долго считается, поэтому лучше отфильтровать
data1 = filter(data, rowSums(data[,-1]) > 13)

group_names <- as.character(data1[,1])
rownames(data1) <- data1[,1]
data1 <- data1[,-1]

cos_stud <- cosine(as.matrix(t(data1)))
cos_stud <- as.data.frame(cos_stud)
cos_stud$group <- group_names
cos_stud <- gather(cos_stud, group2,rel,1:121)
#загрузка с данными
users <- read.csv("/students/bulygind/friends_groups.csv")[,-1]

# он сделал косинусное расстояние по группам моих друзей

# In the next section you define functions of you API

# NB! comments starting with #* are part of plumber markup
# They consist of a request type: "@get" or "@post"
# and a path (part of URL), starting with "/"
# After the comment goest the function which is called
# when somebody sends a request to server to the given path

#* @get /test
i_am_working <- function(){
  list(status="I am working")
  # This will return JSON: {"status": ["I am working"]}
  # NB! The value is JSON is always an array, not a scalar!
}

# Try PORT.piterdata.ninja/test to test (PORT SHOULD BE SPECIFIED)

#* @post /recommend_group
find_best_group <- function(uid){
  # Expect incoming JSON with "uid" field in it
  # Find a group for this user
  
  user <- filter(users, user_id==uid)
  df <- filter(cos_stud, group %in% user$group_id)
  df <- filter(df, !(group2 %in% user$group_id))
  suggestions <- arrange(df, desc(rel)) %>% head(3)
  
  group_id <- suggestions$group2
  
  # GET LIST OF GROUP NAMES FROM VK API
  # WE CAN DO IT FROM THE LOADED DATA ALSO
  group_names <- lapply(group_id, function(x) {vkR::getGroupsById(x)$name})
  
  group_names <- unlist(group_names)
  
  group_data <- list(group_names=group_names)
  
  list(group_data)
}
