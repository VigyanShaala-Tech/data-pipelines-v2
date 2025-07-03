### Folder structure

1. `scripts` to have all python scripts related to data cleaning, pre-processing and post-processing etc.
2. `dbt` to hold all dbt related folders.


### Setup

Install the required libraries/packages

$ pip install -r requirements.txt

Setup `profiles.yml` with local Postgres connection details in `~/.dbt` as described [here](https://docs.getdbt.com/docs/core/connect-data-platform/profiles.yml)


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



### Approach for data handling and presentation

- Database schema creation
  1. Use SQL scripts to define and create all database tables.
  2.Incorporate the following within the SQL scripts:
    a) Table schemas with appropriate data types and constraints.
    b) Indexes for optimizing query performance.
    c) ENUMs for constrained categorical fields.
    d) Default values, NOT NULL, Primary Key, Foreign Key and CHECK constraints for data integrity.

- Data transformation and insertion
  1. Write a Python script to transform old database or unstructured data into the new data model format.
  2. This script will handle:
    a) Data transformation.
    b) Field mapping to new schema.
    c) Batch insertion (inserting multiple rows of data in a single operation) into the database.
    d) Handling joins by merging multiple dataframes and creating a new structured dataframe ready for insertion.
    
- Presentation layer using dbt
  1. Use dbt to model and present the final structured data.
  2. dbt will fetch the cleaned and transformed data from the database and will:
    a) Create final models for reporting and analytics.
    b) Apply transformations, filters, and aggregations as needed.    