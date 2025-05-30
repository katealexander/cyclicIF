#We want to put the registration stats on a bar graph, with one graph per replicate,
#where the bars are grouped by well and colored by cycle, with a little space in between each well.



# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)

# Set working directory
setwd("/Users/mir/Desktop")

# Load your CSV file
data <- read_csv("registration_results.csv")

# Convert to factors
data$Replicate <- as.factor(data$Replicate)
data$Well <- as.factor(data$Well)
data$Cycle <- as.factor(data$Cycle)

# Filter only Replicate 1
rep1_data <- data %>%
  filter(Replicate == "Rep1_20250129") %>%
  mutate(Cycle = gsub(".*cycle-(\\d+)\\.czi", "\\1", Cycle))  # Clean Cycle names

p= ggplot(rep1_data, aes(x = Well, y = RegistrationValue, fill = Cycle)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.6) +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  labs(title = "Registration Value by Well and Cycle (Replicate 1)",
       x = "Well",
       y = "Registration Value") +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  )

filename = "rep1_stats.pdf"
pdf(filename, width = 7, height = 5)
print(p)
dev.off()




# Install scico package if it's not already installed
if (!require(scico)) {
  install.packages("scico")
}

# Load the necessary libraries
# Install scico if not already installed
if (!require(scico)) {
  install.packages("scico")
}

# Load libraries
# Install scico if needed
if (!require(scico)) {
  install.packages("scico")
}

# Load libraries
library(ggplot2)
library(dplyr)
library(readr)
library(scico)

# Set working directory
setwd("/Users/mir/Desktop")

# Load CSV
data <- read_csv("registration_results.csv")

# Clean Cycle names first (handles e.g., 'cycle-02.czi')
data <- data %>%
  mutate(Cycle = gsub(".*cycle-(\\d+)\\.czi", "\\1", Cycle)) %>%
  filter(Cycle != "02")  # Remove all Cycle 02 entries

# Convert columns to factors (optional: sort by name)
data$Replicate <- as.factor(data$Replicate)
data$Well <- factor(data$Well, levels = sort(unique(data$Well)))
data$Cycle <- factor(data$Cycle, levels = sort(unique(data$Cycle)))

# Plot all replicates as faceted heatmaps
p <- ggplot(data, aes(x = Cycle, y = Well, fill = RegistrationValue)) +
  geom_tile(color = "white") +
  scale_fill_scico(palette = "lajolla", name = "Registration\nValue") +
  facet_wrap(~ Replicate) +
  theme_minimal() +
  labs(title = "Registration Heatmap",
       x = "Cycle", y = "Well") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom")

# Save as PDF
filename = "registration_heatmap_KD244a.pdf"
pdf(filename, width = 10, height = 6)
print(p)
dev.off()
