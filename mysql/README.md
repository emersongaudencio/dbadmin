# dbadmin for mysql

- create dbadmin database or use your current app database
```
create database dbadmin;
```

- import routines_dbadmin.sql to the dbadmin database
-- 1rst way
```
mysql -u root -p dbadmin < routines_dbadmin.sql
```
-- 2nd way
```
mysql -u root -p dbadmin -e "source ./routines_dbadmin.sql;"
```


- Managing Schema updates
* [Skeema Examples](https://www.skeema.io/docs/examples/)
