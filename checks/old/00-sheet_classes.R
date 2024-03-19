# Classes #### 

# Don't run, this is just me creating the expectations for sheet classes

sheet_classes <- list()

sheet_classes$sheet1 <- list(character = c(1:7, 12),
                             integer = 8:9,
                             numeric = 10:11)
sheet_classes$sheet2 <- list(character = c(1, 3:6, 9),
                             logical = 2,
                             numeric = 7:8) 
sheet_classes$sheet3 <- list(character = c(1,4:8),
                             logical = 2:3) 
sheet_classes$sheet4 <- list(character = c(1:3))
sheet_classes$sheet5 <- list(character= 1:12)
sheet_classes$sheet6 <- list(character = c(1, 3:8, 12),
                             integer = 2,
                             numeric = 9:11) 
sheet_classes$sheet7 <- list(character = c(1,2,5,6),
                             numeric = c(7,8),
                             integer = 9,
                             IDate = 3,
                             ITime = 4)
sheet_classes$sheet8 <- list(character = c(1,2,5,6),
                             numeric = c(7,8),
                             integer = 9,
                             IDate = 3,
                             ITime = 4)
sheet_classes$sheet9 <- list(character = c(1,2),
                             numeric = c(5,6,8,9,11,12, 14, 15),
                             integer = c(7,10,13,16),
                             IDate = 3,
                             ITime = 4)
sheet_classes$sheet10 <- list(IDate = 1,
                              ITime = 2,
                              numeric = c(3:10))

saveRDS(sheet_classes, here::here('checks', "expected_sheet_classes.Rds"))