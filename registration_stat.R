## Create a table that contains registration stats from each sample in each replicate  
##So that we can compare difference between cycles.The peak correlation should be >0.7.



# Set the working directory containing all replicate folders
setwd("~/CSHL Dropbox Team Dropbox/Sana Mir/AlexanderLab/labMemberFolders/MirSana/t-CyCIF/KD244a/")

replicate_folders <- list.dirs(getwd(), recursive = FALSE)

# Create an empty data frame to store results / values
registration_results <- data.frame(Replicate = character(),
                                  Well = character(),
                                  Cycle = character(),
                                  RegistrationValue = numeric(),
                                  stringsAsFactors = FALSE)

# Make a Loop through each replicate folder,Loop through inner folders (wells/samples),extract replicate and well names and registration stat from each folder
for (rep in replicate_folders) {
  replicate_name <- basename(rep)  # Extract replicate name
  
  # List well/sample folders inside the replicate
  well_folders <- list.dirs(rep, recursive = FALSE)
  
  for (well in well_folders) {
    well_name <- basename(well)
    
    # Define the path to the registration folder inside each well
    registration_folder <- file.path(well, "registration")
    
    # Check if the registration folder exists
    if (!dir.exists(registration_folder)) {
      warning(paste("Registration folder missing:", registration_folder))
      next  # Skip to the next well
    }
    
    # Locate registrationStats.csv inside the registration folder
    registration_file <- file.path(registration_folder, "registrationStats.csv")
    
    if (file.exists(registration_file)) {
      # Read the CSV file
      reg_data <- tryCatch({
        read.csv(registration_file, header = FALSE, row.names = 1)
      }, error = function(e) {
        warning(paste("Error reading", registration_file, ":", e$message))
        return(NULL)
      })
      
      # Check if data is not empty
      if (!is.null(reg_data) && nrow(reg_data) > 0) {
        cycle_numbers <- rownames(reg_data)  # Extract cycle numbers from row names
        registration_values <- reg_data[, 1]  # First column contains registration values
        
        # Create a temporary dataframe
        temp_results <- data.frame(
          Replicate = replicate_name,
          Well = well_name,
          Cycle = cycle_numbers,
          RegistrationValue = registration_values,
          stringsAsFactors = FALSE
        )
        
        # Append to the main results dataframe
        registration_results <- rbind(registration_results, temp_results)
      }
    } else {
      warning(paste("registrationStats.csv not found in:", registration_folder))
    }
  }
}

print(registration_results)

#Save results to a CSV or text file
write.csv(registration_results, file = "registration_results.csv", row.names = FALSE)


Heatmap 
library(tidyverse)
library(dplyr) # to manipulate data, install dplyr library
library(ggplot2)

# Combine replicate and well for easier plotting
registration_results$Sample <- paste(registration_results$Replicate, registration_results$Well, sep = "_")

# Optional: convert Cycle to a factor to maintain order
registration_results$Cycle <- factor(registration_results$Cycle, levels = unique(registration_results$Cycle))

# Create a heatmap plot using ggplot2
ggplot(registration_results, aes(x = Cycle, y = Sample, fill = RegistrationValue)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", mid = "yellow", high = "red", midpoint = 0.7,
                       name = "Registration\nValue") +
  theme_minimal() +
  labs(title = "Registration Values Heatmap",
       x = "Cycle", y = "Sample") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

