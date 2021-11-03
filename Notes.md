- 9999.LDT is a copy of 101DATA.LDT
    + recommend removing 9999.LDT
- 793DATA.LDT is almost a copy of Data3544.LDT (dob for second session is in a different format)
    + recommend removing 793DATA.LDT
- Data4145.LDT to Data4148.LDT are confounded with Data999.LDT, Data1000.LDT, Data1010.LDT and Data1016.LDT
    + the Univ field is always 1
    + the Subj numbers are paired
    + the DOB is very different in the pairs; those in the Data4145.LDT sequence are consistent with the population
    + the cues and their order are the same in pairs
    + the response times are different
    + not sure what to do about these
    + for the time being skip Data999.LDT, Data1000.LDT, Data1010.LDT and Data1016.LDT
- 176DATA.LDT has a spurious header for the second session
    + recommend removing 4 lines: two blank lines and the spurious header
- Data3034.LDT also has a spurious header for the second session
    + recommend removing 4 lines: two blank lines and the spurious header
    + some care is needed because the second header has an invalid DOB and the first header has 234 years of education.  Changed the first header to 2 years of ed., deleted the second.
- Duplicate demographic blocks at the end of 404DATA.LDT, Data3034.LDT, 436DATA.LDT, 520DATA.LDT, Data1016.LDT, Data1634.LDT, Data1988.LDT
    + recommend using the last one, because we assume errors were corrected
- 426DATA.LDT, Data1004.LDT, Data1009.LDT, Data1018.LDT, Data2042.LDT, Data2446.LDT are missing all the information in the demographic block. Add missingstring entry to CSV.File call.
- 620DATA.LDT is missing most of the information in the demographic block.   Change the date of the MEQ test to 01-01-0000 so that it can be parsed as a Date.
- Data1988.LDT is corrupt at sequence number 1744.  Sequence number 1745 can be salvaged by inserting a newline but probably not 1744 (response time is incomplete).
- Data1988.LDT is missing the header for the second session.
- Data3572.LDT is corrupt at sequence number 1749.  Sequence number 1750 can be salvaged by insterting a newline but not 1749
- The Accuracy field in the LDT files contains values other than 0 or 1
- Data1065.LDT, 420DATA.LDT, and 431DATA.LDT have redundant session2 headers
- To comply with the subject ids on the query site the following changes should be made
    + in 1DATA.LDT     1 -> 261
    + in 2DATA.LDT     2 -> 262
    + in 392data.ldt   2 -> 392
    + in 3DATA.LDT     3 -> 263
    + in 4DATA.LDT     4 -> 264
    + in 5DATA.LDT     5 -> 265
    + in 6DATA.LDT     6 -> 266
    + in 8DATA.LDT     8 -> 268
    + in 9DATA.LDT     9 -> 269
    + in 10DATA.LDT   10 -> 270   # records from Data1237.LDT are not in CSV (Sub_ID = 10)
    + in 11DATA.LDT   11 -> 271
    + in 12DATA.LDT   12 -> 272
    + in 13DATA.LDT   13 -> 273
    + in 14DATA.LDT   14 -> 274
    + in 15DATA.LDT   15 -> 275
    + in 16DATA.LDT   16 -> 276
    + in 17DATA.LDT   17 -> 277
    + in 18DATA.LDT   18 -> 278
    + in 19DATA.LDT   19 -> 279
    + in 20DATA.LDT   20 -> 280
    + in 21DATA.LDT   21 -> 281
    + in 22DATA.LDT   22 -> 282
    + in 23DATA.LDT   23 -> 283
    + in 24DATA.LDT   24 -> 284
    + in 25DATA.LDT   25 -> 285
    + in 26DATA.LDT   26 -> 286
    + in 27DATA.LDT   27 -> 287
    + in 28DATA.LDT   28 -> 288
- Records from Data999.LDT, Data1000.LDT, Data1010.LDT and Data1016.LDT are not in the CSV file
_ CSV file is missing both sequence number 1744 and 1745 from Sub_ID == 756 (file Data1988.LDT)
_ CSV file is missing both sequence number 1749 and 1750 from Sub_ID == 772 (file Data3572.LDT)
