## LDT Files

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
- 620DATA.LDT is missing most of the information in the demographic block.
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
- After accounding for differences in formatting the DOB and doing some editing, there were six files (405DATA.LDT, 510DATA.LDT, Data1066.LDT, Data2087.LDT, Data2328.LDT, and Data3034.LDT) with inconsistently recorded DOB entries.  Used the DOB from the second session.


## NMG Files
- Data3929.NMG is missing a header for the second session; instead it has a duplicate record for seq number 1500.  Created a ficticious header with the same time, next day.
- Data3929.NMG is corrupt at sequence number 1241.  Number 1242 can be salvaged but not 1241.
- Data3929.NMG is corrupt around line 2002 - a few lines were repeated
- 220data.nmg, 259DATA.nmg, Data7146.NMG have spurious headers for the second session
    + recommend removing 4 lines: a blank line, a line of = signs, and the spurious header
- 42DATA.NMG, 308DATA.NMG, 74DATA.NMG, 75DATA.NMG, and Data4110.NMG have inconsistent DOB (called "Age" in the NMG files).  Use the second one. (74DATA.NMG and 75DATA.NMG seem to have exchanged DOB.)
- File 322DATA.NMG is a copy of Data2815.NMG, 323DATA.NMG is a copy of Data2816.NMG, ..., 328DATA.NMG is a copy of Data2821.NMG
- Files 12DATA.NMG and Data4140.NMG both have subj=12 but different universities (1 and 5)
- Files Data4100.NMG and Data7146.NMG have subj=51 but different universities (1 and 5)
- Files 61DATA.NMG and Data4110.NMG have subj=61 but different universities (1 and 5)
- Files 283DATA.NMG and Data7147.NMG have subj=283 and univ=5 but different demographics
- Files 349DATA.NMG and Data3872.NMG have subj=349 but different univ (5 and 6)
- Files 360DATA.NMG and Data3882.NMG have subj=360 but different univ (5 and 6)
- Files 362DATA.NMG and Data3884.NMG have subj=362 but different univ (5 and 6)
- Files 363DATA.NMG and Data3886.NMG have subj=363 but different univ (5 and 6)
- Files 366DATA.NMG and Data3894.NMG differ only in format of DOB.  Add Data3894.NMG to skip list.
- Files 371DATA.NMG and Data3892.NMG have subj=371 and univ=6 but different demographics
- Files 381DATA.NMG and Data3911.NMG have subj=381 but different univ (5 and 6)
- Files 383DATA.NMG and Data3912.NMG have subj=383 but different univ (5 and 6)
- Files 385DATA.NMG and Data3930.NMG have subj=385 but different univ (5 and 6)
- Files 388DATA.NMG and Data4210.NMG have subj=388 but different univ (5 and 6)
- Files 399DATA.NMG and Data4118.NMG have subj=399 but different univ (5 and 6)
- Files 400DATA.NMG and Data4119.NMG have subj=400 but different univ (5 and 6)
- Files 449DATA.NMG and Data5255.NMG have subj=449 but different univ (5 and 6)


## Items.csv file
- Item.csv contains missing value codes as "#" and embedded commas in quoted number fields
- CSV.File(fnm; missingstring="#") returns those number fields containing commas as strings
    + use `replace` followed by parsing as `Int` then conversion to smaller Int sizes according to the extrema
- After a `leftjoin` it helps to use `disallowmissing!(frm; error=false)` b/c columns from the second argument (i.e. the table on the right) must allow for missing values in the result.
