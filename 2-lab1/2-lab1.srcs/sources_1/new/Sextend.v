
module Sextend(
    input [11:0] i,
    output [31:0] o
    );
    assign o={{20{i[11]}},i};
endmodule