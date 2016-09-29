%% ASTRA parallel 2D projectors using 3D vector geometry in order for flexibiltiy.
clear all
astra_clear

% Volume geometry
vx = 1002;
vy = 1004;
vz = 1;

% Detector geometry
num_proj = 900;
det_row_count = 1;
det_col_count = 1000;
theta = pi * (0:num_proj-1) / num_proj;
DetectorSpacingX = 1;
DetectorSpacingY = 1;

% Phantom
p = zeros(vx, vy);
p( ceil(vx/4):floor(3/4*vx), ceil(vy/4):floor(3/4*vy)) = 1;

% Create ASTRA geometry vector
vectors = zeros( numel(theta), 12);
for nn = 1:num_proj

    % ray direction
    vectors(nn,1) = sin( theta(nn) );
    vectors(nn,2) = -cos( theta(nn) );
    vectors(nn,3) = 0;

    % center of detector
    vectors(nn,4) = 0;
    vectors(nn,5) = 0;
    vectors(nn,6) = 0;

    % vector from detector pixel (0,0) to (0,1)
    vectors(nn,7) = cos( theta(nn) ) * DetectorSpacingX;
    vectors(nn,8) = sin( theta(nn) ) * DetectorSpacingX;
    vectors(nn,9) = 0;

    % vector from detector pixel (0,0) to (1,0)
    vectors(nn,10) = 0;
    vectors(nn,11) = 0;
    vectors(nn,12) = DetectorSpacingY;

end

% ASTRA projection geometry
proj_geom = astra_create_proj_geom('parallel3d_vec',  det_row_count, det_col_count, vectors);

% ASTRA volume geometry
vol_geom = astra_create_vol_geom( vy, vx, vz );

% ASTRA projector
proj_id = astra_create_projector('cuda3d', proj_geom, vol_geom);

% ASTRA volume object
vol_id = astra_mex_data3d('create', '-vol', vol_geom, p);

% ASTRA sino object
%sino_id = astra_mex_data3d('set', id, p);

% Phantom data
sino_id = astra_create_sino3d_cuda(vol_id, proj_geom, vol_geom);
sino = astra_mex_data3d('get', sino_id);


% ASTRA config struct
cfg = astra_struct('BP3D_CUDA');
%cfg.ProjectorId = proj_id;
cfg.ProjectionDataId = sino_id;
cfg.ReconstructionDataId = vol_id;
fbp_id = astra_mex_algorithm('create', cfg);




figure('Name','phantom'), imsh(p)
figure('Name','sino'), imsh(sino)

