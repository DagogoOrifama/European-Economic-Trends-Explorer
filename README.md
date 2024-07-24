# European Economic Trends Explorer: Insights into GDP Dynamics and Key Indicators

This project involves a comprehensive exploration of economic indicators and their impact on GDP across 12 selected European countries. The goal is to provide valuable insights through statistical analysis, data visualization, and forecasting.

## Table of Contents
- [Introduction](#introduction)
- [Background Research and Literature Review](#background-research-and-literature-review)
- [Data Preparation and Exploration](#data-preparation-and-exploration)
- [Statistical Analysis](#statistical-analysis)
- [Interactive Dashboard Design](#interactive-dashboard-design)
- [References](#references)

## Introduction

Understanding the relationships between various economic indicators and GDP is essential in today's global economy. This research examines key indicators such as GDP Growth, Population Total, FDI, GNI, Net Migration, and Fertility Rate for 12 European nations using data from the World Bank. The analysis aims to:
- Perform detailed statistical analysis, including descriptive analysis, regression, hypothesis testing, and time series.
- Ensure consistency of results using statistical assumptions.
- Design an interactive Power BI dashboard for insights and forecasting.
- Utilize time series to forecast GDP for the next 5 years for one selected country.

## Background Research and Literature Review

The study builds on previous research in economic indicators and their correlation with GDP. Key literature includes:
- Correlation analysis to identify impactful indicators (Fasolo, 2013).
- Hypothesis testing framework for decision-making (Acree, 2021).
- Regression analysis for modeling relationships (Hamilton, 2020).
- Power BI for data visualization (Powell, 2017).

## Data Preparation and Exploration

### Dataset

The dataset from the World Development Indicator includes economic data from the UK, France, Austria, Germany, Belgium, Italy, Finland, Ireland, Netherlands, Switzerland, Spain, and Denmark. Key indicators analyzed are GDP, GDP growth, Population, FDI, GNI, Net Migration, and Fertility Rate.

### Data Preparation

- Imported and cleaned the dataset in RStudio and Power BI.
- Renamed columns for clarity.
- Checked for and handled missing values.
- Explored the dataset using `head()` and `tail()` functions.
- Verified data consistency and checked for outliers using boxplots.

## Statistical Analysis

### Descriptive Statistical Analysis

Performed descriptive statistics to understand the distribution of economic indicators, including mean, median, mode, standard deviation, variance, skewness, and kurtosis.

### Correlation Analysis

Analyzed the relationship between GDP and other economic indicators using Pearson correlation, revealing significant correlations with Population and Net Migration.

### Hypothesis Testing

Conducted hypothesis tests to:
1. Evaluate the relationship between GDP and FDI.
2. Compare average Fertility Rates between high-GDP and low-GDP countries.

### Regression Analysis

Implemented regression analysis to model the relationship between GDP and other indicators. Validated the assumptions of linearity, independence, normality, and homoscedasticity. Developed a regression equation:
\[ \text{GDP} = 9.837 \times 10^{10} + 3.925 \times 10^4 \times \text{PopulationTotal} \]
Extended to a multiple regression model including Net Migration.

### Time Series Analysis

Used time series analysis to forecast GDP for Germany over the next 5 years, utilizing the auto-Arima model.

## Interactive Dashboard Design

### Data Workflow and Dashboard Design

- Imported and transformed data in Power BI using Power Query.
- Defined objectives and selected key indicators for visualization.
- Designed a user-centric dashboard to visualize economic trends and forecast GDP.

### Visualizations

- Matrix showing average GDP by country.
- Filled map visualizing fertility rates.
- Clustered bar chart for population comparison.
- Cards displaying key statistics like GDP growth and net migration.
- Time series plots and forecasts for GDP.

### Dashboard Story

The dashboard provides insights into GDP dynamics and key indicators, highlighting relationships and trends across the selected countries.

## Discussion and Conclusion

The analysis reveals significant relationships between GDP and indicators like Population and Net Migration. The interactive dashboard enables stakeholders to explore data, identify patterns, and derive actionable insights. The project contributes to understanding economic indicators' impact on GDP, aiding policymakers and economists in decision-making.

## References
- Acree, M. C. (2021). The Fisher and Neyman-Pearson Theories of Statistical Inference.
- Deckler, G. (2019). Learn Power BI: A beginner's guide to developing interactive business intelligence solutions using Microsoft Power BI.
- Hamilton, J. D. (2020). Time Series Analysis. Princeton University Press.
- Kerr, B. A. (2021). Sustainable Development Indicators and Their Relationship to GDP: Evidence from Emerging Economies.
- L. Fasolo, M. G. (2013). A pragmatic approach to evaluate alternative indicators to GDP. Springer Link.
- Powell, B. (2017). Creating Business Intelligence Solutions of Analytical Data Models, Reports, and Dashboards. Packt Publishing.
- Singh, S. (2020). Data Visualization and Analytics: using a business intelligence tool to design a dashboard.
