using Arrow, CSV, DataFrames, Dates, PooledArrays

const DATADIR = "./ldt_raw";

const SKIPLIST = [  # list of redundant or questionable files
    "9999.LDT",
    "793DATA.LDT",
    "Data999.LDT",
    "Data1000.LDT",
    "Data1010.LDT",
    "Data1016.LDT",
];

"""
    checktbuf!(buf::IOBuffer)

Return a DataFrame of the contents of `buf` assuming it contains trial information
"""
function checktbuf!(buf)
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

"""
    checkhbuf!(buf::IOBuffer, types::Vector{DataType}, missingstring="")

Return a DataFrame from CSV.File on `buf` with optional arguments `types` and `missingstring`

`buf` is empty upon return
"""
checkhbuf!(buf,types,missingstring="") = DataFrame(CSV.File(take!(buf);types,missingstring))

"""
    skipblanks(strm)

Skip blank lines in strm returning the first non-blank line with `keep=true`
"""
function skipblanks(strm)
    ln = readline(strm; keep=true)
    while isempty(strip(ln))
        ln = readline(strm; keep=true)
    end
    return ln
end

"""
    parse_ldt_file(fnm, dir=DATADIR)

Return a NamedTuple of `fnm` and 6 DataFrames from LDT file with name `fnm` in directory `dir`
"""
function parse_ldt_file(fnm, dir=DATADIR)
    @show fnm
    global univ, sess1, sess2, subj, ncor, hlth
    hdrbuf, trialbuf = IOBuffer(), IOBuffer()        # in-memory "files"
    univhdr = "Univ,Time,Date,Subject,DOB,Education" # occurs in line 1 and after seq 2000
    subjhdr = "Subject,Gender,Task,MEQ,Time,Date"    # marks demog block at file end
    ncorhdr = "numCorrect,rawScore,vocabAge,shipTime,readTime"
    hlthhdr = "presHealth,pastHealth,vision,hearing,firstLang"
    keep = true                                      # pass as named argument to readline
    strm = open(joinpath(dir, fnm), "r")
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
            univ = checkhbuf!(hdrbuf, [Int8, String, String, Int16, String, Int8])
            sess1 = checktbuf!(trialbuf)
        elseif startswith(ln, subjhdr)
            sess2 = checktbuf!(trialbuf)
            write(hdrbuf, ln)
            write(hdrbuf, readline(strm; keep))
            subj = checkhbuf!(
                hdrbuf,
                [Int16, String, String, Float32, String, String],
                ["","00:00:00","00-00-0000", "x"],
            )
            ln = skipblanks(strm)
            startswith(ln, ncorhdr) || throw(ArgumentError("Expected $ncorhdr, got $ln"))
            write(hdrbuf, ln)
            write(hdrbuf, readline(strm; keep))
            ncor = checkhbuf!(hdrbuf, [Int8, Int8, Float32, Int8, Float32], "999")
            ln = skipblanks(strm)
            startswith(ln, hlthhdr) || throw(ArgumentError("Expected $hlthhdr, got $ln"))
            write(hdrbuf, ln)
            write(hdrbuf, readline(strm; keep))
            hlth = checkhbuf!(hdrbuf, [Int8, Int8, Int8, Int8, String], ["","Unknown","-1"])
            break
        else
            write(trialbuf, ln)
        end
        ln = readline(strm; keep)
    end
    close(strm)
    return (; fnm, univ, sess1, sess2, subj, ncor, hlth)
end

dfs =
[parse_ldt_file(nm) for nm in filter(∉(SKIPLIST), filter(endswith(r"LDT"i), readdir(DATADIR)))];

"""
    checksubj(nt::NamedTuple)

Return the subject number after checking for consistency in the three different places it is stored,
"""
function checksubj(nt)
    subjno = only(unique(nt.univ.Subject))
    return only(nt.subj.Subject) == subjno ? subjno : nothing
end

"""
    getDOB(nt::NamedTuple)

Return the unique element of `nt.univ.DOB` or both elements separated by `'|'`
"""
getDOB(nt) = join(unique(nt.univ.DOB), '|')

"""
    getEduc(nt::NamedTuple)

Return the maximum value of `nt.univ.Education`.

The value was supposed to be years of education but some are recorded as years of university,
which is why the maximum is returned.
"""
getEduc(nt) = maximum(nt.univ.Education)

"""
    parseDate(dfrow::DataFrameRow)

Return a `DateTime` from parsing the `Date` and `Time` fields where the date is "mm-dd-yyyy"
"""
function parseDate(dfrow)
    return passmissing(DateTime)(
        passmissing(string)(dfrow.Date, 'T', dfrow.Time),
        dateformat"mm-dd-yyyyTH:M:S",
        )
end 

subjtbl = sort!(
    DataFrame(
        [
            (
                subj = checksubj(nt),
                univ = only(unique(nt.univ.Univ)),
                sex = only(nt.subj.Gender),
                MEQ = only(nt.subj.MEQ),
                vision = only(nt.hlth.vision),
                hearing = only(nt.hlth.hearing),
                educatn = getEduc(nt),
                ncorrct = only(nt.ncor.numCorrect),
                rawscor = only(nt.ncor.rawScore),
                vocabAge = only(nt.ncor.vocabAge),
                shipTime = only(nt.ncor.shipTime),
                readTime = only(nt.ncor.readTime),
                preshlth = only(nt.hlth.presHealth),
                pasthlth = only(nt.hlth.pastHealth),
                S1start = parseDate(first(nt.univ)),
                S2start = parseDate(last(nt.univ)),
                MEQstrt = parseDate(only(nt.subj)),
                filename = nt.fnm,
                frstLang = only(nt.hlth.firstLang),
            ) for nt in dfs
        ]
    ),
    :subj
)

subjtbl.sex = PooledArray(subjtbl.sex; compress=true, signed=true);
subjtbl.frstLang = PooledArray(subjtbl.frstLang; compress=true, signed=true);
subjtbl.rawscor = [(ismissing(x) || x < 3) ? missing : x for x in subjtbl.rawscor];
subjtbl.ncorrct = [(ismissing(x) || x < 3) ? missing : x for x in subjtbl.ncorrct];
subjtbl.vocabAge = [(ismissing(x) || x < 3 || x > 25) ? missing : x for x in subjtbl.vocabAge];
subjtbl.readTime = [(ismissing(x) || x < 0) ? missing : x for x in subjtbl.readTime];
subjtbl.MEQ = [(ismissing(x) || x < 3) ? missing : x for x in subjtbl.MEQ];
Arrow.write("./arrow/subjtbl.arrow", subjtbl; compress=:zstd)

"""
    freqtbl(nm::Symbol, df::DataFrame)

Return a DataFrame with the sorted unique values of df.nm and their frequency
"""
freqtbl(nm, df) = sort(combine(groupby(df, nm), nrow => :n), nm)

function trtbl(nt)
    subj, sess1, sess2 = checksubj(nt), nt.sess1, nt.sess2
    df = select(append!(copy(sess1), sess2), 1 => (x -> subj) => :subj, :seq, [:itemgrp, :wrd] => ((x,y) -> 2 * x - y) => :itemno, :acc, :rt)
    df.s2 = append!(repeat([false], nrow(sess1)), repeat([true], nrow(sess2)))
    return df
end 
    

