# Install caret if you haven't: install.packages("caret")
library(caret)

# Load the built-in dataset
data(iris)

args <- commandArgs(trailingOnly = TRUE)
first_arg <- args[1]
second_arg <- args[2]

cat("First:", first_arg, "\n")
cat("Second:", second_arg, "\n")

# Create an index for the split
set.seed(123) # For reproducibility
trainIndex <- createDataPartition(iris$Species, p = 0.8, list = FALSE)

# Subset the data
train_data <- iris[trainIndex, ]
test_data  <- iris[-trainIndex, ]

# Train a Random Forest model
model <- train(Species ~ .,
               data = train_data,
               method = "rf")

# Make predictions
predictions <- predict(model, test_data)

# See how we did
confusionMatrix(predictions, test_data$Species)
