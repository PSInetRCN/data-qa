# Stop here ####

dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "updated_by"] <-
  my_initials
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "updated_at"] <-
  as.character(Sys.time())
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "latest_status"] <-
  "NOT IMPORTED"
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "flag_summary"] <-
  "Need to revisit experimental design"

write.csv(dataset_tracking,
          here::here("dataset_tracking.csv"),
          row.names = F)
