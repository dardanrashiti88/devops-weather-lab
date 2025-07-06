-- Database Performance Test Script
-- This script tests various MySQL performance aspects

-- Set performance schema to collect metrics
SET GLOBAL performance_schema = ON;

-- Test 1: Connection and basic operations
SELECT 'Test 1: Basic Connection Test' as test_name;
SELECT VERSION() as mysql_version;
SELECT NOW() as current_time;
SELECT COUNT(*) as connection_count FROM information_schema.processlist;

-- Test 2: Database size and table statistics
SELECT 'Test 2: Database Statistics' as test_name;
SELECT 
    table_schema as database_name,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) as size_mb,
    COUNT(*) as table_count
FROM information_schema.tables 
WHERE table_schema = 'lab_db'
GROUP BY table_schema;

-- Test 3: Table performance metrics
SELECT 'Test 3: Table Performance Metrics' as test_name;
SELECT 
    table_name,
    table_rows,
    ROUND(data_length / 1024 / 1024, 2) as data_size_mb,
    ROUND(index_length / 1024 / 1024, 2) as index_size_mb,
    ROUND((data_length + index_length) / 1024 / 1024, 2) as total_size_mb
FROM information_schema.tables 
WHERE table_schema = 'lab_db'
ORDER BY (data_length + index_length) DESC;

-- Test 4: Index usage statistics
SELECT 'Test 4: Index Usage Statistics' as test_name;
SELECT 
    table_schema,
    table_name,
    index_name,
    cardinality,
    sub_part,
    packed,
    nullable,
    index_type
FROM information_schema.statistics 
WHERE table_schema = 'lab_db'
ORDER BY table_name, index_name;

-- Test 5: Slow query analysis (if slow query log is enabled)
SELECT 'Test 5: Slow Query Analysis' as test_name;
SELECT 
    'Slow query log status' as info,
    @@slow_query_log as slow_query_log_enabled,
    @@long_query_time as long_query_time_threshold;

-- Test 6: Buffer pool statistics
SELECT 'Test 6: Buffer Pool Statistics' as test_name;
SELECT 
    variable_name,
    variable_value
FROM performance_schema.global_status 
WHERE variable_name LIKE 'Innodb_buffer_pool%'
ORDER BY variable_name;

-- Test 7: Connection and thread statistics
SELECT 'Test 7: Connection Statistics' as test_name;
SELECT 
    variable_name,
    variable_value
FROM performance_schema.global_status 
WHERE variable_name IN (
    'Threads_connected',
    'Threads_running',
    'Threads_created',
    'Threads_cached',
    'Max_used_connections'
);

-- Test 8: Query cache statistics (if available)
SELECT 'Test 8: Query Cache Statistics' as test_name;
SELECT 
    variable_name,
    variable_value
FROM performance_schema.global_status 
WHERE variable_name LIKE 'Qcache%'
ORDER BY variable_name;

-- Test 9: InnoDB status
SELECT 'Test 9: InnoDB Status' as test_name;
SHOW ENGINE INNODB STATUS\G

-- Test 10: Performance schema summary
SELECT 'Test 10: Performance Schema Summary' as test_name;
SELECT 
    event_name,
    count_star,
    sum_timer_wait / 1000000000 as total_time_seconds,
    avg_timer_wait / 1000000 as avg_time_milliseconds
FROM performance_schema.events_waits_summary_global_by_event_name
WHERE count_star > 0
ORDER BY sum_timer_wait DESC
LIMIT 10;

-- Test 11: Memory usage
SELECT 'Test 11: Memory Usage' as test_name;
SELECT 
    variable_name,
    ROUND(variable_value / 1024 / 1024, 2) as value_mb
FROM performance_schema.global_status 
WHERE variable_name IN (
    'Bytes_received',
    'Bytes_sent',
    'Max_used_connections'
);

-- Test 12: Lock statistics
SELECT 'Test 12: Lock Statistics' as test_name;
SELECT 
    variable_name,
    variable_value
FROM performance_schema.global_status 
WHERE variable_name LIKE '%lock%'
ORDER BY variable_name;

-- Performance test completion
SELECT 'Database Performance Test Completed' as status, NOW() as completion_time; 