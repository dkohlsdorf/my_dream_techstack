#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Flask HTMX MySQL Setup...${NC}"

# Check if MySQL is running
if ! systemctl is-active --quiet mysql; then
    echo -e "${YELLOW}MySQL service is not running. Starting MySQL...${NC}"
    sudo systemctl start mysql
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to start MySQL. Please start it manually.${NC}"
        exit 1
    fi
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file from .env.example...${NC}"
    cp .env.example .env
fi

# Install Python dependencies
echo -e "${YELLOW}Installing Python dependencies...${NC}"
pip install -r requirements.txt

# Prompt for MySQL root password
echo -e "${YELLOW}Setting up database...${NC}"
read -s -p "Enter MySQL root password (press Enter if no password): " ROOT_PASSWORD
echo

# Set up database
sudo mysql < setup_db.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Database setup completed successfully!${NC}"
else
    echo -e "${RED}Database setup failed. Please check MySQL connection.${NC}"
    exit 1
fi

# Start Flask application
echo -e "${GREEN}Starting Flask application...${NC}"
echo -e "${YELLOW}Access the app at: http://localhost:5000${NC}"
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
python app.py
