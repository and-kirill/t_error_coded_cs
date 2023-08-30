function Ka_series = get_rs_ka()
Ka_series = unique([
    10:20:190, ... Basic sequence
    50:50:200, ... To fill the table with coding rate parameters
    210:5:225  ... The tail of the curve with more accurate statistics
    ]);
end
