library(lme4)
library(brms) 
options(brms.backend = "cmdstanr")
library(broom.mixed)
library(purrr)
library(dplyr)
library(tidybayes)
library(bayesplot) 
library(bayestestR) 
library(ggplot2); theme_set(theme_bw()) 
library(see)
library(ggrastr)
library(cowplot)
library(tidyverse) 

#This RDS file is created by "pup_weight_and_fl_plots.R" in the "pup_data" folder of my QMEE repo
## JD: Better to do this by putting the relative path in as below
pup_weight_fl <- readRDS( file = "pup_data/WeightsandForearmLengths.rds")

#Order ages & change to numeric
pup_weight_fl$Age <- factor(pup_weight_fl$Age,levels=c("2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "30", "32", "34", "36"))
numeric_weight <- pup_weight_fl %>% mutate (Age = as.numeric(Age))
#summary(numeric_weight)

#View pup weight data
ggplot(numeric_weight, aes(x = Age, y = Weight, group = Pup_ID, color = Pup_ID)) +
  geom_point() +
  geom_line()

#Alternatively:
ggplot(numeric_weight, aes(x = Age, y = Weight, group = Pup_ID, color = Pup_ID)) +
geom_point() +
geom_line() +
facet_wrap(~Pup_ID)

#I think a linear regression with random slopes and intercepts model makes sense for these data. 

#Model:
m_weight <- Weight ~ 1 + Age + (1 + Age|Pup_ID)

#Prior predictive simulation
get_prior(m_weight, numeric_weight)
#This provides the default prior specifications for the parameters in my model. 
#The default (flat) prior are improper for any fixed effects and intercepts
#Age is the only fixed effect, and it has an improper prior because it assumes it's flat


#This is taken from the example shown in class
#It runs a chain sampling values from the prior distribution for 500 iterations. 
#add_predicted_draw makes a copy of the data and puts it onto my original data set. 
#.prediction variable is predicted value. 
#.draw predictions tells which sample to draw from. 
test_prior <- function(p) {
  ## https://discourse.mc-stan.org/t/suppress-all-output-from-brms-in-markdown-files/30117/3
  capture.output(
    b <- brm(m_weight, numeric_weight, prior = p,
             seed = 101,             
             sample_prior = 'only',   
             chains = 1, iter = 500,  
             silent = 2, refresh = 0  
    )
  )
  p_df <- numeric_weight |> add_predicted_draws(b)
  gg0 <- ggplot(p_df,aes(Age, .prediction, group=interaction(Pup_ID,.draw))) +
    geom_line(alpha = 0.1)
  print(gg0)
  invisible(b) 
}

#Set priors
my_priors <- c(set_prior("normal(5, 2)", "Intercept"),
              set_prior("normal(1, 2)", "b"),
              set_prior("student_t(4, 0, 2)", "sd"),
              set_prior("student_t(5, 0, 2)", "sigma")
)
##I am setting the intercept a prior mean of 5 and SD of 2 because pups are very small at Age = 2, and there isn't much variation
##I set the prior for "b" to have a mean of 1 and SD of 1 because we can expect pups to increase in mass
##I am also constraining the random effects SDs and residual standard deviation

## BMB: as you can see from the tests, allowing a SD of 1 on the slope prior allows for some quite large negative values -- probably
## make the slope SD smaller.
## In practice this won't matter much because the data are very informative, so the prior gets overwhelmed.
## Fitting mass on the log scale would prevent the masses from going negative even if the slope was negative (i.e., mass would
## decline exponentially toward zero)
set.seed(101); range(rnorm(500, mean = 1, sd = 1))


#This calls the function created above, applying my set priors
test_prior(my_priors) 
#I have tried a bunch of different priors for hours but the intercepts and lots of values are still negative
#I know negative intercepts (and other values) do not make sense because it is impossible to have negative mass, but I cannot figure out how to fix it
#I know this means that my model probably won't be great

#But I will continue anyways
model_b <- brm(m_weight, numeric_weight, prior = my_priors,
             seed = 101,
             control = list(adapt_delta = 0.99)
)
#I'm getting warning messages that the Random variable is 0 but must be positive, so I know something's wrong, but I don't know how to fix it
## BMB: Hmm, I don't get those warnings

#Trying with the default priors
default_b <- brm(m_weight, numeric_weight,
                  seed = 101
)
#Same warning messages, plus 5 of 4000 transitions ended with a divergence
## BMB: the divergences would need to be dealt with, so that's an extra bonus on the tighter priors you specified
## (keeps the chains from going to bad places)

#Diagnoses
print(diagnostic_posterior(model_b),
      digits = 4) 
#The convergence diagnostic, Rhat (i.e. how much more the chains could overlap if ran forever), is less than the threshold of 1.01. 
#The effective sample size, ESS (i.e. the independent pieces of information), is greater than 400
#The Monte Carlo standard error, MSCE (i.e. how much noise there is in the estimate of the mean), are quite small
## BMB: OK

#Diagnoses with rank histograms
mcmc_rank_overlay(model_b, regex_pars= "b_|sd_")
#The horizontal lines represent the posterior rank of the parameters
#We want the lines to be evenly spread for all chains
#There are a few spots where the lines aren't quite evenly spread, but from my understanding, the divergence isn't too big to worry about
## BMB: OK

#Results
summary(model_b)
#The Intercept estimate is 4.09 with CI 3.17 to 4.84, a little lower than my set prior of mean = 5
#The estimate for Age is 0.86, with CI 0.71 to 0.97, also a little lower than my set prior of mean = 1

#Plot results 
#These lines of code are also taken from the example from class
brms_list <- list(brms_default = default_b, brms_model = model_b)
bayes_r <- (brms_list
              |> map_dfr(~ tidy(., conf.int = TRUE), .id = "model")
)
#Also want to compare to frequentist approach (i.e lmer)
weight_lmer <- lmer(m_weight, numeric_weight)
#summary(weight_lmer)
lmer_r <- suppressMessages(weight_lmer
                             |> tidy(conf.int = TRUE, conf.method = "profile")
                             |> mutate(model = "lmer", .before = 1)
)
res <- (bind_rows(lmer_r, bayes_r)
        |> select(-c(std.error, statistic, component, group))
        |> filter(term != "(Intercept)")
        |> mutate(facet = ifelse(grepl("^cor", term), "cor",
                                 ifelse(grepl("Age", term), "Age",
                                        "int")))
        |> mutate(across(model, ~ factor(., levels = c("lmer", names(brms_list)))))
)

ggplot(res, aes(estimate, term, colour = model, shape = model)) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high),
                  position = position_dodge(width = 0.5)) +
  facet_wrap(~ facet, scales = "free", ncol = 1) +
  guides(colour = guide_legend(reverse=TRUE),
         shape = guide_legend(reverse=TRUE))
#The lmer model and the two brms models (one with default prior and the other with my set priors) look pretty similar
##The brms_model value for the correlation between Intercept and Age is positive, while it is negative for the other two. However, the CIs are wide and cover much of the same range, so we can't be very certain that they are truly different
## BMB: Agreed. This is barely any difference. All we can tell is that the correlation isn't very large (say, corr > -0.5 and corr < 0.5)
## (To be more careful we should probably center Age, although I doubt the intercept-slope correlation is of great scientific interest ...)


#Posterior predictive simulations to compare to my data
post_df1 <- numeric_weight |> add_predicted_draws(model_b)
gg_posterior <- ggplot(post_df1,
              aes(Age, .prediction, group=interaction(Pup_ID,.draw))) +
  rasterise(geom_line(alpha = 0.1)) +
  geom_point(aes(y=Weight), col = "red") +
  labs(y = "Weight")
print(gg_posterior)
#I think this looks okay

#Posterior predictive simulation for one subject
post_dfB <- filter(post_df1, Pup_ID == levels(Pup_ID)[1])
plot_grid(gg_posterior %+% post_dfB)
#I think this also looks okay

## BMB: I agree.

## JD: Sorry it took me so long to get to this! I cannot get the stan stuff to run, with a weird error. I guess it might be something to do with versions. I am just going to mark it “complete” for now.

## BMB: mark 2.1
