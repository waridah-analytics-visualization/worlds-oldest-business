## 1. The oldest businesses in the world
# Import the pandas library under its usual alias 
import pandas as pd

# Load the business.csv file as a DataFrame called businesses
businesses = pd.read_csv('datasets/businesses.csv')


# Sort businesses from oldest businesses to youngest
sorted_businesses = businesses.sort_values(by='year_founded', ascending=True)


# Display the first few lines of sorted_businesses
print(sorted_businesses.head())


                       business  year_founded category_code country_code
64                    Kongō Gumi           578          CAT6          JPN
94   St. Peter Stifts Kulinarium           803          CAT4          AUT
107        Staffelter Hof Winery           862          CAT9          DEU
106            Monnaie de Paris            864         CAT12          FRA
103               The Royal Mint           886         CAT12          GBR







## 2. The oldest businesses in North America
# Load countries.csv to a DataFrame	
countries = pd.read_csv("datasets/countries.csv")
# Merge sorted_businesses with countries
businesses_countries = sorted_businesses.merge(countries, on="country_code")
# Filter businesses_countries to include countries in North America only
north_america = businesses_countries[businesses_countries["continent"]=="North America"]
north_america.head()


 # Load countries.csv to a DataFrame	
countries = pd.read_csv("datasets/countries.csv")
# Merge sorted_businesses with countries
businesses_countries = sorted_businesses.merge(countries, on="country_code")
# Filter businesses_countries to include countries in North America only
north_america = businesses_countries[businesses_countries["continent"]=="North America"]
north_america.head()



## 3. The oldest business on each continent
# Create continent, which lists only the continent and oldest year_founded
continent = businesses_countries.groupby("continent").agg({"year_founded":"min"})

# Merge continent with businesses_countries
merged_continent = continent.merge(businesses_countries, on=["continent","year_founded"])

# Subset continent so that only the four columns of interest are included
subset_merged_continent = merged_continent[["continent","country","business","year_founded"]]

subset_merged_continent

	continent	  country	         business	             year_founded
0	Africa	    Mauritius	         Mauritius Post	            1772
1	Asia	    Japan	             Kongō Gumi	                     578
2	Europe	    Austria	             St. Peter Stifts Kulinarium	      803
3	North America	Mexico	     La Casa de Moneda de México	1534
4	Oceania	      Australia	         Australia Post             	1809
5	South America	Peru	     Casa Nacional de Moneda	1565


## 4. Unknown oldest businesses
# Use .merge() to create a DataFrame, all_countries
all_countries = businesses.merge(countries, on='country_code', how='right', indicator=True)

# Filter to include only countries without oldest businesses
missing_countries = all_countries[all_countries['_merge'] !='both']

# Create a series of the country names with missing oldest business data
missing_countries_series = missing_countries["country"]


# Display the series
missing_countries_series



## 5. Adding new oldest business data
# Import new_businesses.csv
new_businesses = pd.read_csv("datasets/new_businesses.csv")

# Add the data in new_businesses to the existing businesses
all_businesses = pd.concat([new_businesses, businesses])

# Merge and filter to find countries with missing business data
new_all_countries = all_businesses.merge(countries, on="country_code", how="outer",  indicator=True)
new_missing_countries = new_all_countries[new_all_countries["_merge"] != "both"]

# Group by continent and create a "count_missing" column
count_missing = new_missing_countries.groupby("continent").agg({"country":"count"})
count_missing.columns = ["count_missing"]
count_missing



## 6. The oldest industries
# Import categories.csv and merge to businesses
categories = pd.read_csv("datasets/categories.csv")
businesses_categories = businesses.merge(categories, on="category_code")

# Create a DataFrame which lists the number of oldest businesses in each category
count_business_cats = businesses_categories.groupby("category").agg({"business":"count"})

# Create a DataFrame which lists the cumulative years that businesses from each category have been operating
years_business_cats = businesses_categories.groupby("category").agg({"year_founded":"sum"})

# Rename columns and display the first five rows of both DataFrames
count_business_cats.columns = ["count"]
years_business_cats.columns = ["total_years_in_business"]
display(count_business_cats.head(), years_business_cats.head())

## 7. Restaurant representation
# Filter using .query() for CAT4 businesses founded before 1800; sort results
old_restaurants = businesses_categories.query('category == "Cafés, Restaurants & Bars" and year_founded <1800' )

old_restaurants =old_restaurants.sort_values('year_founded', ascending= True)

print(old_restaurants.head(10))

## 8. Categories and continents
# Merge all businesses, countries, and categories together
businesses_categories_countries = businesses_categories.merge(countries, on="country_code")

# Sort businesses_categories_countries from oldest to most recent
businesses_categories_countries = businesses_categories_countries.sort_values("year_founded")

# Create the oldest by continent and category DataFrame
oldest_by_continent_category = businesses_categories_countries.groupby(["continent", "category"]).agg({"year_founded":"min"})
oldest_by_continent_category.head()
