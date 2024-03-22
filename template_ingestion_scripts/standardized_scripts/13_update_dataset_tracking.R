
# Update dataset_tracking ####

dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "updated_by"] <-
  my_initials
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "updated_at"] <-
  as.character(Sys.time())
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "latest_status"] <-
  ifelse(any(!(outcomes_report$outcome), na.rm = T),
         "imported WITH FLAGS",
         "imported NO FLAGS")
dataset_tracking[which(dataset_tracking$dataset_name == dataset_identifier), "flag_summary"] <-
  flag_summary

write.csv(dataset_tracking,
          here::here("dataset_tracking.csv"),
          row.names = F)
