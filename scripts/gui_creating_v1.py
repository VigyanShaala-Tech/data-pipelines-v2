import streamlit as st
import pandas as pd
df = pd.read_csv("/home/arjun/data-pipelines-v2/scripts/Assignment_feedback_data.csv")
# splitted the multiple assignments_names into a dictionary
list_of_assignments = {
    "Goal Setting": ("Assignment_Goal_setting", "Comments_Assignment_Goal_setting"),
    "LinkedIn Profile": ("Assignment_LinkedIn_Profile", "Comments_Assignment_LinkedIn_Profile"),
    "STEM Curiosity": ("Assignment_STEM_Curiosity", "Comments_Assignment_STEM_Curiosity"),
    "Career Journal": ("Assignment_Career_Journal", "Comments_Assignment_Career_Journal"),
}
#below function is used to get the status of the assignment based on the score
def get_status(score):
    if score == 0:
        return "UNDER REVIEW", "yellow"
    elif score >= 30:
        return "ACCEPTED", "green"
    else:
        return "REJECTED WITH FEEDBACK", "orange"
# Get the list of colleges from the dataframe
college_list = df['Name of the college'].dropna().unique()
selected_college = st.sidebar.selectbox("Colleges", sorted(college_list))

