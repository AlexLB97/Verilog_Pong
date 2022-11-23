`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2021 10:36:10 AM
// Design Name: 
// Module Name: PS2_receiver
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




module PS2_receiver(
    input i_clk,
    input i_keyboard_data,
    input i_filtered_clock,
    output reg [15:0] out_code = {8'hF0, 8'h1B}
    );
    
    parameter IDLE = 0;
    parameter RX = 1;

    reg current_state = IDLE;
    reg next_state = IDLE;
    
    reg [3:0] bit_count = 10;
    reg [9:0] incoming_data = 10'b000000000;
    reg data_done;
    reg [15:0] o_keycode = 0;
    reg cur_clock_val, prev_clock_val;
    wire neg_edge;
    
    always @(posedge i_clk)
    begin
        prev_clock_val <= cur_clock_val;
        cur_clock_val <= i_filtered_clock;
        current_state <= next_state;
    end
    
    assign neg_edge = prev_clock_val && ~cur_clock_val;
    
    always @(posedge i_clk)
    begin
    
    case(current_state)
        
        IDLE:
        begin
            bit_count <= 9;
            data_done <= 0;

            if (neg_edge)
            begin
            if (o_keycode == {8'hF0, 8'h00})
                o_keycode <= o_keycode;
            else
                o_keycode <= 0;
            next_state <= RX;
            end
        end
        
        
        
        RX:
        begin
            if (neg_edge)
            begin
                if (bit_count > 0)
                begin
                    incoming_data <= {i_keyboard_data, incoming_data[9:1]};
                    bit_count <= bit_count - 1;
                end
                else
                begin
                    next_state <= IDLE;
                    if (incoming_data[8:1] == 8'hF0)
                    begin
                        o_keycode[15:8] <= incoming_data[8:1];
                        incoming_data <= 0;
                    end
                    else
                    begin
                        o_keycode[7:0] <= incoming_data[8:1];
                        incoming_data <= 0;
                        data_done <= 1;
                    end
                end
            end
        end
    endcase   
    end
    
    always @(i_clk)
    begin
        if(data_done)
            out_code <= o_keycode;
    end

endmodule