/* Final Project */

/* Health Analysis */

/* Let's first import our dataset */

FILENAME REFFILE '/home/u63988465/Sleep_health_and_lifestyle_dataset.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=HEALTH;           /* We are going to name our dataset as "HEALTH" */
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=HEALTH; RUN;


/* Now let's check the each variable individually and describe the data (shape, form, spread, outliers) */

/* We will only check for Numerical Variable */

/* 1. Age */
PROC UNIVARIATE DATA=HEALTH;
	VAR Age;
	HISTOGRAM / NORMAL;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBOX Age/ NAME='Boxplot For Age';
RUN;


/* 2. Sleep Duration */
PROC UNIVARIATE DATA=HEALTH;
	VAR 'Sleep Duration'n;
	HISTOGRAM / NORMAL;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBOX 'Sleep Duration'n/ NAME='Boxplot For Sleep Duration';
RUN;

/* 3. Quality of Sleep */
PROC UNIVARIATE DATA=HEALTH;
	VAR 'Quality of Sleep'n;
	HISTOGRAM / NORMAL;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBOX 'Quality of Sleep'n/ NAME='Boxplot For Quality of Sleep';
RUN;

/* 4. Physical Activity Leel */
PROC UNIVARIATE DATA=HEALTH;
	VAR 'Physical Activity Level'n;
	HISTOGRAM / NORMAL;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBOX 'Physical Activity Level'n/ NAME='Boxplot For Physical Activity Level';
RUN;

/* 5. Stress Level */
PROC UNIVARIATE DATA=HEALTH;
	VAR 'Stress Level'n;
	HISTOGRAM / NORMAL;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBOX 'Stress Level'n/ NAME='Boxplot For Stress Level';
RUN;

/* 6. Heart Rate */
PROC UNIVARIATE DATA=HEALTH;
	VAR 'Heart Rate'n;
	HISTOGRAM / NORMAL;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBOX 'Heart Rate'n/ NAME='Boxplot For Heart Rate';
RUN;

/* 7. Daily Steps */
PROC UNIVARIATE DATA=HEALTH;
	VAR 'Daily Steps'n;
	HISTOGRAM / NORMAL;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBOX 'Daily Steps'n/ NAME='Boxplot For Daily Steps';
RUN;


/* Now let's perform for Categorical Variables */

/* 1. Gender */
PROC FREQ DATA=HEALTH;
	TABLES Gender;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBAR Gender / DATASKIN=CRISP DATALABEL;
RUN;

/* 2. Occupation */
PROC FREQ DATA=HEALTH;
	TABLES Occupation;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBAR Occupation / DATASKIN=CRISP DATALABEL;
RUN;

/* 3. BMI Category */
PROC FREQ DATA=HEALTH;
	TABLES 'BMI Category'n;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBAR 'BMI Category'n / DATASKIN=CRISP DATALABEL;
RUN;

/* 4. Blood Pressure*/
PROC FREQ DATA=HEALTH;
	TABLES 'Blood Pressure'n;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBAR 'Blood Pressure'n / DATASKIN=CRISP DATALABEL;
RUN;

/* 5. Sleep Disorder */
PROC FREQ DATA=HEALTH;
	TABLES 'Sleep Disorder'n;
RUN;

PROC SGPLOT DATA=HEALTH;
	VBAR 'Sleep Disorder'n / DATASKIN=CRISP DATALABEL;
RUN;


/* Now let's plot a relationship between two variables */
PROC SGPLOT DATA=HEALTH;
    /* Scatter plot for Sleep Duration vs. Quality of Sleep */
    SCATTER X='Sleep Duration'n Y='Quality of Sleep'n;
    TITLE "Scatter Plot of Sleep Duration vs. Quality of Sleep";
RUN;

PROC SGPLOT DATA=HEALTH;
    /* Scatter plot for Physical Activity Level vs. Daily Steps */
    SCATTER X='Physical Activity Level'n Y='Daily Steps'n;
    TITLE "Scatter Plot of Physical Activity Level vs. Daily Steps";
RUN;

PROC SGPLOT DATA=HEALTH;
    /* Scatter plot for Stress Level vs. Heart Rate */
    SCATTER X='Stress Level'n Y='Heart Rate'n;
    TITLE "Scatter Plot of Stress Level vs. Heart Rate";
RUN;


/* Creating a Joint Distribution, to get more information about the variable relation */
PROC FREQ DATA=HEALTH;
	TABLES Gender * 'Sleep Duration'n ;
	Title "joint Distribution of Gender and Sleep Duration";
RUN;

PROC FREQ DATA=HEALTH;
	TABLES Gender * Occupation ;
	Title "joint Distribution of Gender and Occupation";
RUN;

PROC FREQ DATA=HEALTH;
	TABLES Gender * 'BMI Category'n ;
	Title "joint Distribution of Gender and BMI Category";
RUN;


/* Conditional Distribution, to get more information about the variables*/
PROC FREQ DATA=HEALTH;
	TABLES 'BMI Category'n*'Stress Level'n*'Sleep Disorder'n / NOPERCENT NOROW NOCOL CHISQ;
	WEIGHT 'Sleep Duration'n;
RUN;


/* Calculate the least squares regression line for y in terms of x. How reliable is 
this model, justify? Provide an equation. Plot the regression line. */

/* x = Physical Activity Level */
/* y = Daily Steps */
/* Perform regression analysis */
PROC REG DATA=HEALTH;
    MODEL 'Daily Steps'n = 'Physical Activity Level'n;
    /* Output predicted values to a new dataset for plotting */
    OUTPUT OUT=predicted_data P=Predicted_Steps;
RUN;

/* Scatter plot with regression line */
PROC SGPLOT DATA=predicted_data;
    SCATTER X='Physical Activity Level'n Y='Daily Steps'n / MARKERATTRS=(COLOR=blue);
    SERIES X='Physical Activity Level'n Y=Predicted_Steps / LINEATTRS=(COLOR=red THICKNESS=2);
    TITLE "Regression Line for Daily Steps vs. Physical Activity Level";
    XAXIS LABEL="Physical Activity Level";
    YAXIS LABEL="Daily Steps";
RUN;


/* Let's perform Multiple Linear regression */

/* Perform multiple linear regression analysis */
PROC REG DATA=HEALTH;
    MODEL 'Daily Steps'n = 'Physical Activity Level'n 'Sleep Duration'n 'Stress Level'n 'Heart Rate'n 'Quality of Sleep'n;
    /* Output predicted values to a new dataset for further analysis */
    OUTPUT OUT=predicted_data P=Predicted_Steps;
RUN;

/* View the regression results and diagnostics */
QUIT;

/* Cluster Analysis */
PROC FASTCLUS DATA=HEALTH OUT=cluster_output MAXCLUSTERS=3;
    VAR 'Sleep Duration'n 'Physical Activity Level'n 'Stress Level'n;
RUN;

/* ANOVA */
PROC ANOVA DATA=HEALTH;
    CLASS Occupation;
    MODEL 'Sleep Duration'n = Occupation;
RUN;


/* Now let's perform different types of One Sample test on our Dataset */

/* 1. One Sample t-test */

/* The one-sample t-test is used to compare the mean of a continuous variable against a hypothesized value. 
In this case, we will test if the average Sleep Duration is equal to the recommended 7 hours.

Hypotheses
Null Hypothesis (H₀): The mean sleep duration is 7 hours 𝜇=7
Alternative Hypothesis (H₁): The mean sleep duration is not 7 hours 𝜇≠7.*/

PROC TTEST DATA=HEALTH H0=7 ALPHA=0.05;
    VAR 'Sleep Duration'n;
RUN;

/* It is Two tailed Test */
/* Interpretation of One-Sample t-Test Output
The one-sample t-test examines whether the mean sleep duration is equal to the hypothesized value of 7 hours:

Test Results: The mean sleep duration is 7.1321 hours, with a standard deviation of 0.7957.
t-Statistic and p-Value: The t-statistic is 3.21, and the p-value is 0.0014, which is less than the typical significance level of 0.05.
Conclusion: Since the p-value is below 0.05, we reject the null hypothesis, suggesting that the average sleep duration significantly differs from 7 hours.
Confidence Interval: The 95% confidence interval for the mean sleep duration is (7.05, 7.21), which does not include the hypothesized value (7 hours), further supporting the conclusion.
This indicates that the average sleep duration in the sample is statistically significantly higher than the hypothesized value of 7 hours. */

/* Power Calculation for Multiple Alternative Means in One-Sample t-Test */
ODS GRAPHICS ON;
PROC POWER;
    ONESAMPLEMEANS TEST=T
        MEAN = 7.1 7.2 7.3 7.4 7.5 /* List of alternative means */
        STDDEV = 0.7957 /* Standard Deviation from the dataset */
        NTOTAL = 374 /* Total sample size */
        ALPHA = 0.05 /* Significance level */
        NULLMEAN = 7 /* Hypothesized Mean */
        SIDES=2
        POWER=.;
    PLOT X=N MIN=1 MAX=374 NPOINTS=25;
RUN;
ODS GRAPHICS OFF;

/* Now let's calculate sample size for different powers */
PROC POWER;
	ONESAMPLEMEANS TEST=t
	NULLMEAN=7
	MEAN=7.1 7.2 7.3 7.4 7.5
	STDDEV=0.7957
	NTOTAL=.
	SIDES=2
	POWER=0.8 0.85 0.9 0.95;
RUN;

/* Paired Test */


/* Null hypothesis means of difference is equal to zero */
/* Alternative hypothesis mean of difference is not equal to zero */
DATA paired_data;
    SET HEALTH;
    Weekday_Activity = 'Physical Activity Level'n; /* Example: Physical activity on weekdays */
    Weekend_Activity = 'Physical Activity Level'n * 0.9; /* Assume weekend activity is 90% of weekday for demonstration */
RUN;
/* Perform Paired t-Test */
PROC TTEST DATA=paired_data ALPHA=0.5;
    PAIRED Weekday_Activity*Weekend_Activity;
RUN;

/* Power Analysis for Paired t-Test with Alternative Mean Differences */
PROC POWER;
    PAIREDMEANS TEST=DIFF
        MEANDIFF = 0.1 0.2 0.3 0.4 0.5 /* List of alternative mean differences */
        STDDEV = 0.7957 /* Standard Deviation of the differences */
        NPAIRS = 374 /* Number of paired observations (sample size) */
        ALPHA = 0.05 /* Significance level */
        SIDES = 2 /* Two-tailed test */
       	CORR=0.7
        POWER = .;
    PLOT X = N MIN = 1 MAX = 400;
RUN;



/* Two Sample t-test (Comparing the mean sleep duration between two groups (Gender or BMI Category)) */
PROC TTEST DATA=HEALTH;
    CLASS Gender;
    VAR 'Sleep Duration'n;
RUN;

/* Power Calculation for Two-Sample t-Test with Multiple Alternative Means (TEST=DIFF indicates that the test focuses
on the difference between the means of the two groups.)*/
PROC POWER;
    TWOSAMPLEMEANS TEST=DIFF
        MEANDIFF = 0.1 0.2 0.3 0.4 0.5 /* List of mean differences (alternative means) */
        STDDEV = 0.7957 /* Pooled Standard Deviation */
        NPERGROUP = 187 /* Sample size per group (374 total observations split evenly) */
        ALPHA = 0.05 /* Significance level */
        SIDES = 2 /* Two-tailed test */
        POWER=.; 
    PLOT X=N MIN=1 MAX=400;
RUN;

/* The Central Limit Theorem (CLT) states that if you take a large number of independent
and identically distributed random variables, their sample mean will follow a normal
distribution (approximately) regardless of the original distribution of the variables,
provided the sample size is sufficiently large. This is true even if the underlying
distribution is not normal.
The distribution of Sam’s average payoff after 520 spins will be approximately normal.
The mean of this distribution will be close to the expected value, which is $0.91.
The spread (standard deviation) of the distribution of the average payoff will be $0.5513.
Therefore, while individual payoffs may vary significantly, the average payoff after 520
spins will cluster around the expected value of $0.91, with most average payoffs lying
within about $0.55 of this value.
*/





/* 2. One Sample proportion Test */

