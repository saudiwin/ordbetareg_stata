clear all
set more off
set seed 12345

*------------------------------------------------
* Step 1: Generate a dataset for ordered beta regression
*------------------------------------------------

* Number of observations
local N = 1000

* Set up simulation parameters
local beta_0 = 0.5     // Intercept
local beta_1 = 1.0     // Coefficient for X
local phi_true = 2.0   // True phi parameter for beta distribution
local cut1_true = -1   // True cutpoint 1
local cut2_true = 1    // True cutpoint 2

* Simulate covariate X
set obs `N'
gen double X = rnormal()

* Step 2: Calculate linear predictor and mu (logistic transformation of linear predictor)
gen double eta = `beta_0' + `beta_1' * X
gen double mu = invlogit(eta)  // Transform to get mu between 0 and 1

* Step 3: Generate random uniform variable to assign 0, 1, or proportion
gen double rand = runiform()

* Step 4: Assign outcome based on probabilities (0, proportion, 1)
gen double outcome = .
gen double low_prob = 1 - invlogit(logit(mu) - `cut1_true')
gen double middle_prob = invlogit(logit(mu) - `cut1_true') - invlogit(logit(mu) - `cut2_true')
gen double high_prob = invlogit(logit(mu) - `cut2_true')

* Assign outcomes: 0, proportion (beta-distributed), or 1
replace outcome = 0 if rand < low_prob
replace outcome = 1 if rand > (low_prob + middle_prob)

* Generate beta-distributed outcomes for those in the middle category
gen double alpha_beta = mu * `phi_true'
gen double beta_beta = (1 - mu) * `phi_true'
replace outcome = rbeta(alpha_beta, beta_beta) if outcome == .

* Drop unnecessary variables
drop rand low_prob middle_prob high_prob alpha_beta beta_beta

* View the first few observations to check the data
list X eta mu outcome in 1/10

*------------------------------------------------
* Step 5: Fit the ordered beta regression model using the ordbetareg command
*------------------------------------------------

* Now we fit the model using the generated data
ordbetareg outcome X

*------------------------------------------------
* Step 6: Review the results
*------------------------------------------------

* View the estimation results
display "Estimated Parameters"
ml display

margins, dydx(X)

* End of the .do file
