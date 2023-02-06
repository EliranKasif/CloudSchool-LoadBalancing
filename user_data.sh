#!/bin/bash

# Install required packages
apt-get update
apt-get install -y python3-venv git

# Clone the Git repository
git clone https://github.com/EliranKasif/CloudSchool-LoadBalancing.git

# Change to the repository directory
cd CloudSchool-LoadBalancing

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install the required dependencies
pip install flask

# Run the app.py file with the Python interpreter
export FLASK_APP=app.py
flask run &