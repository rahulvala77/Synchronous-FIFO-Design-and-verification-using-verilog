module fifo_sync( input clk,rst,wr,rd,
                 input [7:0] data_in,
                output reg empty, almost_empty,almost_full,full,
                 output reg [7:0] data_out);
  
  reg [7:0] mem[32];
  reg [4:0] wptr=0;
  reg [4:0] rptr=0;
  reg [5:0] count=0;
  
  always @(posedge clk)begin
    if(rst == 1'b1) begin
      data_out <= 0;
      wptr <= 0;
      rptr <= 0;
      count <= 0;
      for(int i=0; i<32; i=i+1)begin
        mem[i] <=0;
      end
    end
    else begin
      if((wr == 1'b1)&&(full == 1'b0))begin
        mem[wptr] <= data_in;
        wptr <=wptr+1;
        count <= count + 1;
      end
      if((rd==1'b1)&&(empty ==1'b0))begin
        data_out <= mem[rptr];
        rptr<=rptr+1;
        count<=count-1;
        end
     end
    end
                        
                        assign empty        = (count == 0) ? 1'b1:1'b0;                    
                        assign full         = (count == 32) ? 1'b1:1'b0; 
                        assign almost_empty = (count == 1) ? 1'b1:1'b0; 
                        assign almost_full  = (count == 31) ? 1'b1:1'b0; 
endmodule
