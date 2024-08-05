# bacon-etl

## Synopsis

| Syntax | Semantic |
| :----------- | :------- |
| `npm run mainTask` | Save the result of a few important pre-defined queries to `Downloads` under `bacon-reports` at 19:00 every 24 hours |
| `npm run debug $QUERYSCRIPTNAME` | Print out a parameterized version of the response from the ODBC interface that queries the query given by `QUERYSCRIPTNAME` |
| `npm run 1q $QUERYSCRIPTNAME` | Save the CSV result of a query given by `QUERYSCRIPTNAME` to `Downloads` under `bacon-tables` |
| `npm run updateAnicerTableView $TABLENAME` | Write a "cleaned" version of the table given by `TABLENAME` to `Downloads` under `bacon-tables` |
| `npm run updateNonEmptyTableNames` | Write the result of a query to an Advantage data dictionary that filters all tables which don't contain any data to`Downloads` under `bacon-tables` |

## Notes

- Original script is present at [`1ca5ddbdd73aa059f1f5997d3eb2505ec2d0526e`](https://github.com/Amitron-Labs/bacon-etl/tree/1ca5ddbdd73aa059f1f5997d3eb2505ec2d0526e)
- Assign `QUERYSCRIPTNAME` to be the name of a query file present in `src/queries`, but not a path

### [Bacon Support](https://www.baconsoft.com/support1.htm)

- Company ID: AM492GSHJ3
- Email: tyson\@amitroncorp.com

### [Advantage Database Server](https://wiki.scn.sap.com/wiki/display/EIM/06+-+Advantage+Tech+Tips)

- [book](https://flylib.com/books/en/1.373.1/)

### View Production Database from a GUI

- Download 'Advantage Data Architect' v11.10 from Bacon support
- File \> Open Tables \> Dictionary
- Select 'AdJobSys\Dictionary\JobSys.add'
    1. At 'File(s)', authenticate with username `AdsSys`, password `jts007`
    2. Select a table
    3. Go to step 1
