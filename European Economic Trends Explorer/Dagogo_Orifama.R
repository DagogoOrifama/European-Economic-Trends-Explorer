# Install and load necessary packages
install.packages("tidyverse")
install.packages("corrplot")
install.packages("psych")
install.packages("outliers")
install.packages("dplyr")
install.packages("correlation")
install.packages("RVAideMemoire")
install.packages("rstatix")
install.packages("e1071")
install.packages("moments")
install.packages("forecast")
install.packages("ggplot2")


# Load libraries
library(tidyverse)
library(corrplot)
library(psych)
library(outliers)
library(dplyr)
library(correlation)
library(RVAideMemoire)
library(rstatix)
library(e1071)
library(moments)
library(forecast)
library(ggplot2)

# import dataset into a dataframe
economicDF <- read.csv("dataset.csv", header= TRUE)


# checking an overview of the data
head(economicDF)
names(economicDF)
tail(economicDF)
str(economicDF)

#check for missing values in the imported dataframe
sum(is.na(economicDF)) # No missing value in the dataset
summary(is.na(economicDF))

# Display the original column names
print(colnames(economicDF))

# Rename columns by index
colnames(economicDF)[1] <- "Country"
colnames(economicDF)[2] <- "CountryCode"
colnames(economicDF)[3] <- "Time"
colnames(economicDF)[4] <- "TimeCode"
colnames(economicDF)[5] <- "GDP"
colnames(economicDF)[6] <- "GDPGrowth"
colnames(economicDF)[7] <- "PopulationTotal"
colnames(economicDF)[8] <- "FDI"
colnames(economicDF)[9] <- "GNI"
colnames(economicDF)[10] <- "NetMigration"
colnames(economicDF)[11] <- "FertilityRate"

# Display the updated column names
print(colnames(economicDF))


# checking for outlier Using BoxPlot in the numeric data columns
# Function to set plot dimensions
set_plot_dim <- function(width, height) {
  # Set plot dimensions using options
  options(repr.plot.width = width, repr.plot.height = height)
}

# usage
set_plot_dim(20, 10)
par(mfrow = c(2, 3))

# Boxplots for different variables with updated column indices
variables <- c("GDP", "GDPGrowth", "PopulationTotal", "FDI", "GNI", "NetMigration", "FertilityRate")
colors <- "#FF6666"

# Check if variables exist in the dataframe
missing_variables <- setdiff(variables, colnames(economicDF))
if (length(missing_variables) > 0) {
  stop(paste("The following variables are missing in the dataframe:", paste(missing_variables, collapse = ", ")))
}

for (variable in variables) {
  boxplot(
    economicDF[[variable]],
    ylab = paste0(variable, " Boxplot"),
    main = paste0(variable, " Boxplot"),
    col = colors,
    outcol = colors
  )
}


# Checking outliers for 'GNI'
outliers_GNI <- boxplot.stats(economicDF$GNI)$out

# Checking outliers for 'FDI'
outliers_FDI <- boxplot.stats(economicDF$FDI)$out

# Checking outliers for 'FertilityRate'
outliers_FertilityRate <- boxplot.stats(economicDF$FertilityRate)$out

# Displaying the outlier values
print("Outliers in GNI:")
print(outliers_GNI)

print("Outliers in FDI:")
print(outliers_FDI)

print("Outliers in FertilityRate:")
print(outliers_FertilityRate)


#.............................Creating a Dataframe for each country using the countrycode 
# Create dataframes for each country
distinct_countries <- unique(economicDF$CountryCode)

country_dataframes <- lapply(distinct_countries, function(country) {
  subset(economicDF, CountryCode == country)
})

# Create new dataframe names for each country using the country code
new_dataframe_names <- paste(distinct_countries, "DF",  sep = "_")

# Assign dataframes to new names in the global environment
for (i in seq_along(new_dataframe_names)) {
  assign(new_dataframe_names[i], country_dataframes[[i]], envir = .GlobalEnv)
}

new_dataframe_names



#.....................................Statistical Analysis..............................................

# 1. Description Statistics Analysis accross all countries

# Specifying relevant columns for computation
economicDF_numeric <- economicDF[, c("GDP", "GDPGrowth", "PopulationTotal", "FDI", "GNI", "NetMigration", "FertilityRate")]

# Compute mean, median, mode, std, skewness, kurtosis, variance
mean_values_economicDF <- colMeans(economicDF_numeric, na.rm = TRUE)
median_values_economicDF <- sapply(economicDF_numeric, median, na.rm = TRUE)
mode_values_economicDF <- sapply(economicDF_numeric, function(x) { which.max(table(x)) })
std_dev_economicDF <- sapply(economicDF_numeric, sd, na.rm = TRUE)
skewness_values_economicDF <- sapply(economicDF_numeric, e1071::skewness)
kurtosis_values_economicDF <- sapply(economicDF_numeric, e1071::kurtosis)
variance_values_economicDF <- sapply(economicDF_numeric, var, na.rm = TRUE)

# Combine the results into a dataframe
economicDF_stats <- data.frame(
  Indicator = c("GDP", "GDPGrowth", "PopulationTotal", "FDI", "GNI", "NetMigration", "FertilityRate"),
  Mean = mean_values_economicDF,
  Median = median_values_economicDF,
  Mode = mode_values_economicDF,
  SD = std_dev_economicDF,
  Skewness = skewness_values_economicDF,
  Kurtosis = kurtosis_values_economicDF,
  Variance = variance_values_economicDF
)

# View the statistical Analysis result
print(economicDF_stats)



# 2. Description Statistics Analysis for each countries

# Create an empty dataframe to store the statistical Analysis results
descriptive_stats <- data.frame()

# Loop through each country and compute statistics
for (country in new_dataframe_names) {
  # Extract the country name from the dataframe name
  country_name <-  strsplit(country, "_")[[1]][1]
  
  # Select the current country dataframe
  country_data <- get(country)
  
  # Extract numeric columns for computation
  country_data_numeric <- country_data[, sapply(country_data, is.numeric)]
  
  # Compute mean, median, mode, std, skewness, kurtosis, variance
  mean_values <- colMeans(country_data_numeric, na.rm = TRUE)
  median_values <- sapply(country_data_numeric, median, na.rm = TRUE)
  mode_values <- sapply(country_data_numeric, function(x) { which.max(table(x)) })
  std_dev <- sapply(country_data_numeric, sd, na.rm = TRUE)
  skewness_values <- sapply(country_data_numeric, e1071::skewness)
  kurtosis_values <- sapply(country_data_numeric, e1071::kurtosis)
  variance_values <- sapply(country_data_numeric, var, na.rm = TRUE)
  
  # Combine the results into a dataframe
  country_stats <- data.frame(
    Country = country_name,
    Mean = mean_values,
    Median = median_values,
    Mode = mode_values,
    SD = std_dev,
    Skewness = skewness_values,
    Kurtosis = kurtosis_values,
    Variance = variance_values
  )
  
  # Append to the main dataframe
  descriptive_stats <- rbind(descriptive_stats, country_stats)
}
# View the statistical Analysis result
descriptive_stats


#3. comparing the indicator average across per countries
econ_compare <- economicDF %>%
  group_by(Country) %>%
  summarise(
    AverageGDP = mean(GDP, na.rm = TRUE),
    AverageGDPGrowth = mean(GDPGrowth, na.rm = TRUE),
    AveragePopulationTotal = mean(PopulationTotal, na.rm = TRUE),
    AverageFDI = mean(FDI, na.rm = TRUE),
    AverageGNI = mean(GNI, na.rm = TRUE),
    AverageNetMigration = mean(NetMigration, na.rm = TRUE),
    AverageFertilityRate = mean(FertilityRate, na.rm = TRUE)
  )

# View the resulting dataframe
print(econ_compare)


#....................................correlation Analysis......................................
# Set larger plot dimensions
options(repr.plot.width = 25, repr.plot.height = 20)

# Create a subset of the dataframe with numeric columns
numeric_data <- economicDF[, sapply(economicDF, is.numeric)]

# Compute the correlation matrix
correlation_matrix <- cor(numeric_data, use = "pairwise.complete.obs")

# Create a custom color palette
my_color_palette <- colorRampPalette(c("darkblue", "white", "darkred"))(100)

# Print the correlation matrix
print(correlation_matrix)

# Create a heatmap for better visualization
library(corrplot)
corrplot(correlation_matrix, method = "color", type = "upper", addCoef.col = "black", 
         tl.col = "black", col = my_color_palette, tl.srt = 45)




#.............................................Hypothesis Testing.................................................

# Null Hypothesis (H0): There is no significant relationship between GDP and FDI.
# Alternative Hypothesis (H1): There is a significant relationship between GDP  and FDI.



# Compute the correlation coefficient and test the correlation
cor_test_result <- cor.test(numeric_data$GDP, numeric_data$FDI, method = "pearson")

# Print the correlation test result
print(cor_test_result)



#Hypothesis 2:
# Null Hypothesis (H0): There is no significant difference in the average Fertility Rate between high-GDP and low-GDP countries.
# Alternative Hypothesis (H1): There is a significant difference in the average Fertility Rate between high-GDP and low-GDP countries.


#  t-test
high_gdp_group <- economicDF$FertilityRate[economicDF$GDP > median(economicDF$GDP)]
low_gdp_group <- economicDF$FertilityRate[economicDF$GDP <= median(economicDF$GDP)]

t_test_result <- t.test(high_gdp_group, low_gdp_group)
print(t_test_result)





#............................................Regression Analysis...............................................#

# objective 1: To examine the possible linear relation between GDP and PopulationTotal

# Create a subset of the dataframe with relevant columns
subset_data <- economicDF[, c("GDP", "PopulationTotal", "NetMigration", "FDI")]

# Fit a simple linear regression model
reg_model <- lm(GDP ~ PopulationTotal, data = subset_data)

# Check the assumptions

# 1. Linearity between X and Y
plot(subset_data$GDP, subset_data$PopulationTotal, main = "Scatterplot of GDP vs PopulationTotal",
     xlab = "GDP", ylab = "PopulationTotal")
abline(reg_model, col = "red")

# 2. Residuals’ Independence
plot(residuals(reg_model) ~ subset_data$GDP, main = "Residuals vs GDP",
     xlab = "GDP", ylab = "Residuals")

# 3. Normality of residuals
qqnorm(residuals(reg_model), main = "Normal Q-Q Plot of Residuals")

# 4. Equal variances of the residuals (Homoscedasticity)
plot(fitted(reg_model), residuals(reg_model), main = "Residuals vs Fitted",
     xlab = "Fitted values", ylab = "Residuals")
abline(h = 0, col = "red")

# Summary of the regression model
summary(reg_model)





# objective 2: To examine the possible linear relation between GDP and NetMigration

# Fit the regression model
regression_model <- lm(GDP ~ NetMigration, data = subset_data)

# Visualize the assumptions
par(mfrow = c(2, 2))

# 1. Linearity between X and Y
plot(subset_data$GDP, subset_data$NetMigration, main = "Linearity Check", xlab = "GDP", ylab = "NetMigration")
abline(regression_model, col = "red")

# 2. Residuals' Independence
plot(regression_model$residuals, main = "Residuals' Independence", ylab = "Residuals")

# 3. Normality of Residuals
qqnorm(regression_model$residuals, main = "Normality of Residuals")
qqline(regression_model$residuals, col = "red")

#examine a histogram of the residuals
#hist(regression_model$residuals, 2) # from lab

# 4. Equal Variances of Residuals (Homoscedasticity)
plot(predict(regression_model), regression_model$residuals, main = "Homoscedasticity Check", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red")

# Reset the plot layout
par(mfrow = c(1, 1))

# Obtain summary of the regression model
summary(regression_model)


#'.............................................Multiple Linear Regression (MLR)..........................

# objective 3: To examine the possible linear relation between DV=> GDP and IV=> PopulationTotal, NetMigration


# Fit the multiple regression model with GDP as the dependent variable
multiple_regression_model <- lm(GDP ~ NetMigration + PopulationTotal, data = subset_data)

# Visualize the assumptions
par(mfrow = c(2, 2))

# 1. Linearity between Xs and Y
plot(subset_data$NetMigration, subset_data$GDP, main = "Linearity Check (NetMigration)", xlab = "NetMigration", ylab = "GDP")
abline(multiple_regression_model, col = "red")

plot(subset_data$PopulationTotal, subset_data$GDP, main = "Linearity Check (PopulationTotal)", xlab = "PopulationTotal", ylab = "GDP")
abline(multiple_regression_model, col = "red")

# 2. Residuals' Independence
plot(multiple_regression_model$residuals, main = "Residuals' Independence", ylab = "Residuals")

# 3. Normality of Residuals
qqnorm(multiple_regression_model$residuals, main = "Normality of Residuals")
qqline(multiple_regression_model$residuals, col = "red")

# 4. Equal Variances of Residuals (Homoscedasticity)
plot(predict(multiple_regression_model), multiple_regression_model$residuals, main = "Homoscedasticity Check", 
     xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red")

# Reset the plot layout
par(mfrow = c(1, 1))

# Check for multicollinearity
vif_values <- car::vif(multiple_regression_model)
print("VIF Values:")
print(vif_values)

# Summary of the multiple regression model
summary(multiple_regression_model)


# objective 4: To examine the possible linear relation between DV=> GDP and IV=> PopulationTotal, NetMigration, FDI

# Fit the multiple regression model with GDP as the dependent variable
multiple_regression_model2 <- lm(GDP ~ NetMigration + PopulationTotal + FDI, data = subset_data)

# Visualize the assumptions
par(mfrow = c(2, 2))

# 1. Linearity between Xs and Y
plot(subset_data$NetMigration, subset_data$GDP, main = "Linearity Check (NetMigration)", xlab = "NetMigration", ylab = "GDP")
abline(multiple_regression_model2, col = "red")

plot(subset_data$PopulationTotal, subset_data$GDP, main = "Linearity Check (PopulationTotal)", xlab = "PopulationTotal", ylab = "GDP")
abline(multiple_regression_model2, col = "red")

plot(subset_data$FDI, subset_data$GDP, main = "Linearity Check (FDI)", xlab = "FDI", ylab = "GDP")
abline(multiple_regression_model2, col = "red")

# 2. Residuals' Independence
plot(multiple_regression_model2$residuals, main = "Residuals' Independence", ylab = "Residuals")

# 3. Normality of Residuals
qqnorm(multiple_regression_model2$residuals, main = "Normality of Residuals")
qqline(multiple_regression_model2$residuals, col = "red")

# 4. Equal Variances of Residuals (Homoscedasticity)
plot(predict(multiple_regression_model2), multiple_regression_model2$residuals, main = "Homoscedasticity Check", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red")

# Reset the plot layout
par(mfrow = c(1, 1))

# Check for multicollinearity
vif_values <- car::vif(multiple_regression_model2)
print("VIF Values:")
print(vif_values)

# Summary of the multiple regression model
summary(multiple_regression_model2)


#................................................Time series analysis........................................
# Create a time series object for GDP
ts_data <- ts(economicDF$GDP, start = start(economicDF$Time), frequency = 1)

# Display the time series data
print(ts_data)

# Plot the time series
autoplot(ts_data) + labs(title = "Time Series Plot of GDP")

# Fit an ARIMA model
arima_model <- auto.arima(ts_data)
summary(arima_model)

# Forecast future values h=5 to predict for 5years
forecast_values <- forecast(arima_model, h = 5)  
autoplot(forecast_values) + labs(title = "GDP Forecast")

# Print point forecast
forecast_values_germany

# Evaluate the residuals
checkresiduals(arima_model)


#.............................................Time Series for Germany on GDP................................
# Filter data for Germany
ts_data_germany <- economicDF$GDP[economicDF$Country == "Germany"]
ts_data_germany <- ts(ts_data_germany, start = min(economicDF$Time), frequency = 1)

# Time series plot
plot(ts_data_germany, main = "Time Series Plot of GDP (Germany)", xlab = "Year", ylab = "GDP")

# Fit an ARIMA model
model_germany <- auto.arima(ts_data_germany)
summary(model_germany)

# Forecast future values h=5 to predict for 5years
forecast_values_germany <- forecast(model_germany, h = 5)  
plot(forecast_values_germany, main = "GDP Forecast (Germany)", xlab = "Year", ylab = "GDP")

# Print point forecast
forecast_values_germany

# Evaluate the residuals
checkresiduals(forecast_values_germany)
