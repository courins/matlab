function [scan, cam, app, opt, cur] = p05_log(file)
% Read log file of beamline P05.
%
% ARGUMENTS
% file : string. Path to log file
% 
% Written by Julian Moosmann, 2016-12-12. Last version: 2016-12-12
%
% [scan, cam, app, opt, cur] = p05_log(filename)

if nargin < 1
    file = '/asap3/petra3/gpfs/p05/2015/data/11001102/raw/hzg_wzb_mgag_14/hzg_wzb_mgag_14scan.log';
end

%% Main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen( file );

%% scan info
textscan( fid, '%s', 2, 'Delimiter', '\n' ); % Skip first two lines
scan.Energy = '%f';
scan.n_dark = '%u';
scan.n_ref_min = '%u';
scan.n_ref_max = '%u';
scan.n_img = '%u';
scan.n_angle = '%u';
scan.ref_count = '%u';
scan.img_bin = '%u';
scan.img_xmin = '%u';
scan.img_xmax = '%u';
scan.img_ymin = '%u';
scan.img_ymax = '%u';
scan.exptime = '%u';

fn = fieldnames( scan );
for nn = 1:numel( fn )
    s = fn{nn};
    v = scan.(s);   
    c = textscan( fid, sprintf( '%s=%s', s, v ) );
    scan.(s) = c{1};
end
textscan( fid, '%s', 1, 'Delimiter', '\n' );
textscan( fid, '%s', 1, 'Delimiter', '\n' );

%% camera info 
cam.ccd_pixsize = '%f';
cam.ccd_xsize =  '%u';
cam.ccd_ysize =  '%u';
cam.o_screen_changer = '%f';
cam.o_focus = '%f';
cam.o_aperture = '%f';
cam.o_lens_changer = '%f';
cam.o_ccd_high = '%f';
cam.magn = '%f';

fn = fieldnames( cam );
for nn = 1:numel( fn )
    s = fn{nn};
    v = cam.(s);    
    c = textscan( fid, sprintf( '%s:%s', s, v ) );
    cam.(s) = c{1};
end

textscan( fid, '%s', 4, 'Delimiter', '\n');
textscan( fid, '%s', 2, 'Delimiter', '\n');

%% apparatus info
app.pos_s_pos_x = '%f';
app.pos_s_pos_y = '%f';
app.pos_s_pos_z = '%f';
app.pos_s_stage_z = '%f';
app.s_in_pos = '%f';
app.s_out_dist = '%f';

fn = fieldnames( app );
for nn = 1:numel( fn )
    s = fn{nn};
    v = app.(s);
    % fprintf( 'fieldname: %s : ', s ); disp( v )   
    c = textscan( fid, sprintf( '%s=%s', s, v ), 'Delimiter', '\n' );
    app.(s) = c{1};
end
textscan( fid, '%s', 1, 'Delimiter', '\n');

%% optimization info
opt.p05_dcm_xtal2_pitch_delta = '%f';
opt.com_delta_threshhold =  '%f';

fn = fieldnames( opt );
for nn = 1:numel( fn )
    s = fn{nn};
    v = opt.(s);
    c = textscan( fid, sprintf( '%s=%s', s, v ), 'Delimiter', '\n' );
    opt.(s) = c{1};
end

%% ring current
% ************************************************
% /PETRA/Idc/Buffer-0/I.SCH
% @1436994685507[89.40661@1436994685435]
% 
% ref /gpfs/current/raw/hzg_wzb_mgag_00/hzg_wzb_mgag_0000005.ref       0.00000
% /PETRA/Idc/Buffer-0/I.SCH
% @1436994686180[89.39424@1436994686098]

formatSpec = '%*s\n%*s\n@%*f[%f@%f]\n\n%s /gpfs/current/raw/%s %f\n%*s\n@%*f[%f@%f]\n%*s\n';
cur  = textscan( fid, formatSpec);

%% End of Scan

fclose( fid );
% End %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%