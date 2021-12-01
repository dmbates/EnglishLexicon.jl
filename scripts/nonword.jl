# incorporate information from nonword table into the ldt_item table
using Arrow, Chain, DataFrameMacros, DataFrames

ldt_item_char = @chain "./arrow/nmg_item.arrow" begin
    Arrow.Table()   # read the Table
    DataFrame()     # convert to a DataFrame
    select(:item, :Ortho_N, :BG_Sum, :BG_Mean, :BG_Freq_By_Pos)
    append!(@chain "./arrow/NWI.arrow" begin
        Arrow.Table()
        DataFrame()
        select(:Word => :item, :Ortho_N, :BG_Sum, :BG_Mean, :BG_Freq_By_Pos)
    end)
    leftjoin(DataFrame(Arrow.Table("./arrow/ldt_item.arrow")); on=:item)
    disallowmissing!(error=false)
    sort(:itemno)
end

# Now this is written back to "./arrow/ldt_item.arrow"