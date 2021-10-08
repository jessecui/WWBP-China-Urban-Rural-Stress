args <- commandArgs(trailingOnly = TRUE)

library(lme4)
library(foreign)
library(lattice)
library(effects)
library(gplots)
library(MASS)
library(arm)
library(MuMIn)
library(lmerTest)

# This script processes mixed effects between language feature categories
df <-  read.csv(file = args[1])
output_file = paste0(args[2])

# Takes Log ProvincePerCapitaGDP2012
df$PercentUrban = df$PercentUrban / 100
df$ProvincePerCapitaGDP2012 <- log(df$ProvincePerCapitaGDP2012)

# Removes warnings (each model gives a warning)
oldw <- getOption("warn")
options(warn = -1)

# Function for getting standardized coefficients
stdCoef.merMod <- function(object) {
  sdy <- sd(getME(object, "y"))
  sdx <- apply(getME(object, "X"), 2, sd)
  sc <- fixef(object) * sdx / sdy
  se.fixef <- coef(summary(object))[, "Std. Error"]
  se <- se.fixef * sdx / sdy
  return(data.frame(
    stdcoef = sc,
    stdse = se,
    stdfactor = (sdx / sdy)
  ))
}

outcomes <- c('PercentUrban', 'ProvincePerCapitaGDP2012')
controls <- c('None')

# Gets unique feats and sets up matrix
unique_feats <- unique(df$feat)
iterations <- length(unique_feats)
num_stats <- 13
output <- matrix(ncol = num_stats, nrow = iterations)
count <- 1

# Creates progress bar
pb <- txtProgressBar(min = 1, max = iterations, style = 3)

rownames(output) <- c(unique_feats)
colnames(output) <- c(
  'R2c',
  'R2m',
  'deviance',
  'urb.cf',
  'urb.ci_l',
  'urb.ci_u',
  'urb.t',
  'urb.p',
  'gdp.cf',
  'gdp.ci_l',
  'gdp.ci_u',
  'gdp.t',
  'gdp.p'
)

# Loops through each feat
for (i in unique_feats) {
  print(i)
  # Extracting rows with feat i
  table <- df[df$feat == i, ]
  
  # If there is insufficient data, continue to next feat
  if (nrow(table) < 20) {
    output[count, ] <- c(0, 0, 0, 0, 0, 0, 0, 0, 0)
    rownames(output)[count] <- c(i)
    setTxtProgressBar(pb, count)
    count <- count + 1
    next
  }
  
  # Percent Urban + Province GDP HLM
  m <-
    lmer(
      group_norm ~ gender_isFemale 
      + (1 |province_id) 
      + PercentUrban 
      + ProvincePerCapitaGDP2012,
      data = table
    )
  model_data <- c()
  
  r.squared <- r.squaredGLMM(m)
  p_value <- coef(summary(m))
  std_coef <- stdCoef.merMod(m)
  model_stats <-
    c(r.squaredGLMM(m)[, 'R2c'], r.squaredGLMM(m)[, 'R2m'], deviance(m))
  model_data <- c(model_data, model_stats)
  
  # Fills up matrix
  for (o in outcomes) {
    os <- 0
    model_index_o = match(o, names(fixef(m)))
    contrast_vec = rep(0, length((fixef(m))))
    contrast_vec[model_index_o] = 1
    
    confint = contest(
      m,
      contrast_vec,
      joint = FALSE,
      confint = TRUE,
      level = .95
    )
    o_data <- c(
      std_coef[o, 'stdcoef'],
      confint$lower * std_coef[o, 'stdfactor'],
      confint$upper  * std_coef[o, 'stdfactor'],
      p_value[o, 't value'],
      p_value[o, 'Pr(>|t|)']
    )
    model_data <- c(model_data, o_data)
  }
  
  output[count, ] <- model_data
  rownames(output)[count] <- c(i)
  setTxtProgressBar(pb, count)
  count <- count + 1
}
close(pb)

write.csv(output, output_file)
