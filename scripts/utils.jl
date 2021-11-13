"""
asDate(st::String)

Try to parse `st` as a `Date` in the 20th century from one of the many weird
and wonderful formats used by those recording the data.  `fnm` is used in error
messages.
"""
function asDate(st, fnm)
    dd = tryparse(
        Date,
        replace(     # convert `\` and `/` as delimiters to `-` and strings of digits
            st,
            '/' => '-',
            '\\' => '-',
            r"^(\d{1,2})(\d{2})(\d{2})$" => s"\1-\2-19\3",
            r"^(\d{1,2})(\d{2})(\d{4})$" => s"\1-\2-\3",
        ),
        dateformat"mm-dd-yyyy",
    )
    isnothing(dd) && throw(ArgumentError("Can't parse $st from $fnm as a Date"))
    if dd < Date("1000-01-01")
        dd += Year(1900)
    end
    dd
end

BoolOrMsng(k::Number) = iszero(k) ? false : (isone(k) ? true : missing)

"""
    checkhbuf!(buf::IOBuffer, types::Vector{DataType}, missingstring="")

Return a DataFrame from CSV.File on `buf` with optional arguments `types` and `missingstring`

`buf` is empty upon return
"""
checkhbuf!(buf,types,missingstring="") = DataFrame(CSV.File(take!(buf);types,missingstring))

"""
    checksubj(nt::NamedTuple)

Return the subject number after checking for consistency in the three different places it is stored,
"""
function checksubj(nt)
    subjno = only(unique(nt.univ.Subject))
    return only(nt.subj.Subject) == subjno ? subjno : nothing
end

"""
    freqtbl(df::DataFrame, nm::Symbol)

Return a DataFrame with the sorted unique values of df.nm and their frequency
"""
freqtbl(df, nm) = sort(combine(groupby(df, nm), nrow => :n), nm)

"""
getEduc(nt::NamedTuple)

Return the maximum value of `nt.univ.Education`.

The value was supposed to be years of education but some are recorded as years of university,
which is why the maximum is returned.
"""
getEduc(nt) = maximum(nt.univ.Education)

"""
parseDateTime(dfrow::DataFrameRow)

Return a `DateTime` from parsing the `Date` and `Time` fields where the date is "mm-dd-yyyy"
"""
function parseDateTime(dfrow)
    return passmissing(DateTime)(
        passmissing(string)(dfrow.Date, 'T', dfrow.Time),
        dateformat"mm-dd-yyyyTH:M:S",
        )
end

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
