data {
  int<lower=0> N;           // Number of observations
  int<lower=0> K;           // Number of predictors
  matrix[N, K] X;           // Predictor matrix
  vector[N] y;              // Response variable
}

parameters {
  vector[K] beta;           // Regression coefficients
  real alpha;               // Intercept
  real<lower=0> sigma;      // Standard deviation
}

model {
  // Priors
  beta ~ normal(0, 10);     // Normal priors for coefficients
  alpha ~ normal(0, 10);    // Normal prior for the intercept
  sigma ~ cauchy(0, 2);     // Cauchy prior for sigma
  
  // Likelihood
  y ~ normal(X * beta + alpha, sigma);  // Regression model
}


