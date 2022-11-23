module generate_paddle(
	input i_clk,
	input [1:0] i_paddle_move,
	input [9:0] i_h_count,
	input [9:0] i_v_count,
	input i_v_sync,
	output o_draw_paddle = 0,
	output o_w_v_sync_negedge
);



parameter PADDLE_WIDTH= 10;
parameter PADDLE_HEIGHT = 80;
parameter PADDLE_X = 5;
parameter PADDLE_Y = 240;
parameter PADDLE_LEFT_EDGE = PADDLE_X - PADDLE_WIDTH / 2;
parameter PADDLE_RIGHT_EDGE = PADDLE_X + PADDLE_WIDTH / 2;
parameter STARTING_TOP_EDGE = PADDLE_Y - PADDLE_HEIGHT / 2;
parameter STARTING_BOTTOM_EDGE = PADDLE_Y + PADDLE_HEIGHT / 2;
parameter NOT_MOVING = 2'b00;
parameter MOVING_UP = 2'b01;
parameter MOVING_DOWN = 2'b10;

reg [1:0] r_current_state = NOT_MOVING, r_next_state = NOT_MOVING;
reg [9:0] r_paddle_y = PADDLE_Y, r_intermediate_y = PADDLE_Y;
reg [18:0] r_movement_counter;
reg r_prev_sync, r_current_sync;
wire w_v_sync_negedge;
reg [9:0] r_paddle_top = PADDLE_Y - PADDLE_HEIGHT/2, r_paddle_bottom = PADDLE_Y + PADDLE_HEIGHT/2;

//find negative edge of v_sync


//state machine to handle movement of paddle
always @ (posedge i_clk)
begin
	r_current_state <= r_next_state;
	r_prev_sync <= r_current_sync;
	r_current_sync <= i_v_sync;	
end

assign w_v_sync_negedge = r_prev_sync && ~r_current_sync;

//next state logic
always @(posedge i_clk)
begin
	case (r_current_state)
		
		NOT_MOVING:
		begin
			if (i_paddle_move == MOVING_UP)
			begin
				r_next_state <= MOVING_UP;
				r_movement_counter <= r_movement_counter +1;
			end
			else if (i_paddle_move == MOVING_DOWN)
			begin
				r_next_state <= MOVING_DOWN;
				r_movement_counter <= r_movement_counter + 1;
			end
			else if (i_paddle_moving == NOT_MOVING)
			begin
				r_next_state <= NOT_MOVING;
				r_movement_counter <= 0;
			end
		end
		
		MOVING_UP:
		begin
			if (i_paddle_move == NOT_MOVING)
				r_next_state <= NOT_MOVING;
			else
			begin
				if (r_movement_counter < 400000)
				begin
					r_movement_counter <= r_movement_counter + 1;
				end
				else if (r_movement_counter == 400000)
				begin
					r_intermediate_y <= r_intermediate_y - 1;
					r_movement_counter <= 0;
				end
			end
		end
		
		MOVING_DOWN:
		begin
			if (i_paddle_move == NOT_MOVING)
				r_next_state <= NOT_MOVING;
			else
			begin
				if (r_movement_counter < 400000)
				begin
					r_movement_counter <= r_movement_counter + 1;
				end
				else if (r_movement_counter == 400000)
				begin
					r_intermediate_y <= r_intermediate_y + 1;
					r_movement_counter <= 0;
				end
			end
		end
		endcase
end

//movement logic to update position on each negative edge of the v_sync signal and output logic

always @(posedge i_clk)
begin
	r_paddle_top <= r_paddle_y - PADDLE_HEIGHT / 2;
	r_paddle_bottom <= r_paddle_y + PADDLE_HEIGHT / 2;
	if (w_v_sync_negedge)
	begin
		r_paddle_y <= r_intermediate_y;
	end
	if (i_h_count > PADDLE_LEFT_EDGE && i_h_count < PADDLE_RIGHT_EDGE && i_v_count > r_paddle_top && i_v_count < r_paddle_bottom)
	begin
		o_draw_paddle <= 1;
	end
	else
	begin
		o_draw_paddle <= 0;
	end
end



endmodule













