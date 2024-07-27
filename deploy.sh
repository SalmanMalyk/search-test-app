#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the main branch and build directory
MAIN_BRANCH="main"
BUILD_DIR="dist"

# Check if the main branch exists and switch to it
git checkout -B $MAIN_BRANCH

# Add all changes
git add .

# Commit changes
git commit -m "Deploying to GitHub Pages"

# Push changes to the main branch
git push origin $MAIN_BRANCH

# Build the Vue.js application
npm run build

# Move to the build directory
cd $BUILD_DIR

# Initialize a new Git repository
git init
git add .
git commit -m "Deploy to GitHub Pages"

# Add the remote repository
git remote add origin git@github.com:SalmanMalyk/search-test-app.git

# Force push to the gh-pages branch
git push -f origin master:gh-pages

# Go back to the root project directory
cd -

echo "Deployment to GitHub Pages complete."
