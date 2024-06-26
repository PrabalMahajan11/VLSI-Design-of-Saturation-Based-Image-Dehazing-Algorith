module time_alignment(
        input               clk                     ,
        input               rst_n                   ,  

        input               pre_src_frame_vsync     , 
        input               pre_src_frame_href      ,  
        input               pre_src_frame_clken     , 
        input   [23 : 0]    pre_img                 ,

        input               pre_tx_frame_vsync      ,
        input               pre_tx_frame_href       ,
        input               pre_tx_frame_clken      ,
        input   [7  : 0]    pre_tx_img              ,

        input   [7  : 0]    pre_A                   ,

        output              post_src_frame_vsync    , 
        output              post_src_frame_href     ,  
        output              post_src_frame_clken    , 
        output  [23 : 0]    post_img                ,

        output              post_tx_frame_vsync     ,
        output              post_tx_frame_href      ,
        output              post_tx_frame_clken     ,
        output  [7  : 0]    post_tx_img             ,

        output  [7  : 0]    post_A                   
);
integer i;

parameter src_delay = 6;

reg                         pre_src_frame_vsync_d[src_delay - 1 : 0]    ;
reg                         pre_src_frame_href_d[src_delay - 1 : 0]     ;
reg                         pre_src_frame_clken_d[src_delay - 1 : 0]    ;
reg     [23 : 0]            pre_img_d[src_delay - 1 : 0]                ;

//src_delay
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        for(i = 0; i< src_delay; i = i + 1)begin
            pre_src_frame_vsync_d   [ i ]   <=    0;
            pre_src_frame_href_d    [ i ]   <=    0;
            pre_src_frame_clken_d   [ i ]   <=    0;
            pre_img_d               [ i ]   <=    0;
        end
    end
    else begin
        pre_src_frame_vsync_d   [ 0 ]          <=    pre_src_frame_vsync               ;
        pre_src_frame_href_d    [ 0 ]          <=    pre_src_frame_href                ;
        pre_src_frame_clken_d   [ 0 ]          <=    pre_src_frame_clken               ;
        pre_img_d               [ 0 ]          <=    pre_img                           ;
        for(i = 1; i< src_delay; i = i + 1)begin
            pre_src_frame_vsync_d   [ i ]      <=    pre_src_frame_vsync_d  [ i - 1 ]  ;
            pre_src_frame_href_d    [ i ]      <=    pre_src_frame_href_d   [ i - 1 ]  ;
            pre_src_frame_clken_d   [ i ]      <=    pre_src_frame_clken_d  [ i - 1 ]  ;
            pre_img_d               [ i ]      <=    pre_img_d              [ i - 1 ]  ;
        end
    end
end

assign      post_src_frame_vsync    =   pre_src_frame_vsync_d   [ src_delay - 1 ]   ;
assign      post_src_frame_href     =   pre_src_frame_href_d    [ src_delay - 1 ]   ; 
assign      post_src_frame_clken    =   pre_src_frame_clken_d   [ src_delay - 1 ]   ;
assign      post_img                =   pre_img_d               [ src_delay - 1 ]   ;            



assign      post_tx_frame_vsync     =   pre_tx_frame_vsync      ;
assign      post_tx_frame_href      =   pre_tx_frame_href       ;
assign      post_tx_frame_clken     =   pre_tx_frame_clken      ;
assign      post_tx_img             =   pre_tx_img              ;

assign      post_A                  =   pre_A;


endmodule
