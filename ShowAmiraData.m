addpath ('Z:\Josephine\Histo\Cohort_12_33-38\#34\#34_reconstruction')
addpath ('Z:\Josephine')
clearvars
close all

% load Data
load('Z:\Josephine\vpm_pom_coordinates_predictions.mat', 'coords')
brain = LoadTiffStack('Brain_stack.tif'); brain = smooth3(brain);
pom = LoadTiffStack('PO_stack.tif'); pom = smooth3(pom);
vpm = LoadTiffStack('VPM_stack.tif'); vpm = smooth3(vpm);

px2micm = [8.66,8.66, -50];
refs = [-748, -902, 8.2];

% plot Data
[brain_faces, brain_vertices] = isosurface(brain);
brain_vertices_micm = brain_vertices.*px2micm + refs.*px2micm;
figure; pb = patch('Faces', brain_faces, 'Vertices', brain_vertices_micm);
pb.EdgeColor = 'none'; pb.FaceAlpha = 0.3;
hold on

[pom_faces, pom_vertices] = isosurface(pom);
pom_vertices_micm = pom_vertices.*px2micm + refs.*px2micm;
pp = patch('Faces', pom_faces, 'Vertices', pom_vertices_micm);
pp.FaceColor = 'g'; pp.EdgeColor = 'none'; pp.FaceAlpha = 0.3;

[vpm_faces, vpm_vertices] = isosurface(vpm);
vpm_vertices_micm = vpm_vertices.*px2micm + refs.*px2micm;
pv = patch('Faces', vpm_faces, 'Vertices', vpm_vertices_micm);
pv.FaceColor = 'r'; pv.EdgeColor = 'none'; pv.FaceAlpha = 0.3;

plot3(-coords(:,1),coords(:,3),coords(:,2),'Linestyle','none','Marker','.')

xlabel('m/l axis'); ylabel('d/v axis'); zlabel('a/p axis')
