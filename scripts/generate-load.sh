#!/bin/bash

echo "Generating load for monitoring demonstration..."

# Generate some MySQL activity
for i in {1..10}; do
    docker exec lab2-mysql-db-1 mysql -u root -pyour-secure-mysql-password -e "
        USE lab_db;
        SELECT COUNT(*) FROM teams;
        SELECT COUNT(*) FROM employees;
        SELECT COUNT(*) FROM projects;
    " > /dev/null 2>&1
    echo "MySQL query $i completed"
    sleep 2
done

# Generate some backend API calls
for i in {1..20}; do
    curl -s http://localhost:3000/health > /dev/null
    curl -s http://localhost:3000/metrics > /dev/null
    echo "API call $i completed"
    sleep 1
done

echo "Load generation complete! Check your monitoring dashboards." 