- 9999.LDT is a copy of 101DATA.LDT
    + recommend removing 9999.LDT
- 739DATA.LDT is almost a copy of Data3544.LDT (dob for second session is in a different format)
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
- 426DATA.LDT, Data1004.LDT, Data1009.LDT, Data1018.LDT, Data2042.LDT, Data2446.LDT are missing all the information in the demographic block.  Change the date of the MEQ test to 01-01-0000 so that it can be parsed as a Date.
- 620DATA.LDT is missing most of the information in the demographic block.   Change the date of the MEQ test to 01-01-0000 so that it can be parsed as a Date.
- Data1988.LDT is corrupt at sequence number 1744.  Sequence number 1745 can be salvaged by inserting a newline but probably not 1744 (response time is incomplete).
- Data1988.LDT is missing the header for the second session.
- Data3572.LDT is corrupt at sequence number 1749.  Sequence number 1750 can be salvaged by insterting a newline but not 1749
- The Accuracy field in the LDT files contains values other than 0 or 1