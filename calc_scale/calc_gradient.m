addpath(genpath('E:\matlab\calc_scale\AnisotropicDetector\'));

%% Begin Operation
t = 30;
sigma = 2.7;

lowScale = 2:3:17;

images_list = textread('images_full.list', '%s');

len = size(images_list);

for i = 1:len
  imgPath = images_list{i};
  fprintf('processing %s\n', imgPath);

  img = imresize(imread(imgPath), [240 320]);

  [dx dy] = foo_andiff( img, linspace(1.2,16,t), sigma, 3, 1000, t);

  o_dx = dx;
  o_dy = dy;

  for p = 1:240
    for q = 1:320
      if dy(p, q) < 0.0
        dx(p, q) = -dx(p, q);
        dy(p, q) = -dy(p, q);
      end
    end
  end

  result = atan2(dy, dx) / pi * 180;

  [filethstr, name, ext] = fileparts(imgPath);

  %% FIXME: fwrite(matrix transpose)
  fid = fopen(fullfile(filethstr, strcat(name, '.scale_gradient')), 'w');
  fwrite(fid, result', 'double');
  fclose(fid);

  fid = fopen(fullfile(filethstr, strcat(name, '.scale_gradient_dx')), 'w');
  fwrite(fid, o_dx', 'double');
  fclose(fid);

  fid = fopen(fullfile(filethstr, strcat(name, '.scale_gradient_dy')), 'w');
  fwrite(fid, o_dy', 'double');
  fclose(fid);
end

quit;

