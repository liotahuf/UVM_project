/*------------------------------------------------------------------------------
 * File          : Kmeans_Ref_if.sv
 * Project       : UVMprj
 * Author        : epedlh
 * Creation date : Aug 19, 2020
 * Description   :
 *------------------------------------------------------------------------------*/

interface Kmeans_Ref_if;

logic clk;
logic go;
logic rst;
logic [12:0] matrix [0:3583];//TODO - make sure connection of matrix work
logic [12:0] in_centroids [0:55];//TODO - make sure connection of matrix work
logic [12:0] threshold;
logic [12:0] first_point_index;
logic [12:0] last_point_index;
logic [12:0] out_centroids [0:55];

//COVERAGE	
covergroup num_points_cg@(posedge go);
	//split into 12 equally sized bins the interval from 8 to 512
	NUM_POINTS : coverpoint  (last_point_index - first_point_index) {
		bins size[12] = {[8:512]};
	}

			
	//check data points sizes
	// TODO
		
	//anything else extra - TODO
		
endgroup

covergroup data_points_cg with function sample(logic [12:0] point);
	DATA_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup

covergroup cent1_cg with function sample(logic [12:0] point);
	CENT1_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup		


covergroup cent2_cg with function sample(logic [12:0] point);
	CENT2_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup

covergroup cent3_cg with function sample(logic [12:0] point);
	CENT3_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup

covergroup cent4_cg with function sample(logic [12:0] point);
	CENT4_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup


covergroup cent5_cg with function sample(logic [12:0] point);
	CENT5_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup


covergroup cent6_cg with function sample(logic [12:0] point);
	CENT6_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup

covergroup cent7_cg with function sample(logic [12:0] point);
	CENT7_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup

covergroup cent8_cg with function sample(logic [12:0] point);
	CENT8_VALUES : coverpoint (point) {
		bins value [10]= {[0:$]};
	}
endgroup

num_points_cg npcg;
data_points_cg dpcg;
cent1_cg cent1cg;
cent2_cg cent2cg;
cent3_cg cent3cg;
cent4_cg cent4cg;
cent5_cg cent5cg;
cent6_cg cent6cg;
cent7_cg cent7cg;
cent8_cg cent8cg;
	
initial begin
	npcg = new;
	dpcg = new;
	cent1cg = new;
	cent2cg = new;
	cent3cg = new;
	cent4cg = new;
	cent5cg = new;
	cent6cg = new;
	cent7cg = new;
	cent8cg = new;
	
	
	forever begin
		@(posedge go) begin
			for(int i =0;i<3584;i++) begin
				dpcg.sample(matrix[i]);
			end
			for(int i =0;i<7;i++) begin
				cent1cg.sample(in_centroids[i]);
			end
			for(int i =7;i<14;i++) begin
				cent2cg.sample(in_centroids[i]);
			end
			for(int i =14;i<21;i++) begin
				cent3cg.sample(in_centroids[i]);
			end
			for(int i =21;i<28;i++) begin
				cent4cg.sample(in_centroids[i]);
			end
			for(int i =28;i<35;i++) begin
				cent5cg.sample(in_centroids[i]);
			end
			for(int i =35;i<42;i++) begin
				cent6cg.sample(in_centroids[i]);
			end
			for(int i =42;i<49;i++) begin
				cent7cg.sample(in_centroids[i]);
			end
			for(int i =49;i<56;i++) begin
				cent8cg.sample(in_centroids[i]);
			end
		end
	end
end





endinterface : Kmeans_Ref_if
