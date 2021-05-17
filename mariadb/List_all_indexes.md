# MySQL - How to list all indexes of a table or schema?


### To list all indexes of a specific table:
```
SHOW INDEX FROM table_name FROM db_name;
```

### Or an alternative statement:

```
SHOW INDEX FROM db_name.table_name;
```

### To list all indexes of a schema:

```
SELECT
    DISTINCT TABLE_NAME,
    INDEX_NAME
FROM
    INFORMATION_SCHEMA.STATISTICS
WHERE
    TABLE_SCHEMA = `schema_name`;
```

### To list all indexes from all schemas of the current connection:

```
SELECT
    DISTINCT TABLE_NAME,
    INDEX_NAME
FROM
    INFORMATION_SCHEMA.STATISTICS;
```
