# EnglishLexicon.jl
Julia code for processing data files in the English Lexicon Project

As stated in https://osf.io/n63s2/wiki/home/

> The English Lexicon Project is a multiuniversity effort to provide a standardized behavioral and descriptive data set for 40,481 words and 40,481 nonwords. It is available via the Internet at elexicon.wustl.edu. Data from 816 participants across six universities were collected in a lexical decision task (approximately 3400 responses per participant), and data from 444 participants were collected in a speeded naming task (approximately 2500 responses per participant).

The trial-level data are available in two `.zip` files; https://osf.io/eu5ca/ and https://osf.io/598st/.
There are some inconsistencies in these data files, such as repeated subject numbers at different universities - see `Notes.md` for documentation on these.

The patch files, `ldt.patch` and `nmg.patch`, can be applied to Version 1 of the zip archives to produce the revised directories present in `ldt_raw.zip` and `nmg_raw.zip` in this repository.
For example, to apply the patch to the nmg_raw.zip file available as https://osf.io/598st/download?version=1, unzip the archive in a directory `./nmg_raw/`, cd to `./nmg_raw/` and run
```
patch -s -p1 < ../nmg.patch
```

It is easier just to download the revised zip files from this repository - the patch files are provided to document the changes in the data files.

The `arrow` directory contains compressed data frames in [Arrow](https://arrow.apache.org) file format.
There are 3 data frames for each experiment, a `trial` table, an `item` table and a `subject` table.
To obtain a data frame for analysis these would be combined in a left join from the trial table with both the item and subject tables.
Julia code to do this is at the beginning of `./scripts/simple_model.jl`.

I would give R code using the `arrow` and `dplyr` packages except that I am having difficulty installing a fully-featured version of the `arrow` package on a Linux system.

In the `scripts` directory, files `ldt_extract.jl` and `nmg_extract.jl` create the arrow files from the raw trial-level data.  Note that each of these scripts defines a `SKIPLIST` of `.LDT` or `.NMG` files to be skipped because they contain repeated subject IDs that we cannot otherwise resolve.