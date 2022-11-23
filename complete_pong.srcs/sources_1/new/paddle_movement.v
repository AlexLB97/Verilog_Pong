`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2021 10:51:28 AM
// Design Name: 
// Module Name: paddle_movement
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


module paddle_movement (
    input i_clk,
    input [15:0] i_keycode,
    output reg [1:0] o_paddle_state = 0
);

    
    parameter NOT_MOVING = 2'b00;
    parameter MOVING_UP = 2'b01;
    parameter MOVING_DOWN = 2'b10;
    parameter P1_UP = 8'h00;
    parameter P1_DOWN = 8'h00;
    parameter KEY_RELEASE = 8'hF0;

    
    
    
    reg [1:0] current_state = NOT_MOVING;
    reg [1:0] next_state = NOT_MOVING;
    
    

    
    
    
    
    always @(posedge i_clk)
    begin
        current_state <= next_state;
    end
    
   
    always @(posedge i_clk)
    begin
        case (current_state)
        
        NOT_MOVING:
        begin
            if (i_keycode == {8'h00, P1_UP})
                next_state <= MOVING_UP;
            else if (i_keycode == {8'h00, P1_DOWN})
                next_state <= MOVING_DOWN;
            else
                next_state <= NOT_MOVING;
        end
        
        MOVING_UP: 
        begin
        if (i_keycode == {8'hF0, P1_UP})
            next_state <= NOT_MOVING;
        else
            next_state <= MOVING_UP;
        end
        
        MOVING_DOWN:
        begin
        if (i_keycode == {8'hF0, P1_DOWN})
            next_state <= NOT_MOVING;
        else
            next_state <= MOVING_DOWN;
        end
        
        endcase
    end
    
    
    
    always @(posedge i_clk)
    begin
        case(current_state)
            
            NOT_MOVING: 
            begin
            o_paddle_state <= NOT_MOVING;
            end
            
            MOVING_UP: 
            begin
            o_paddle_state <= MOVING_UP;
            end
            
            MOVING_DOWN: 
            begin
            o_paddle_state <= MOVING_DOWN;
            end
   
        endcase
    end
    
    
    
    
 endmodule
