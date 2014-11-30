function   [similarity] = calculate_matching_cost(sketch_local_feature,image_local_feature,sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5,image_G1,image_G2,image_G3,image_G4,image_G5,sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5);
     
%%  CALCULATE_MATCHING_COST 此处显示有关此函数的摘要
%   脚本功能：计算sketch和image的匹配值
%   输入参数：
%       sketch的local_feature:   sketch_local_feature
%       image的local_feature:    image_local_feature
%       sketch的global feature:  sketch_G1,sketch_G2,sketch_G3,sketch_G4,sketch_G5
%       image的global feature:   image_G1,image_G2,image_G3,image_G4,image_G5
%       sketch的分割情况:         sketch_D1,sketch_D2,sketch_D3,sketch_D4,sketch_D5
%   输出参数：
%       sketch和image的匹配值

%%  计算匹配值


%% *****************************计算第一层的匹配值：2*2   ***************************************



%% *****************************计算第二层的匹配值：4*4   ***************************************



%% *****************************计算第三层的匹配值：8*8   ***************************************




%% *****************************计算第四层的匹配值：16*16 ***************************************




%% *****************************计算第五层的匹配值：32*32 ***************************************




end %end of function

