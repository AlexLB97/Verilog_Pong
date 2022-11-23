`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2020 09:23:18 AM
// Design Name: 
// Module Name: create_paddle
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


module create_paddle(
    input [7:0] i_keycode,
    input i_v_sync,
    input i_clock_100MHz,
    input [9:0] i_h_count,
    input [9:0] i_v_count,
    output reg o_draw_paddle
    );
    
    
    

    reg [9:0] next_y;
    reg y_move_down = 1;
    reg [9:0] paddle_right, paddle_left, paddle_top, paddle_bottom;
    reg position_defined = 0;
    reg [9:0] current_x, current_y;
    reg [7:0] prev_keycode;
    reg currently_moving;
    
    
    parameter X_START = 320;
    parameter Y_START = 240;
    parameter PADDLE_WIDTH = 10;
    parameter PADDLE_HEIGHT = 60;
    parameter Y_MOVE = 1;
    parameter X_MOVE = 1;
    parameter WIDTH = 640;
    parameter HEIGHT = 480;
    parameter MOVE_UP = 8'h23;
    parameter MOVE_DOWN = 8'h1B;
    parameter KEY_RELEASE = 8'hF0;
    
    
    
    always @(i_keycode)
    begin
        prev_keycode <= i_keycode;
        if (i_keycode == MOVE_UP && prev_keycode != KEY_RELEASE && prev_keycode && ~currently_moving)
        begin
            y_move_down <= 0;
            currently_moving <= 1;
        end
        else if (i_keycode == MOVE_DOWN && prev_keycode != KEY_RELEASE && ~currently_moving)
        begin
            y_move_down = 1;
            currently_moving <= 1;
        end
        else if (currently_moving && ((y_move_down && prev_keycode == KEY_RELEASE && i_keycode == MOVE_DOWN) || (~y_move_down && prev_keycode == KEY_RELEASE && i_keycode == MOVE_UP)))
        begin
            currently_moving <= 0;
        end
    end
    
    
    always @(negedge i_v_sync)
    begin
    paddle_top <= current_y - (PADDLE_HEIGHT/2);
    paddle_bottom <= current_y + (PADDLE_HEIGHT/2);
    paddle_left <= current_x - (PADDLE_WIDTH / 2);
    paddle_right <= current_x + (PADDLE_WIDTH / 2);
        if (~position_defined)
        begin
            current_x <= X_START;
            current_y <= Y_START;
            position_defined <= 1;
            next_y <= Y_START; 
        end
        else
        begin
            current_y <= next_y;
            if (y_move_down && currently_moving)
            begin
                if (next_y + Y_MOVE >= (HEIGHT - PADDLE_HEIGHT/2))
                    next_y <= next_y;
                else
                    next_y <= next_y + Y_MOVE;
            end
            else
            begin
                if (next_y - Y_MOVE <= PADDLE_HEIGHT / 2)
                    next_y <= next_y;
                else
                    next_y <= next_y - Y_MOVE;
            end
        end
     
    end
    

    
   
    
   always @(posedge i_clock_100MHz)
    begin

    if (i_h_count > paddle_left && i_h_count < paddle_right && i_v_count > paddle_top  && i_v_count < paddle_bottom)
        o_draw_paddle <= 1'b1;     
    else
        o_draw_paddle = 1'b0;
    end
    
    
    
    
    
    
    
endmodule
