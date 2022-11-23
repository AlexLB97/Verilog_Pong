`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2021 10:41:09 AM
// Design Name: 
// Module Name: generate_ball
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


module generate_ball (
	input i_clk,
	input [15:0] i_keycode,
	input i_v_sync_negedge,
	input [9:0] i_v_count,
	input [9:0] i_h_count,
	input [9:0] right_paddle_y,
	input [9:0] left_paddle_y,
	output reg o_draw_ball
);
	
	parameter BALL_RADIUS = 10;
	parameter NOT_MOVING = 3'b000;
	parameter DOWN_LEFT= 3'b001;
	parameter UP_LEFT = 3'b010;
	parameter UP_RIGHT = 3'b011;
	parameter DOWN_RIGHT = 3'b100;
	parameter START_MOVING = 8'h29;
	parameter X_START = 320;
	parameter Y_START = 240;
	parameter SCREEN_HEIGHT = 479;
	parameter SCREEN_WIDTH = 639;
	parameter BALL_SPEED = 1000000;
	parameter TOP_BOUND = BALL_RADIUS;
	parameter BOTTOM_BOUND = SCREEN_HEIGHT - BALL_RADIUS;
	parameter RIGHT_BOUND = SCREEN_WIDTH - BALL_RADIUS;
	parameter LEFT_BOUND = BALL_RADIUS;
	
	
	reg [2:0] r_current_state = NOT_MOVING, r_next_state = NOT_MOVING;	
	reg [20:0] r_movement_counter = 0;
	reg [9:0] r_intermediate_x = X_START, r_intermediate_y = Y_START, r_ball_x = X_START, r_ball_y = Y_START;
	reg [9:0] r_ball_top = Y_START - BALL_RADIUS, r_ball_bottom = Y_START + BALL_RADIUS, r_ball_left = X_START - BALL_RADIUS, r_ball_right = X_START + BALL_RADIUS;
	reg [9:0] right_paddle_top, right_paddle_bottom, left_paddle_bottom, left_paddle_top;
	reg [29:0] r_ball_speed_counter = 0;
	reg [20:0] r_ball_speed = BALL_SPEED;

	//next state logic
	always @(posedge i_clk)
	begin
		r_current_state <= r_next_state;
		if (right_paddle_y > 50)
		    right_paddle_top <= right_paddle_y - 50;
        else
            right_paddle_top <= 0;  
            
		if (left_paddle_y > 50)
		    left_paddle_top <= left_paddle_y - 50;
        else
            left_paddle_top <= 0;
            
        right_paddle_bottom <= right_paddle_y + 50;
		left_paddle_bottom <= left_paddle_y + 50;
	end
	
	
	always @(posedge i_clk)
	begin
	   if (r_ball_speed > 300000 && ~(r_current_state == NOT_MOVING))
	   begin
	       if (r_ball_speed_counter < 1000000000)
	           r_ball_speed_counter <= r_ball_speed_counter + 1;
	       else if (r_ball_speed_counter == 1000000000)
	       begin
	           r_ball_speed_counter <= 0;
	           r_ball_speed <= r_ball_speed - 100000;
	       end
	       else
	           r_ball_speed <= r_ball_speed;
       end
       else if (r_current_state == NOT_MOVING)
       begin
           r_ball_speed <= BALL_SPEED;
           r_ball_speed_counter <= 0;
       end
       else
        r_ball_speed <= r_ball_speed;
           
	        
	end

	//next state logic
	
	//Next step: finish the edge detection for state logic and define the rest of the states
	//write the output logic for draw ball. See generate paddle logic for example.

	always @(posedge i_clk)
	begin
		case(r_current_state)
		
		NOT_MOVING:
        begin
            r_intermediate_x <= X_START;
            r_intermediate_y <= Y_START;
            if (i_keycode == START_MOVING)
                r_next_state <= DOWN_LEFT;
            else
                r_next_state <= NOT_MOVING;
        end
		
		DOWN_LEFT:
		begin
			if (r_intermediate_y == BOTTOM_BOUND && r_intermediate_x == 20)
			begin
                if (r_intermediate_y > left_paddle_top && r_intermediate_y < left_paddle_bottom)
                begin
                    r_next_state <= UP_RIGHT;
                    r_movement_counter <= 0;
				end
                else
                begin
                    r_intermediate_x <= r_intermediate_x - 1;
                    r_intermediate_y <= r_intermediate_y + 1;
                end
            end
				
			else if (r_intermediate_x == 20)
			begin
			    if (r_intermediate_y > left_paddle_top && r_intermediate_y < left_paddle_bottom)
			    begin			
                    r_next_state <= DOWN_RIGHT;
                    r_movement_counter <= 0;
				end
                else
                begin
                    r_intermediate_x <= r_intermediate_x - 1;
                    r_intermediate_y <= r_intermediate_y + 1;
                end
            end
			else if (r_intermediate_y == BOTTOM_BOUND)
				r_next_state <= UP_LEFT;
            else if (r_intermediate_x == 0)
            begin
                r_next_state <= NOT_MOVING;
                r_movement_counter <= 0;
            end
			else
				begin
				if (r_movement_counter < r_ball_speed)
				    r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter >= r_ball_speed)
				begin
					r_movement_counter <= 0;
					r_intermediate_x <= r_intermediate_x - 1;
					r_intermediate_y <= r_intermediate_y + 1;
				end
			end
		end
		
		DOWN_RIGHT:
		begin
			if (r_intermediate_y == BOTTOM_BOUND && r_intermediate_x == 619)
            begin
                if (r_intermediate_y > right_paddle_top && r_intermediate_y < right_paddle_bottom)
                begin
                    r_next_state <= UP_LEFT;
                    r_movement_counter <= 0;
                end
                else
                begin
                    r_intermediate_x <= r_intermediate_x + 1;
                    r_intermediate_y <= r_intermediate_y + 1;
                end
            end
			else if (r_intermediate_x == 619)
			begin
                if (r_intermediate_y > right_paddle_top && r_intermediate_y < right_paddle_bottom)
                begin
                    r_next_state <= DOWN_LEFT;
                    r_movement_counter <= 0;
                end
                else
                begin
                    r_intermediate_x <= r_intermediate_x + 1;
                    r_intermediate_y <= r_intermediate_y + 1;
                end
            end
			else if (r_intermediate_y == BOTTOM_BOUND)
				r_next_state <= UP_RIGHT;
				
            else if (r_intermediate_x > 629)
            begin
                r_next_state <= NOT_MOVING;
                r_movement_counter <= 0;
            end
			else
				begin
				if (r_movement_counter < r_ball_speed)
					r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter >= r_ball_speed)
				begin
					r_movement_counter <= 0;
					r_intermediate_x <= r_intermediate_x + 1;
					r_intermediate_y <= r_intermediate_y + 1;
				end
			end
		end
		
		UP_RIGHT:
		begin
			if (r_intermediate_y == TOP_BOUND && r_intermediate_x == 619)
            begin
                if (r_intermediate_y > right_paddle_top && r_intermediate_y < right_paddle_bottom)
                begin
                    r_next_state <= DOWN_LEFT;
                    r_movement_counter <= 0;
                end
                else
                begin
                    r_intermediate_x <= r_intermediate_x + 1;
                    r_intermediate_y <= r_intermediate_y - 1;
                end
            end
			else if (r_intermediate_x == 619)
			begin
                if (r_intermediate_y > right_paddle_top && r_intermediate_y < right_paddle_bottom)
                begin
                    r_next_state <= UP_LEFT;
                    r_movement_counter <= 0;
                end
                else
                begin
                    r_intermediate_x <= r_intermediate_x + 1;
                    r_intermediate_y <= r_intermediate_y - 1;
                end
            end
			else if (r_intermediate_y == TOP_BOUND)
				r_next_state <= DOWN_RIGHT;
            else if (r_intermediate_x > 629)
            begin
                r_next_state <= NOT_MOVING;
                r_movement_counter <= 0;
            end
			else
				begin
				if (r_movement_counter < r_ball_speed)
					r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter >= r_ball_speed)
				begin
					r_movement_counter <= 0;
					r_intermediate_x <= r_intermediate_x + 1;
					r_intermediate_y <= r_intermediate_y - 1;
				end
			end
		end
		
		UP_LEFT:
		begin 
			if (r_intermediate_y == TOP_BOUND && r_intermediate_x == 20)
            begin
                if (r_intermediate_y > left_paddle_top && r_intermediate_y < left_paddle_bottom)
                begin
                r_next_state <= DOWN_RIGHT;
                r_movement_counter <= 0;
                end
                else
                begin
                    r_intermediate_x <= r_intermediate_x - 1;
                    r_intermediate_y <= r_intermediate_y - 1;
                end
            end
			else if (r_intermediate_x == 20)
            begin
                if (r_intermediate_y > left_paddle_top && r_intermediate_y < left_paddle_bottom)
                begin
                    r_next_state <= UP_RIGHT;
                    r_movement_counter <= 0;
                end
                else
                begin
                    r_intermediate_x <= r_intermediate_x - 1;
                    r_intermediate_y <= r_intermediate_y - 1;
                end
            end
			else if (r_intermediate_y == TOP_BOUND)
				r_next_state <= DOWN_LEFT;
            else if (r_intermediate_x < 10)
            begin
                r_next_state <= NOT_MOVING;
                r_movement_counter <= 0;
            end
			else
            begin
				if (r_movement_counter < r_ball_speed)
					r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter >= r_ball_speed)
				begin
					r_movement_counter <= 0;
					r_intermediate_x <= r_intermediate_x - 1;
					r_intermediate_y <= r_intermediate_y - 1;
				end
			end
		end
		endcase
	end
	
	always @(posedge i_clk)
	begin
		r_ball_top <= r_ball_y - BALL_RADIUS;
		r_ball_bottom <= r_ball_y + BALL_RADIUS;
		r_ball_left <= r_ball_x - BALL_RADIUS;
		r_ball_right <= r_ball_x + BALL_RADIUS;
		
		if (i_v_sync_negedge)
		begin
			r_ball_x <= r_intermediate_x;
			r_ball_y <= r_intermediate_y;
		end
		
		if (i_h_count > r_ball_left && i_h_count < r_ball_right 
			&& i_v_count > r_ball_top && i_v_count < r_ball_bottom)
        begin
			o_draw_ball <= 1;
        end
		else
			o_draw_ball <= 0;		
	end
	
	
	
	
endmodule
