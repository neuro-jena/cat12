function cat_stat_quality_measures(job)
%To check z-score across sample and save quality 
% measures in csv file.
%
% Images have to be in the same orientation with same voxel size
% and dimension (e.g. spatially registered images)
%
% Surfaces have to be same size (number of vertices).
%
% varargout = cat_stat_quality_measures(job)
%  
% job                .. SPM job structure
%  .data             .. volume files
%  .globals          .. global scaling
%  .csv_name         .. csv output name
%
% Example: 
%   cat_stat_quality_measures(struct('data',{{ files }},'globals',1,'csv_name','test.csv'));
% ______________________________________________________________________
%
% Christian Gaser, Robert Dahnke
% Structural Brain Mapping Group (http://www.neuro.uni-jena.de)
% Departments of Neurology and Psychiatry
% Jena University Hospital
% ______________________________________________________________________
% $Id$

n_subjects = 0;
sample   = [];

% read header
n_subjects = numel(job.data);
V = spm_data_hdr_read(char(job.data));
mesh_detected = spm_mesh_detect(char(job.data{1}));

isxml = 0;
pth = spm_fileparts(V(1).fname);
report_folder = fullfile(spm_fileparts(pth),'report');
subfolder = 1;
% check whether report subfolder exists
if ~exist(report_folder,'dir')
  report_folder = pth;
  subfolder = 0;
end

% search xml report files
xml_files = spm_select('List',report_folder,'^cat_.*\.xml$');
if ~isempty(xml_files)
  fprintf('Search xml-files\n');
  % find part of xml-filename in data files to get the prepending string
  % (e.g. mwp1)
  i = 1; j = 1;
  while i <= n_subjects
    while j <= size(xml_files,1)
      % remove "cat_" and ".xml" from name
      fname = deblank(xml_files(j,:));
      fname = fname(5:end-4);
      
      % and find that string in data filename
      ind = strfind(V(i).fname,fname);
      if ~isempty(ind)
        [pth, prep_str] = spm_fileparts(V(1).fname(1:ind-1));
        isxml = 1;
        i = n_subjects;
        j = size(xml_files,1);
        break
      else
        j = j + 1;
      end
    end
    i = i + 1;
  end
end

% check for global scaling
if job.globals
  if mesh_detected
    is_gSF = false;
    fprintf('Disabled global scaling with TIV, because this is not meaningful for surface data.\n');
  else
    is_gSF = true;
    gSF = zeros(n_subjects,1);
  end
else
  is_gSF = false;
end

if isxml
  if mesh_detected
    QM = ones(n_subjects,5);
    QM_names = char('Noise','Bias','Weighted overall image quality (IQR)','Euler number','Size of topology defects');
  else
    QM = ones(n_subjects,3);
    QM_names = char('Noise','Bias','Weighted overall image quality (IQR)');
  end
  
  spm_progress_bar('Init',n_subjects,'Load xml-files','subjects completed')
  for i=1:n_subjects
    
    % get basename for data files
    [pth, data_name] = fileparts(V(i).fname);
    
    % remove ending for rigid or affine transformed files
    data_name = strrep(data_name,'_affine','');
    data_name = strrep(data_name,'_rigid','');

    % get report folder
    if subfolder
      report_folder = fullfile(spm_fileparts(pth),'report');
    else
      report_folder = pth;
    end
    
    % remove prep_str from name and use report folder and xml extension
    if mesh_detected
      % for meshes we also have to remove the additional "." from name
      tmp_str = strrep(data_name,prep_str,'');
      xml_file = fullfile(report_folder,['cat_' tmp_str(2:end) '.xml']);
    else
      xml_file = fullfile(report_folder,['cat_' strrep(data_name,prep_str,'') '.xml']);
    end
    
    if ~exist(xml_file,'file')
      isxml = 0;
      fprintf('Cannot use quality ratings, because xml-file %s was not found\n',xml_file);
      break
    end
    
    xml = cat_io_xml(xml_file);
    
    % get TIV
    if is_gSF && isfield(xml,'subjectmeasures') && isfield(xml.subjectmeasures,'vol_TIV')
      gSF(i) = xml.subjectmeasures.vol_TIV;
    else
      is_gSF = false;
    end
    
    if ~isfield(xml,'qualityratings') && ~isfield(xml,'QAM')
      fprintf('Quality rating is not saved for %s. Report file %s is incomplete.\nPlease repeat preprocessing amd check for potential errors in the ''err'' folder.\n',V(i).fname,xml_files(i,:));    
      return
    end
    if mesh_detected
      if isfield(xml.qualityratings,'NCR')
      % check for newer available surface measures
        if isfield(xml.subjectmeasures,'EC_abs')
          QM(i,:) = [xml.qualityratings.NCR xml.qualityratings.ICR xml.qualityratings.IQR xml.subjectmeasures.EC_abs xml.subjectmeasures.defect_size];
        else
          QM(i,:) = [xml.qualityratings.NCR xml.qualityratings.ICR xml.qualityratings.IQR NaN NaN];
        end
      else % also try to use old version
        QM(i,:) = [xml.QAM.QM.NCR xml.QAM.QM.ICR xml.QAM.QM.rms];
      end
    else
      if isfield(xml.qualityratings,'NCR')
        QM(i,:) = [xml.qualityratings.NCR xml.qualityratings.ICR xml.qualityratings.IQR];
      else % also try to use old version
        QM(i,:) = [xml.QAM.QM.NCR xml.QAM.QM.ICR xml.QAM.QM.rms];
      end
    end
    spm_progress_bar('Set',i);  
  end
  spm_progress_bar('Clear');
  
  % remove last two columns if EC_abs and defect_size are not defined
  if mesh_detected && all(isnan(QM(:,4))) && all(isnan(QM(:,5)))
    QM = QM(:,1:3);
  end
  
end

[pth,nam] = spm_fileparts(V(1).fname);

if ~mesh_detected  
  % voxelsize and origin
  vx =  sqrt(sum(V(1).mat(1:3,1:3).^2));
  Orig = V(1).mat\[0 0 0 1]';

  if length(V)>1 && any(any(diff(cat(1,V.dim),1,1),1))
    error('images don''t all have same dimensions')
  end
  if max(max(max(abs(diff(cat(3,V.mat),1,3))))) > 1e-8
    error('images don''t all have same orientation & voxel size')
  end
end

if is_gSF
  fprintf('Use global scaling with TIV\n');
end

Ymean = 0.0;
fprintf('Load data ');
for i = 1:n_subjects
  fprintf('.');
  tmp = spm_data_read(V(i));
  tmp(isnan(tmp)) = 0;
  if is_gSF
    tmp = tmp*gSF(i)/mean(gSF);
  end
  if i>1 && numel(Ymean) ~= numel(tmp)
    fprintf('\n\nERROR: File %s has different data size: %d vs. %d\n\n',V(i).fname,numel(Ymean),numel(tmp));
    return
  end
  Ymean = Ymean + tmp(:);
end

% get mean
Ymean = Ymean/n_subjects;

Ysd = 0;
for i = 1:n_subjects
  fprintf('.');
  tmp = spm_data_read(V(i));
  tmp(isnan(tmp)) = 0;
  if is_gSF
    tmp = tmp*gSF(i)/mean(gSF);
  end
  Ysd = Ysd + (tmp(:) - Ymean).^2;
end

% get std
Ysd = sqrt(Ysd/n_subjects);

% only consider non-zero areas
ind = Ysd ~= 0;

mean_zscore = zeros(n_subjects,1);
for i = 1:n_subjects
  fprintf('.');
  tmp = spm_data_read(V(i));
  tmp(isnan(tmp)) = 0;
  if is_gSF
    tmp = tmp*gSF(i)/mean(gSF);
  end
  % calculate z-score  
  zscore = ((tmp(ind) - Ymean(ind)).^2)./Ysd(ind);
  
  % and use mean of z-score as overall measure
  mean_zscore(i) = mean(zscore);
end
fprintf('\n');

if isxml
  % estimate product between weighted overall quality (IQR) and mean z-score
  IQR = QM(:,3);
  IQRratio = (mean_zscore/std(mean_zscore)).*(IQR/std(IQR));
  if mesh_detected
    Euler_number = QM(:,4);
    Topo_defects = QM(:,5);
  end
end

fid = fopen(job.csv_name,'w');

if fid < 0
  error('No write access for %s: check file permissions or disk space.',job.csv_name);
end

fprintf(fid,'Path;Name;Mean z-score');
if isxml
  fprintf(fid,';Weighted overall image quality (IQR);Normalized product of IQR and Mean z-score');
  if mesh_detected
    fprintf(fid,';Euler Number;Size of topology defects\n');
  else
    fprintf(fid,'\n');
  end
else
  fprintf(fid,'\n');
end
for i = 1:n_subjects
  [pth, data_name] = fileparts(V(i).fname);
  fprintf(fid,'%s;%s;%g',pth,data_name,mean_zscore(i));
  if isxml
    fprintf(fid,';%g;%g',IQR(i),IQRratio(i));
    if mesh_detected
      fprintf(fid,';%d;%g\n',Euler_number(i),Topo_defects(i));
    else
      fprintf(fid,'\n');
    end
  else
    fprintf(fid,'\n');
  end
end

if fclose(fid)==0
  fprintf('\nValues saved in %s.\n',job.csv_name);
end
