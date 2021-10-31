using CSV, DataFrames

const SKIPLIST = [  # list of redundant or questionable files
    "9999.LDT",
    "793DATA.LDT",
    "Data999.LDT",
    "Data1000.LDT",
    "Data1010.LDT",
    "Data1016.LDT",
    "Data1988.LDT",
]

function checktbuf(buf)
    return(
        DataFrame(
            CSV.File(
                take!(buf);          # extract contents of and empty buf
                header=[:seq, :itemgrp, :wrd, :acc, :rt, :item],
                comment="=",
                types=[Int16, Int32, Bool, Int8, Int16, String],
            )
        )
    )
end

checkhbuf(buf, types) = DataFrame(CSV.File(take!(buf); types))

function skipblanks(strm)
    ln = readline(strm; keep=true)
    while isempty(strip(ln))
        ln = readline(strm; keep=true)
    end
    return ln
end

function parse_ldt_file(fnm)
    @show fnm
    global univ, sess1, sess2, subj, ncor, hlth
    hdrbuf, trialbuf = IOBuffer(), IOBuffer()        # in-memory "files"
    univhdr = "Univ,Time,Date,Subject,DOB,Education" # occurs in line 1 and after seq 2000
    subjhdr = "Subject,Gender,Task,MEQ,Time,Date"    # marks demog block at file end
    ncorhdr = "numCorrect,rawScore,vocabAge,shipTime,readTime"
    hlthhdr = "presHealth,pastHealth,vision,hearing,firstLang"
    keep = true                                      # pass as named argument to readline
    strm = open(fnm, "r")
    ln = readline(strm; keep)
    if !startswith(ln, univhdr)
        throw(ArgumentError("$fnm does not start with expected header"))
    end
    write(hdrbuf, ln)
    write(hdrbuf, readline(strm; keep))
    ln = readline(strm; keep)
    while true     # loop over lines in file
        if startswith(ln, univhdr)   # header for session 2
            write(hdrbuf, readline(strm; keep))   # second line of univ data
            univ = checkhbuf(hdrbuf, [Int8, String, String, Int16, String, Int16])
            sess1 = checktbuf(trialbuf)
        elseif startswith(ln, subjhdr)
            sess2 = checktbuf(trialbuf)
            write(hdrbuf, ln)
            write(hdrbuf, readline(strm; keep))
            subj = checkhbuf(hdrbuf, [Int16, String, String, Float32, String, String])
            ln = skipblanks(strm)
            startswith(ln, ncorhdr) || throw(ArgumentError("Expected $ncorhdr, got $ln"))
            write(hdrbuf, ln)
            write(hdrbuf, readline(strm; keep))
            ncor = checkhbuf(hdrbuf, [Int16, Int16, Float32, Int16, Float32])
            ln = skipblanks(strm)
            startswith(ln, hlthhdr) || throw(ArgumentError("Expected $hlthhdr, got $ln"))
            write(hdrbuf, ln)
            write(hdrbuf, readline(strm; keep))
            hlth = checkhbuf(hdrbuf, [Int8, Int8, Int8, Int8, String])
            break
        else
            write(trialbuf, ln)
        end
        ln = readline(strm; keep)
    end
    close(strm)
    return (; fnm, univ, sess1, sess2, subj, ncor, hlth)
end

const DATADIR = "./ldt_raw-1";

for nm in filter(∉(SKIPLIST), filter(endswith(r"LDT"i), readdir(DATADIR)))
    parse_ldt_file(joinpath(DATADIR, nm))
end