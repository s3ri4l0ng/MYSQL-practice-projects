-- Enforcing strict SQL mode 
SET GLOBAL sql_mode =
'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';

-- Set default time zone 
SET GLOBAL time_zone = '+00:00';

-- Increase InnoDB buffer pool
SET GLOBAL innodb_buffer_pool_size = 1073741824