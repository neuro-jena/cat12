function varargout = compile(comp,test,verb)
% ______________________________________________________________________
% Function to compile and test cat12 c-functions. 
% Testing include a standard call of the function with simple image and
% small a small test of the eximated values. 
% 
%   [ok] = compile([comp,test,verb])
%   
%   comp = [0|1]: compile functions; default 1
%   test = [0|1]: test compiled functions; default 1
%   verb = [0|1]: display progress; default 1
%
%   ok = [0|1]: all functions compiled | tested successfull
% ______________________________________________________________________
% $Id$ 

% developer help
% ______________________________________________________________________
%  
%   [ok,s,r] = compile([comp,test,verb]
% 
%   s and r are only available for test==1
%
%   s  = vector of the test results of each function
%   r  = vecotr of the RMS error of the tests (the error gives no
%        information about the accuracy of the function, as far as
%        comparison function do somethimes only similar things)
% ______________________________________________________________________

  if ~exist('comp','var'), comp=1; end
  if ~exist('test','var'); test=1; end
  if ~exist('verb','var'); verb=1; end
  
  %% testdata 
  % ds('d2','',1,d0,d1/2,dw/6 + 0.5/6,dc/6 + 0.5/6,5)
  d0  = single(rand(10,10,10)); d0(5,5,5) = NaN;
  d1  = zeros(10,10,10,'single'); d1(3:8,:,:)=1; d1(9:10,:,:)=2; d1(5,5,5) = NaN;      % simple segment image for distance and fitler tests
  dc  = zeros(10,10,10,'single'); for si=3:8; dc(si,:,:)=si-2.5; end; dc(5,5,5) = NaN; % csf distance
  dw  = zeros(10,10,10,'single'); for si=3:8; dw(si,:,:)=8.5-si; end; dw(5,5,5) = NaN; % wm distance
  dcube = zeros(10,10,10,'single'); dcube(3:end-2,3:end-2,3:end-2) = 1; d1(5,5,5) = NaN;
  r = []; 
  s = []; 
  
  %% compiling c-functions
  if comp==1
  
    if strcmp(mexext,'mexmaci64')
      mexflag='-Dchar16_t=UINT16_T CFLAGS=''$CFLAGS -Wall -ansi -pedantic -Wextra'' CPPLAGS=''$CPPFLAGS -Wall -ansi -pedantic -Wextra''';
    else
      mexflag='';
    end

    %% main c-functions
    eval(['mex ' mexflag ' -O cat_amap.c Kmeans.c Amap.c MrfPrior.c Pve.c vollib.c'])
    eval(['mex ' mexflag ' -O cat_vol_median3.c'])
    eval(['mex ' mexflag ' -O cat_vol_median3c.c'])
    eval(['mex ' mexflag ' -O cat_vol_downcut.c'])
    eval(['mex ' mexflag ' -O cat_vol_laplace3.c'])
    eval(['mex ' mexflag ' -O cat_vol_laplace3R.c'])
    eval(['mex ' mexflag ' -O cat_vol_gradient3.c'])
    eval(['mex ' mexflag ' -O cat_vol_simgrow.c'])
    eval(['mex ' mexflag ' -O cat_vol_localstat.c'])
    eval(['mex ' mexflag ' -O cat_vol_pbtp.cpp'])
    eval(['mex ' mexflag ' -O cat_vol_interp3f.cpp'])
    eval(['mex ' mexflag ' -O cat_vol_eidist.c'])
    eval(['mex ' mexflag ' -O cat_vol_genus0.c genus0.c'])
    eval(['mex ' mexflag ' -O cat_vbdist.c'])
    eval(['mex ' mexflag ' -O cat_ornlm.c ornlm_float.c'])
    eval(['mex ' mexflag ' -O cat_sanlm.c sanlm_float.c'])
      
    % internal c-functions
    try
      cd('internal');
      if strcmp(mexext,'mexw64')
        eval(['mex ' mexflag ' -O cat_vol_cMRegularizarNLM3Dw.c']);
        movefile('cat_vol_cMRegularizarNLM3Dw.mexw32','cat_vol_cMRegularizarNLM3D.mexw32');
      elseif strcmp(mexext,'mexw64')
        eval(['mex ' mexflag ' -O cat_vol_cMRegularizarNLM3Dw.c']);
        movefile('cat_vol_cMRegularizarNLM3Dw.mexw64','cat_vol_cMRegularizarNLM3D.mexw64');
      elsecd(catidir);
        eval(['mex ' mexflag ' -O cat_vol_cMRegularizarNLM3D.c']);
      end
    end
    cd ..
      
  end
  
  
  
  %% test c-functions
  if test==1
  
    ntests = 15;
    n = cell(ntests, 1); 
    d = cell(ntests, 1);
    r = nan(ntests,1); 
    s = false(ntests, 1);
    
    rms  = @(x) cat_stat_nanmean( x(:).^2 )^0.5;
    %nstd = @(x) cat_stat_nanstd( x(:) );
    
    
    %% Median 
    %  Test the noise reduction by the median filter in the segment image.  
    %    ds('l2','',1,d0,d1/2,d1/2 + d0/10,d{1},5)
    n{1} = 'cat_vol_median3';   
    d{1} = cat_vol_median3(d1/2 + d0/10);         
    r(1) = rms(d{1} - d1/2);
    s(1) = r(1)<0.1;
    %   ds('l2','',1,d0,d1/2,round(d1 + (d0-0.5)*1.2)/3*2,d{2}/3*2,5)
    n{2} = 'cat_vol_median3c';  % for label maps
    d{2} = cat_vol_median3c(round(d1 + (d0-0.5)*1.2));  % 
    r(2) = rms(d{2} - d1);
    s(2) = rms(round(d1 + (d0-0.5)*1.2) - d1) > r(2);
    
    
    %% NLM
    %  Test reminding noise;
    %    ds('l2','',1,d0,d1/2,d1/2 + d0/10,d{4},10)
    n{3} = 'cat_ornlm';         
    d{3} = cat_ornlm(d1/2 + d0/10,3,1,0.05);
    r(3) = rms(d{3}(:) - d1(:)/2); 
    s(3) = r(3)<0.1;
    % sanlm
    n{4} = 'cat_sanlm';  
    d{4} = d1/2 + d0/10; 
    cat_sanlm(d{4},3,1);
    r(4) = rms(d{4}(:) - d1(:)/2); 
    s(4) = r(4)<0.1;
    

    %% Laplace
    %  Laplace filtering is similar to distance transformation.
    %    ds('d2','',1,d0,d1/2,dc/6 + 0.5/6,d{5}(d1==1) - dc(d1==1)/6 + 0.5/6,5)
    n{5} = 'cat_vol_laplace3';  
    d{5} = cat_vol_laplace3(d1/2,0,1,0.01); 
    r(5) = rms(d{5}(d1==1) - (dc(d1==1)+0.5)/7.5 );   
    s(5) = r(5)<0.05;
    n{6} = 'cat_vol_laplace3R'; 
    d{6} = cat_vol_laplace3R(d1/2,d1==1,0.01); 
    r(6) = rms(d{6}(d1==1) - (dc(d1==1)+0.5)/7.5 );   
    s(6) = r(6)<0.05;

    %% gradient 
    %  compare the result to the matlab function ... 
    %##### HIER GIBTS UNTERSCHIEDE?! ... beim zufälligen bild???
    %    ds('l2','',1,dg,(abs(dx)+abs(dy)+abs(dz))*3,dg,d{7},10)
    n{7} = 'cat_vol_gradient3'; 
    dg   = d1/2+d0/10; 
    [y,x,z] = gradient(dg);
    [dx,dy,dz] = cat_vol_gradient3(dg); 
    d{7} = abs(dx-x)+abs(dy-y)+abs(dz-z); 
    r(7) = rms(dx-x)/3 + rms(dy-y)/3 + rms(dz-z)/3; 
    s(7) = r(7)<0.1;
   
    
    %% voxelbased distance / thickness
    %    ds('l2','',1,d1,d1,d1/2,d{8}/10,10)
    n{8} = 'cat_vbdist';
    d{8} = cat_vbdist(single(d1==0),d1==1);
    r(8) = max(d{8}(d1(:)==1)) - 6; % grid distance 
    s(8) = r(8)>=0 & r(8)<0.5;  
    %  eikonal distance
    %    ds('l2','',1,d1,d1,d1/2,d{9}/10,10)
    n{9} = 'cat_vol_eidist';   
    d{9} = cat_vol_eidist(single(d1==0),ones(size(d1),'single'));
    r(9) = max(d{9}(d1(:)==1)) - 5.5; % distance to boundary 
    s(9) = r(9)>=0 & r(9)<0.5;  
    %  projection-based thickness ############## 
    %    ds('l2','',1,d1,d1,(d1+1)/3,d{10}/10,10)
    n{10} = 'cat_vol_pbtp';      
    [d{10},dpp] = cat_vol_pbtp(d1+1,dw,dc);  %#ok<NASGU>
    r(10) = rms(d{10}(d1==1)) - 5.5; % warum nicht 6?
    s(10) = r(10)<0.05;

    
    %% interpolation
    n{11} = 'cat_vol_interp3f'; sD = size(d0);        
    [Rx,Ry,Rz] = meshgrid(single(1.75:0.5:sD(2)),single(1.75:0.5:sD(1)),single(1.75:0.5:sD(3)));
    d0nan = d0+0; d0nan(isnan(d0)) = 0; 
    dcl   = cat_vol_interp3f(d0nan,Rx,Ry,Rz,'linear'); 
    dcc   = cat_vol_interp3f(d0nan,Rx,Ry,Rz,'cubic'); 
    dml   = interp3(d0nan,Rx,Ry,Rz,'linear'); 
    dmc   = interp3(d0nan,Rx,Ry,Rz,'cubic'); 
    d{11}{1} = dcl - dml; 
    d{11}{2} = dcc - dmc; 
    r(11) = rms(d{11}{1}) + rms(d{11}{2}) ; 
    s(11) = rms(d{11}{1})<10^-6 & rms(d{11}{2})<0.04; 
    
    %% local values
    %    ds('l2','',1,d0,d0,d0,d{12},10)
    n{12} = 'cat_vol_localstat';      
    d{12} = cat_vol_localstat(d0,d1==1,8,1);
    r(12) = rms(cat_stat_nanmean(d0(d1(:)==0)) - d{12}(d1(:)==1));
    s(12) = r(12)<0.05;
    
    %% region growing
    %    ds('l2','',1,d1 + (d0-0.5)/10,dsg,d1,(d1 + (d0-0.5)/10)/2,d{13}{2}*5,10)
    n{13} = 'cat_vol_simgrow'; 
    dsg   = single(cat_vol_morph(d1>1,'d')); dsg(d1==0) = nan; 
    [tmp1 tmp2] = cat_vol_simgrow(dsg,d1 + (d0-0.5)/10,0.05);    
    d{13}{1} = tmp1; d{13}{2} = tmp2;
    % no test yet
    r(13) = rms((d1>0.5) - d{13}{1});
    s(13) = r(12)<0.05;
     
    %% downcut
    %    ds('l2','',1,d1 + (d0-0.5)/10,dsg,(d1 + (d0-0.5)/10)/2,d{14}{2}/200,10)
    n{14} = 'cat_vol_downcut';
    dsg   = single(cat_vol_morph(d1>1,'d')); dsg(d1==0) = nan; 
    [tmp1 tmp2] = cat_vol_downcut(dsg,d1 + (d0-0.5)/10,0.1); 
    d{14}{1} = tmp1; d{14}{2} = tmp2;
    r(14) = rms((d1>0.5) - d{14}{1});
    s(14) = 1;
    
    %% surface genersation
    % Compare a simple cube - vertices should be identical, faces not. 
    n{15} = 'cat_vol_genus0';   
    MS    = isosurface(dcube,0.5);
    [tmp,CS.faces ,CS.vertices ] = cat_vol_genus0(dcube,0.5);
    r(15) = all(all(sortrows(MS.vertices) == sortrows(CS.vertices) )) & ...
            all(size(MS.faces) == size(CS.faces)); 
    s(15) = r(15)==1; 
    if verb==2
      % Smoothed version showed differences, because cat_vol_genus does 
      % not use isovalues. 
      MSs   = isosurface(cat_vol_smooth3X(dcube,2),0.5);
      [tmp,CSs.faces,CSs.vertices] = cat_vol_genus0(cat_vol_smooth3X(dcube,2),0.5);
      figure
      subplot(2,2,1), patch(CS ,'facecolor',[.8 .7 .6]); axis equal off; lighting phong; view(3); camlight; zoom(1.5)
      subplot(2,2,2), patch(MS ,'facecolor',[.8 .7 .6]); axis equal off; lighting phong; view(3); camlight; zoom(1.5)
      subplot(2,2,3), patch(CSs,'facecolor',[.8 .7 .6]); axis equal off; lighting phong; view(3); camlight; zoom(1.8)
      subplot(2,2,4), patch(MSs,'facecolor',[.8 .7 .6]); axis equal off; lighting phong; view(3); camlight; zoom(1.8)
    end
    
    %% NLM upsampling 
    % c-fuction used iterative based on an interpolated image
    try
      n{16} = 'cat_vol_cMRegularizarNLM3D';   
      dnc   = cat_vol_cMRegularizarNLM3D(dcc,3,1,std(d0nan(:))/2,[2 2 2]);
      d{16} = dcl - dnc; 
      r(16) = rms(d{16}); 
      s(16) = rms(d{16})<0.05; 
    end
    
    % Display results
    if verb
      for si=1:numel(s)
        if s(si) 
          cat_io_cprintf([0.0 0.6 0.0],sprintf('%02d)  r=%4.2f  Compilation of "%s" successful!\n',si,r(si),n{si})); 
        else
          cat_io_cprintf([0.6 0.0 0.0],sprintf('%02d)  r=%4.2f  Compilation of "%s" failed!\n',si,r(si),n{si}));
        end
      end
    end
    
    debugname = ['debug_' mexext '.mat'];
    disp(['save ' debugname]);
    save(debugname,'d','CS');
    
    ok = all(s==1);
  else
    ok = 1;
  end
 
  if nargout>0, varargout{1}=ok; end
  if nargout>1, varargout{2}=s;  end  
  if nargout>2, varargout{3}=r;  end  
end
