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
Returns a copy of `table`. These tables are different objects so editing the 1st table doesn't edit the 2nd table\
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
3. shift?: number - -1 (default) or 1

## exclude
Deletes elements with the specified keys from `table`
### Params:
1. table: table - table for excluding values
2. ...: any - keys of values to be excluded

## get
Returns a new table containing the values with the specified keys from `table`
### Params:
1. table: table - table to get values from
2. ...: any - keys of required values
### Returns:
1. table - table containing the required values

## insert
Inserts `value` with `index` into `table`\
If `shift`>=0 then indexes of all values after the value with `index` will increase by 1. Otherwise indexes of all values before the value with `index` will decrease by 1.
### Params:
1. table: table - table for inserting values
2. value: any - value to insert
3. index?: integer - default: 1
4. shift?: number - 1 (default) or -1

## overlay
Overlays tables on top of each other\
Returns a new table with the fields of the 1st table are replaced by the fields of the 2nd table, etc. If a field is nil, it doesn't replace the previous field.\
If `recursive`, it also overlays subtables
### Params:
1. recursive: boolean - whether to overlay subtables
2. ...: table - tables to be overlaid
### Returns:
1. table - overlay result

## Proxy
Creates a proxy for `table`
### Params:
1. table: table - table create a Proxy for
2. index?: table|fun(table: table, key: any): any - The 'index' field in the metatable. If param is nil, field is `table`.
3. new_index?: boolean|table|fun(table: table, key: any, value: any) - The 'newindex' field in the metatable. If param is true, field is missing. If param is false or nil, field is default error.
4. meta?: any - The 'metatable' field in the metatable. If param is true, field is missing. If param is false or nil, field is default string.
### Returns:
1. table - proxy for `table`

## shift
Changes indexes of every value of `table` by `distance`
### Params:
1. table: table - table whose values are to be shifted
2. distance: integer - number of positions to which values need to be shifted

## slice
Returns a new table with every `step` value from `table` with indexes between `start` and `end_`
### Params:
1. table: table - table to be sliced
2. start?: integer - start index (default: 1)
3. end_?: integer - end index (default: `#table`)
4. step?: integer - slicing step (default: 1)
### Returns:
1. table - slice of `table`

## unpack
Returns values from `table`
### Params:
1. table: table - table to be unpacked
2. mode?:
    * "i" - Returns elements with integer key>0. It is equivalent to `table.unpack`
    * "a" (default) - Returns elements with any key
### Returns:
1. ...: any - values from `table`

# Constants
## VERSION
Current module version ("2.1.1")