library(tidyverse)
library(rstan) 
library(broom)  
library(dplyr) 

# Load the dataset
data<- read.csv("bodyfat.csv")
head(data)

# Check for Multicollinearity 
cor(data, use = "complete.obs")

# Select columns for analysis
bodyfat <- data[c("Weight", "Height", "Age", "BodyFat")]

# Remove any missing values from the data 
bodyfat <- na.omit(bodyfat)

# OLS Regression model
lm_model <- lm(BodyFat ~., bodyfat)

# Results of OLS Regression
summary(lm_model)

# Residual plot to check for homoscedasticity
residual_plot <- ggplot(lm_model, aes(x = .fitted, y = .resid)) +
  geom_point() +
  labs(
    title = "Residual Plot",
    x = "Fitted Values",
    y = "Residuals"
  )

# Bayesian Model using Stan
stan_data <- list(
  N = nrow(bodyfat),
  K = ncol(bodyfat) - 1,  
  X = as.matrix(bodyfat[, -4]),  
  y = bodyfat$BodyFat  
)

stan_model <- rstan::stan(
  file = "bayesian_regression.stan",
  data = stan_data,
  iter = 2000,  
  chains = 1 
)

# Summarize the Stan model results
print(stan_model)

# Extract results
samples <- rstan::extract(stan_model)

# Trace plot for intercept
plot(
  samples$beta[1:100, 1],  
  xlab = "MCMC Iteration",  
  ylab = "Intercept for Weight",  
  type = "o", 
  col = rgb(red = 0, green = 0, blue = 1, alpha = 0.5)  
)

# Histogram plot for intercept
hist_height <- hist(samples$beta[, 1], xlab = "Intercept for Height")
