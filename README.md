### Folder structure

1. `scripts` to have all python scripts related to data cleaning, pre-processing and post-processing etc.
2. `dbt` to hold all dbt related folders.


### Setup

Install the required libraries/packages

$ pip install -r requirements.txt

Setup `profiles.yml` with connection details on your local machine as described [here](https://docs.getdbt.com/docs/core/connect-data-platform/profiles.yml)


### Approach to data modelling

1. `Staging` models should be data source-agnostic and not tied to specific reporting requirements yet. They should focus on cleaning and transforming data into a usable form. The source data for these could be CSVs, other raw tables in the database, populated from applications, APIs etc.
2. `Intermediate` models should hold data after significant transformations - like aggregations, joining multiple tables, filtering.
3. `Final` models are totally tied to and optimized for reporting needs.


### Running

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Naming conventions [style guide](https://docs.getdbt.com/best-practices/how-we-style/1-how-we-style-our-dbt-models)
