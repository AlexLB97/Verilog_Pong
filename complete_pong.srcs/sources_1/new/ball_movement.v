module ball_movement(
	input i_clk,
	input [15:0] i_keycode,
	input i_v_sync_negedge,
	input [9:0] i_v_count,
	input [9:0] i_h_count,
	output o_draw_ball
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
	parameter BALL_SPEED = 1500000;
	
	
	reg r_current_state = NOT_MOVING, r_next_state = NOT_MOVING;	
	reg [20:0] r_movement_counter = 0;
	reg [9:0] r_intermediate_x, r_intermediate_y, r_ball_x, r_ball_y;
	reg [9:0] r_ball_top, r_ball_bottom, r_ball_left, r_ball_right;

	//next state logic
	always @(posedge i_clk)
	begin
		r_current_state <= r_next_state;
	end

	//next state logic
	
	//Next step: finish the edge detection for state logic and define the rest of the states
	//write the output logic for draw ball. See generate paddle logic for example.

	always @(posedge i_clk)
	begin
		case(r_current_state)
		
		NOT_MOVING:
		begin
			if (i_keycode == START_MOVING)
				r_next_state <= DOWN_LEFT;
			else
				r_next_state <= NOT_MOVING;
		end
		
		DOWN_LEFT:
		begin
			if (r_intermediate_y == SCREEN_HEIGHT - BALL_RADIUS)
				r_next_state <= UP_LEFT;
			else if (r_intermediate_x == BALL_RADIUS)
				r_next_state <= DOWN_RIGHT;
			else if (r_intermediate_y == (SCREEN_HEIGHT - BALL_RADIUS) && 
					r_intermediate_x == BALL_RADIUS)
				r_next_state <= UP_RIGHT;
			else
				begin
				if (r_movement_counter < BALL_SPEED)
					r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter == BALL_SPEED)
				begin
					r_movement_counter <= 0;
					r_intermediate_x <= r_intermediate_x - 1;
					r_intermediate_y <= r_intermediate_y + 1;
				end
			end
		end
		
		DOWN_RIGHT:
		begin
			if (r_intermediate_y == SCREEN_HEIGHT - BALL_RADIUS)
				r_next_state <= UP_RIGHT;
			else if (r_intermediate_x == SCREEN_WIDTH - BALL_RADIUS)
				r_next_state <= DOWN_LEFT;
			else if (r_intermediate_y == (SCREEN_HEIGHT - BALL_RADIUS) && 
					r_intermediate_x == SCREEN_HEIGHT - BALL_RADIUS)
				r_next_state <= UP_LEFT;
			else
				begin
				if (r_movement_counter < BALL_SPEED)
					r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter == BALL_SPEED)
				begin
					r_movement_counter <= 0;
					r_intermediate_x <= r_intermediate_x + 1;
					r_intermediate_y <= r_intermediate_y + 1;
				end
			end
		end
		
		UP_RIGHT:
		begin
			if (r_intermediate_y == BALL_RADIUS)
				r_next_state <= DOWN_RIGHT;
			else if (r_intermediate_x == SCREEN_WIDTH - BALL_RADIUS)
				r_next_state <= UP_LEFT;
			else if (r_intermediate_y == BALL_RADIUS && 
					r_intermediate_x == SCREEN_WIDTH - BALL_RADIUS)
				r_next_state <= DOWN_LEFT;
			else
				begin
				if (r_movement_counter < BALL_SPEED)
					r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter == BALL_SPEED)
				begin
					r_movement_counter <= 0;
					r_intermediate_x <= r_intermediate_x + 1;
					r_intermediate_y <= r_intermediate_y - 1;
				end
			end
		end
		
		UP_LEFT:
		begin 
			if (r_intermediate_y == BALL_RADIUS)
				r_next_state <= DOWN_LEFT;
			else if (r_intermediate_x == BALL_RADIUS)
				r_next_state <= UP_RIGHT;
			else if (r_intermediate_y == BALL_RADIUS && 
					r_intermediate_x == BALL_RADIUS)
				r_next_state <= DOWN_RIGHT;
			else
				begin
				if (r_movement_counter < BALL_SPEED)
					r_movement_counter <= r_movement_counter + 1;
					
				else if (r_movement_counter == BALL_SPEED)
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
		r_ball_bottom <= r_ball_y - BALL_RADIUS;
		r_ball_left <= r_ball_x - BALL_RADIUS;
		r_ball_right <= r_ball_x + BALL_RADIUS;
		
		if (i_v_sync_nededge)
		begin
			r_ball_x <= r_intermediate_x;
			r_ball_y <= r_intermediate_y;
		end
		
		if (i_h_count > r_ball_left && i_h_count < r_ball_right 
			&& i_v_count > r_ball_top && i_v_count < r_ball_bottom)
			o_draw_ball <= 1;
		else
			o_draw_ball <= 0;		
	end
	
	
	
	
endmodule