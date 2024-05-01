;extends

([
   (interpreted_string_literal)
   (raw_string_literal)
 ] @sql
 (#contains? @sql "-- sql" "--sql" "ADD CONSTRAINT" "ALTER TABLE" "ALTER COLUMN" "DATABASE" "FOREIGN KEY" "GROUP BY" "HAVING"
		  "CREATE INDEX" "INSERT INTO" "CREATE TABLE" "create table"
		  "NOT NULL" "PRIMARY KEY" "UPDATE SET" "TRUNCATE TABLE" "LEFT JOIN"
		  "add constraint" "alter table" "alter column" "database" "foreign key" "group by" "having" 
		  "create index" "insert into" "not null" "primary key" "update set" "truncate table" "left join")
 (#offset! @sql 0 1 0 -1))
