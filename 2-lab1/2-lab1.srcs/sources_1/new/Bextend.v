module Bextend(
    input [11:0] i,
    output [31:0] o
    );
    assign o={{19{i[11]}},i,1'b0};
endmodule