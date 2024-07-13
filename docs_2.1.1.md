# Functions
## add
Inserts values at the end of `table`. It's equivalent to
```lua
table[#table+1]=value_1
table[#table+2]=value_2
...
table[#table+n]=value_n
```
### Params:
1. table: table - table for adding values
2. ...: any - values to add
## clear
Deletes all elements from tables
### Params:
1. ...: table - tables to clear
## concat
Concatenates the specified tables
### Params:
1. ...: table - tables to concatenate
### Returns:
1. table - concatenated table
## copy
Returns a copy of `table`. These tables are different objects so editing the 1st table doesn't edit the 2nd table

If `recursive`, it also copies subtables
### Params:
1. table: table - table to copy
2. recursive?: booleab - whether to copy subtables
### Returns:
1. table - copied table
## delete
Deletes the element of `table` with `index`

If `shift`<=0 then indexes of all values after the value with `index` will decrease by 1. Otherwise indexes of all values before the value with `index` will increase by 1.
### Params:
1. table: table - table for deleting values
2. index: integer - index of the value to be deleted
3. shift?: number
