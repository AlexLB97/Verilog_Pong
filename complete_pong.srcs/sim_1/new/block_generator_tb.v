`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2020 10:00:02 AM
// Design Name: 
// Module Name: block_generator_tb
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


module block_generator_tb();


    reg v_sync;
    reg i_clock_100MHz;
    reg [9:0] i_h_count;
    reg i_v_count;
    reg [7:0] i_keycode;
    wire o_draw_ball;
    
    
    
    block_generator uut (
        .v_sync(v_sync),
        .i_clock_100MHz(i_clock_100MHz),
        .i_h_count(i_h_count),
        .i_v_count(i_v_count),
        .i_keycode(i_keycode),
        .o_draw_ball(o_draw_ball)
        );




    always begin
        i_clock_100MHz = 0; #5;
        i_clock_100MHz = 1; #5;
        
    end
    
    
    
    always begin
        if (i_h_count < 800)
            i_h_count = i_h_count + 1; #20;
        else
            i_h_count = 0; #20;
    end


        
    always begin
        if (i_v_count < 480 && i_h_count == 480)
            i_v_count = i_v_count + 1;
        else if (i_v_count == 
        
    end    
        
    always begin
        v_sync = 1; #50;
        v_sync = 0; #10; 
    end
    
    
endmodule
