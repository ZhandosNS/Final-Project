cd "C:\Users\Nurmukanov_Zhandos\Desktop\Coding Project"
clear all
set more off, perm
capture log close
log using "main.log", replace text

*creating folders
cap mkdir data
cap mkdir output
cap mkdir output/graphs
cap mkdir output/tables
cap mkdir temp

*importing the dataset
import delimited "airbnb_london_listing.csv", clear

*fixing common data quality errors and converting string variables into numeric variables first (inconsistent data types)
destring host_response_rate host_listings_count host_total_listings_count bathrooms bedrooms beds review_scores_rating review_scores_accuracy review_scores_cleanliness review_scores_checkin review_scores_communication review_scores_location review_scores_value reviews_per_month, replace force

*creating a new numeric variable out of existing string variable assigning 1 to "t" and 0 to "f"
gen host_is_superhost_numeric = (host_is_superhost == "t")
gen host_has_profile_pic_numeric = ( host_has_profile_pic == "t")
gen host_identity_verified_numeric = ( host_identity_verified == "t")
gen is_location_exact_numeric = ( is_location_exact == "t")
gen requires_license_numeric = ( requires_license == "t")
gen instant_bookable_numeric = ( instant_bookable == "t")
gen require_guest_profilenumeric = ( require_guest_profile_picture == "t")
gen require_guest_phone_vernumeric = ( require_guest_phone_verification == "t")

*dropping missing values in one selected variable - fixing data quality errors 
drop if missing(review_scores_value)

*creating summary statistics of numeric variables
sum host_response_rate guests_included  latitude bathrooms availability_30 availability_365  review_scores_accuracy review_scores_communication calculated_host_listings_count host_listings_count longitude     bedrooms   minimum_nights  availability_60 number_of_reviews review_scores_cleanliness review_scores_location reviews_per_month   accommodates  beds     host_total_listings_count    maximum_nights  availability_90  review_scores_rating review_scores_checkin review_scores_value

ssc install estout

*creating a summary stats table
estpost summarize host_response_rate guests_included  latitude bathrooms availability_30 availability_365  review_scores_accuracy review_scores_communication calculated_host_listings_count host_listings_count longitude     bedrooms   minimum_nights  availability_60 number_of_reviews review_scores_cleanliness review_scores_location reviews_per_month   accommodates  beds     host_total_listings_count    maximum_nights  availability_90  review_scores_rating review_scores_checkin review_scores_value

*downloading and transfering a table to a folder
esttab using "output/summary_statistics1.txt", cells("count mean sd min max") replace

*creating a histogram
hist availability_365
hist availability_365, title ("Availability")
graph export "C:\Users\Nurmukanov_Zhandos\Desktop\Graph.png", as(png) name("Graph")

*exporting the graph from stata to "Graphs" folder
graph export "output/graphs/Graph.png", replace 

*creating and exporting a bar graph
graph bar (mean) bathrooms (mean) bedrooms (mean) beds (mean) guests_included

graph export "C:\Users\Nurmukanov_Zhandos\Desktop\Coding Project\output\graphs\Graph1.png", as(png) name("Graph")

*creating a copy of the original variable 'beds' and then filtering its observations by number of beds 
gen beds_copy = beds
keep if beds_copy >= 5
keep host_response_rate guests_included  latitude bathrooms availability_30 availability_365  review_scores_accuracy review_scores_communication calculated_host_listings_count host_listings_count longitude     bedrooms   minimum_nights  availability_60 number_of_reviews review_scores_cleanliness review_scores_location reviews_per_month   accommodates  beds     host_total_listings_count    maximum_nights  availability_90  review_scores_rating review_scores_checkin review_scores_value beds_copy

*creating a transformation of variables by transforming them into categories
generate beds_category = .
replace beds_category = 1 if beds >=5 & beds < 8
replace beds_category = 2 if beds >=8 & beds < 12
replace beds_category = 3 if beds >= 12
