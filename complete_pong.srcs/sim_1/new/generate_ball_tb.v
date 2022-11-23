`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2021 05:41:44 PM
// Design Name: 
// Module Name: generate_ball_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module generate_ball_tb();



reg i_clk;
reg [15:0] i_keycode;
reg i_v_sync_negedge;
reg [9:0] right_paddle_y = 240, left_paddle_y = 240;
//reg [9:0] i_v_count, i_h_count;




generate_ball uut (
    .i_clk(i_clk),
    .i_keycode(i_keycode),
    .i_v_sync_negedge(i_v_sync_negedge)
);




always begin
    i_clk = 0; #5;
    i_clk = 1; # 5;
    
end

always begin
    i_v_sync_negedge = 0; #750000;
    i_v_sync_negedge = 1; #10;
end

always begin
    i_keycode = 16'h29; #20;
    i_keycode = 16'h00; #1000000000;
    
end


endmodule
