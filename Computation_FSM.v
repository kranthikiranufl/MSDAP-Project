module computation_FSM(Sclk,Start,Reset_n,Outready,compute,memout_rj,memout_coeff,memout_data,refresh,compute_done,data_remain,coef_sign,flag_rj,flag_shift,read_addr_rj,read_addr_coeff,read_addr_data,temp_data);
input Sclk,Start,Reset_n,Outready,compute;
input [15:0] memout_coeff,memout_data,memout_rj;
output reg refresh,compute_done,data_remain,coef_sign,flag_rj,flag_shift;
output reg [8:0] read_addr_coeff;
output reg [7:0] read_addr_data;
output reg [3:0] read_addr_rj;
output reg [39:0] temp_data;

reg [3:0] pc_comp_rj;
reg [8:0] pc_comp_coeff;
reg [7:0] pc_comp_data;
reg [8:0] nL;
reg [39:0] meminput_alu;
reg [15:0] temp_memout_rj;
reg [15:0] temp_memout_coeff;

//defining the states
 parameter [2:0] S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, S4=3'd4, S5=3'd5;
 reg [2:0] pr_state, next_state;
	always @(posedge Sclk or negedge Reset_n)		// Sequential block
	begin
		if (!Reset_n)
		  pr_state = S0;
		  flag_rj = 1'b0;
		  flag_shift = 1'b0;
		  read_addr_coeff = 9'd0;
		  read_addr_data = 8'd0;
		  read_addr_rj = 4'd0;
		  temp_data = 40'd0;
		  compute_done = 1'b0;
		  data_remain =1'b0;
		  refresh=1'b0;
		  coef_sign=1'b0;
		else
		pr_state = next_state;
	end
	
	always @(posedge Sclk)
	begin 
	 if (Start ==1'b1)
	      nl = 9'd0;
	 if (Outready ==1'b1)
	    data_remain =1'b0;
	 if(compute ==1'b1)
	 begin 
	  case (pr_state)
	     S0: begin
		      refresh = 0;
			  flag_rj = 1'b0;
			  flag_shift = 1'b0;
			  pc_comp_coeff = 9'd0;
			  pc_comp_rj = 4'd0;
			  read_addr_coeff = pc_comp_coeff;
			  
	  