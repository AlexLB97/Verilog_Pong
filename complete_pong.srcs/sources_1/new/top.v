`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/31/2020 10:12:35 AM
// Design Name: 
// Module Name: top
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


module top(
    input i_keyboard_data,
    input i_keyboard_clock,
    input i_clock_100MHz,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output [1:0] r_right_paddle_state,
    output [1:0] r_left_paddle_state,
    output h_sync,
    output v_sync
    );
    
    wire filtered_clock;
    wire [15:0] r_keycode;
    wire w_clock_25MHz;
    wire [9:0] h_count, v_count;
    wire video_on;
    wire draw_ball;
    wire r_draw_right_paddle, r_draw_left_paddle;
//    wire [1:0] r_right_paddle_state, r_left_paddle_state;
    wire v_sync_negedge, v_sync_negedge_throwaway;
    wire [9:0] right_paddle_y, left_paddle_y;
    
    parameter PADDLE_ONE_X = 5;
    parameter PADDLE_TWO_X = 634;
    
    parameter PADDLE_ONE_MOVE_UP = 8'h23;
    parameter PADDLE_ONE_MOVE_DOWN = 8'h1B;
    parameter PL_UP = 8'h23;
    parameter PL_DOWN = 8'h1B;
    parameter PR_UP = 8'h42;
    parameter PR_DOWN = 8'h3B;
    parameter R_PADDLE_X = 634;
    
    
    
    
    keyboard_clock_filter U1 (
        .i_clk(i_clock_100MHz),
        .i_keyboard_clock(i_keyboard_clock),
        .o_filtered_clock(filtered_clock)
    );
    
    PS2_receiver U2 (
        .i_clk(i_clock_100MHz),
        .i_keyboard_data(i_keyboard_data),
        .i_filtered_clock(filtered_clock),
        .out_code(r_keycode)
    );
    
    
    main_clock_divider U4 (
        .clock_100MHz(i_clock_100MHz),
        .clock_25MHz(w_clock_25MHz)
        
    );
    
    
    syncs U3 (
        .clock_25MHz(w_clock_25MHz),
        .v_sync(v_sync),
        .h_sync(h_sync),
        .v_count(v_count),
        .h_count(h_count),
        .video_on(video_on)
    );
    

    paddle_movement #(.P1_UP(PR_UP), .P1_DOWN(PR_DOWN)) U7 (
        .i_clk(i_clock_100MHz),
        .i_keycode(r_keycode),
        .o_paddle_state(r_right_paddle_state)
    
    );
    
    paddle_movement #(.P1_UP(PL_UP), .P1_DOWN(PL_DOWN)) U8 (
        .i_clk(i_clock_100MHz),
        .i_keycode(r_keycode),
        .o_paddle_state(r_left_paddle_state)
    
    );
    
    
    paddle_control #(.PADDLE_X(R_PADDLE_X)) U9 (
        .i_clk(i_clock_100MHz),
        .i_paddle_move(r_right_paddle_state),
        .i_h_count(h_count),
        .i_v_count(v_count),
        .i_v_sync(v_sync),
        .o_paddle_y(right_paddle_y),
        .o_draw_paddle(r_draw_right_paddle),
        .o_v_sync_negedge(v_sync_negedge)
    );
    
    paddle_control U10 (
        .i_clk(i_clock_100MHz),
        .i_paddle_move(r_left_paddle_state),
        .i_h_count(h_count),
        .i_v_count(v_count),
        .i_v_sync(v_sync),
        .o_paddle_y(left_paddle_y),
        .o_draw_paddle(r_draw_left_paddle),
        .o_v_sync_negedge(v_sync_negedge_throwaway)
    );
    
    
    generate_ball U11 (
        .i_clk(i_clock_100MHz),
        .i_keycode(r_keycode),
        .i_v_sync_negedge(v_sync_negedge),
        .right_paddle_y(right_paddle_y),
        .left_paddle_y(left_paddle_y),
        .i_v_count(v_count),
        .i_h_count(h_count),
        .o_draw_ball(draw_ball)
    );
    
    draw_screen U6 (
        .i_clk(i_clock_100MHz),
        .i_video_on(video_on),
        .i_draw_ball(draw_ball),
        .i_draw_left_paddle(r_draw_left_paddle),
        .i_draw_right_paddle(r_draw_right_paddle),
        .o_red(red),
        .o_green(green),
        .o_blue(blue)
        
    );

    
    
endmodule
