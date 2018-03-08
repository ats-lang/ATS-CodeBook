# Parsing for the CSV format

This example presents a way to parse a table in the
CSV format.

The function `csv_parse_line_nerr` in the npm-based package
*atscntrb-hx-csv-parse* parses a given string into a list of
substrings separated by COMMA (or another character chosen by
the user).

Let us use the name dframe (data-frame) to refer to a table
of the following format:

```
Date,Open,High,Low,Close,Adj Close,Volume
1985-10-01,110.620003,112.160004,110.565002,112.139999,112.139999,153160000
1985-10-02,112.139999,112.540001,110.779999,110.824997,110.824997,164640000
...
```

where the first row contains the name of each column. The function
`dframe_read_fileref` in the file *myread.dats* parses such a table
(contained in the file referred to by a given file handle) into a list
of gvhasbtbl-values, which is essentially a hashtable of gvalues
(declared in the file *$PATSHOME/libats/ML/SATS/gvalue.sats*).

Please find in *NDX100.dats* some code that parses the historic data
for NDX100 (NASDAQ 100).

If you have [tcc](https://bellard.org/tcc/) installed, you can simply
issue the following command-line:

```shell
bash ./NDX100.dats
```

to compile and then execute the code in *NDX100.dats*, effectively using
ATS as a scripting language!

Happy programming in ATS!!!
