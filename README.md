### Folder structure

1. `scripts` to have all python scripts related to data cleaning, pre-processing and post-processing etc
2. `dbt` to hold all dbt related folders with models in `core` to keep original data tables related to our programs, `lms` to keep all the models that are pulled from LMS APIs and final reporting tables in `final`. Each of the subdirectories to have their own `schema.yml`.


### Setup

Install the required libraries/packages

$ pip install -r requirements.txt

Setup `profiles.yml` with connection details on your local machine as described (here)[https://docs.getdbt.com/docs/core/connect-data-platform/profiles.yml]


### Running

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
