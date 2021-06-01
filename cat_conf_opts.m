function opts = cat_conf_opts(expert)
% Configuration file for CAT SPM options
%
% ______________________________________________________________________
%
% Christian Gaser, Robert Dahnke
% Structural Brain Mapping Group (http://www.neuro.uni-jena.de)
% Departments of Neurology and Psychiatry
% Jena University Hospital
% ______________________________________________________________________
% $Id$
%#ok<*AGROW>

if ~exist('expert','var')
  expert = 0; % switch to de/activate further GUI options
end


%------------------------------------------------------------------------
% various options for estimating the segmentations
%------------------------------------------------------------------------


% tpm:
%------------------------------------------------------------------------
tpm         = cfg_files;
tpm.tag     = 'tpm';
tpm.name    = 'Tissue Probability Map';
tpm.filter  = 'image';
tpm.ufilter = '.*';
tpm.def     =  @(val)cat_get_defaults('opts.tpm', val{1});
tpm.help    = {
  'Select the tissue probability image that includes 6 tissue probability classes for (1) grey matter, (2) white matter, (3) cerebrospinal fluid, (4) bone, (5) non-brain soft tissue, and (6) the background.  CAT uses the TPM only for the initial SPM segmentation.  Hence, it is more independent and allows accurate and robust processing even with the standard TPM in case of strong anatomical differences, e.g. very old/young brains.  Nevertheless, for children data we recommend to use customized TPMs created using the Template-O-Matic toolbox. '
  ''
  'The default tissue probability maps are modified versions of the ICBM Tissue Probabilistic Atlases.  These tissue probability maps are kindly provided by the International Consortium for Brain Mapping, John C. Mazziotta and Arthur W. Toga. http://www.loni.ucla.edu/ICBM/ICBM_TissueProb.html.'
  ''
  'The original data are derived from 452 T1-weighted scans, which were aligned with an atlas space, corrected for scan inhomogeneities, and classified into grey matter, white matter and cerebrospinal fluid.  These data were then affine registered to the MNI space and down-sampled to 1.5 mm resolution.  Rather than assuming stationary prior probabilities based upon mixing proportions, additional information is used, based on other subjects'' brain images.  Priors are usually generated by registering a large number of subjects together, assigning voxels to different tissue types and averaging tissue classes over subjects.  The algorithm used here will employ these priors for the first initial segmentation and normalization.  Six tissue classes are used: grey matter, white matter, cerebrospinal fluid, bone, non-brain soft tissue and air outside of the head and in nose, sinus and ears.  These maps give the prior probability of any voxel in a registered image being of any of the tissue classes - irrespective of its intensity.  The model is refined further by allowing the tissue probability maps to be deformed according to a set of estimated parameters.  This allows spatial normalisation and segmentation to be combined into the same model.  Selected tissue probability map must be in multi-volume nifti format and contain all six tissue priors. '
  ''
};
tpm.num     = [1 1];
tpm.def     =  @(val)cat_get_defaults('opts.tpm', val{:});
if expert>1
  tpm.help  = [tpm.help 
   {
    'In case of multiple TPMs, the original image is affine registrated to each TPM and a kmeans algorithm is used to fit 3 classes. The best two images with the lowest standard deviations are combined to a new less biased TPM. The TPMs must include the same classes in MNI space!'
    ''
   }]; 
  tpm.num   = [1 inf];
end


% ngaus:
%------------------------------------------------------------------------
% The default of SPM12 [GM,WM,CSF,bone,head tissue,BG] was [1,1,2,3,4,2]
% and works very well for most data and the segmentation did not benefit by 
% more classes. There are no systematic effects for interferences or 
% special anatomical properties (e.g. WMHs)!
%------------------------------------------------------------------------
ngaus         = cfg_entry;
ngaus.tag     = 'ngaus';
ngaus.name    = 'Gaussians per class';
ngaus.strtype = 'n';
ngaus.num     = [1 6];
ngaus.def     = @(val)cat_get_defaults('opts.ngaus', val{:});
ngaus.help    = {
  'The number of Gaussians used to represent the intensity distribution for each tissue class can be greater than one.  In other words, a tissue probability map may be shared by several clusters.  The assumption of a single Gaussian distribution for each class does not hold for a number of reasons.  In particular, a voxel may not be purely of one tissue type, and instead contain signal from a number of different tissues (partial volume effects).  Some partial volume voxels could fall at the interface between different classes, or they may fall in the middle of structures such as the thalamus, which may be considered as being either grey or white matter.  Various other image segmentation approaches use additional clusters to model such partial volume effects.  These generally assume that a pure tissue class has a Gaussian intensity distribution, whereas intensity distributions for partial volume voxels are broader, falling between the intensities of the pure classes.  Unlike these partial volume segmentation approaches, the model adopted here simply assumes that the intensity distribution of each class may not be Gaussian, and assigns belonging probabilities according to these non-Gaussian distributions.  Typical numbers of Gaussians could be one to three for grey and white matter, two for CSF, three for bone, four for other soft tissues and two for air (background).'
  ''
  ...'Note that if any of the Num. Gaussians is set to non-parametric, then a non-parametric approach will be used to model the tissue intensities.  This may work for some images (eg CT), but not others - and it has not been optimised for multi-channel data. Note that it is likely to be especially problematic for images with poorly behaved intensity histograms due to aliasing effects that arise from having discrete values on the images.'
  ...''
};


biasacc         = cfg_menu;
biasacc.tag     = 'biasacc';
biasacc.name    = 'Strength of SPM Inhomogeneity Correction';
biasacc.def     = @(val)cat_get_defaults('opts.biasstr', val{:});
biasacc.labels  = {'light','medium','strong','heavy'};
biasacc.values  = {0.25 0.50 0.75 1.00};
biasacc.help    = {
  'Strength of the SPM inhomogeneity (bias) correction that simultaneously controls the SPM biasreg, biasfwhm, samp (resolution), and tol (iteration) parameter.  Modify this value only if you experience any problems!  Use smaller values for slighter corrections (e.g. in synthetic contrasts without visible bias) and higher values for stronger corrections (e.g. in 3 or 7 Tesla data with strong visible bias).  Stronger corrections often improve cortical results but can also cause overcorrection in larger GM structures such as the subcortical structurs, thalamus, or amygdala and will take longer.  Bias correction is further controlled by the Affine Preprocessing (APP). '
  ''
};

%------------------------------------------------------------------------
% Bias correction
%------------------------------------------------------------------------
biasstr         = cfg_menu;
biasstr.tag     = 'biasstr';
biasstr.name    = 'Strength of SPM Inhomogeneity Correction';
biasstr.def     = @(val)cat_get_defaults('opts.biasstr', val{:});
if ~expert
  biasstr.labels  = {'light','medium','strong'};
  biasstr.values  = {0.25 0.50 0.75};
  %biasstr.labels  = {'ultralight','light','medium','strong','heavy'};
  %biasstr.values  = {0 0.25 0.50 0.75 1};
  biasstr.help    = {
    'Strength of the SPM inhomogeneity (bias) correction that simultaneously controls the SPM biasreg and biasfwhm parameter.  Modify this value only if you experience any problems!  Use smaller values for slighter corrections (e.g. in synthetic contrasts without visible bias) and higher values for stronger corrections (e.g. in 3 or 7 Tesla data with strong visible bias).  Bias correction is further controlled by the Affine Preprocessing (APP). '
    ''
  };
elseif expert>=1
  biasstr.labels  = {'ultralight (eps)','light (0.25)','medium (0.50)','strong (0.75)','heavy (1.00)'};
  biasstr.values  = {eps 0.25 0.50 0.75 1};
  biasstr.help = {
    'Strength of the SPM inhomogeneity (bias) correction that simultaneously controls the SPM biasreg and biasfwhm parameter.  Modify this value only if you experience any problems!  Use smaller values (>0) for slighter corrections (e.g. in synthetic contrasts without visible bias) and higher values (<=1) for stronger corrections (e.g. in 7 Tesla data).  Bias correction is further controlled by the Affine Preprocessing (APP). '
    ''
    '  biasreg	  =  min(  10 , max(  0 , 10^-(biasstr*2 + 2) )) '
    '  biasfwhm	  =  min( inf , max( 30 , 30 + 60*(1-biasstr) )) '
    ''
    '                  biasstr   biasfwhm   biasreg'
    '  ultralight:     eps       90         0.0100 '
    '  light:          0.25      75         0.0032 '
    '  medium:         0.50      60         0.0010 '
    '  strong:         0.75      45         0.0003 '
    '  heavy:          1.00      30         0.0001 '
  };
%{
elseif expert==2
  biasstr.labels  = {'use SPM bias parameter (0)','ultralight (eps)','light (0.25)','medium (0.50)','strong (0.75)','heavy (1.00)'};
  biasstr.values  = {0 eps 0.25 0.50 0.75 1};
  biasstr.help = {
    'Strength of the SPM inhomogeneity (bias) correction that simultaneously controls the SPM biasreg and biasfwhm parameter.  Modify this value only if you experience any problems!  Use smaller values (>0) for slighter corrections (e.g. in synthetic contrasts without visible bias) and higher values (<=1) for stronger corrections (e.g. in 7 Tesla data).  The value 0 will use the original SPM biasreg and biasfwhm parameter of the cat_defaults file.  Bias correction is further controlled by the Affine Preprocessing (APP). '
    ''
    '  biasreg	  =  min(  10 , max(  0 , 10^-(biasstr*2 + 2) )) '
    '  biasfwhm	  =  min( inf , max( 30 , 30 + 60*(1-biasstr) )) '
    ''
    '                  biasstr   biasfwhm   biasreg'
    '  SPM parameter:  -         -          -      '
    '  ultralight:     eps       90         0.0100 '
    '  light:          0.25      75         0.0032 '
    '  medium:         0.50      60         0.0010 '
    '  strong:         0.75      45         0.0003 '
    '  heavy:          1.00      30         0.0001 '
  };
%}
end
  

% biasreg: 
%------------------------------------------------------------------------
% Test on the BWP and real data demonstrate that 0.001 mm works best in
% average, whereas some image benefit by more regularisation (0.01) and strong
% bias requires less regularisation (0.0001). There are no special cases
% that benefit by a regularisation >0.01 or <0.0001! Hence, I removed
% these entries (RD 2017-03).
%------------------------------------------------------------------------
biasreg        = cfg_menu;
biasreg.tag    = 'biasreg';
biasreg.name   = 'Bias regularisation';
biasreg.def    = @(val)cat_get_defaults('opts.biasreg', val{:});
if 0
  biasreg.labels = {'No regularisation (0)','Extremely light regularisation (0.00001)','Very light regularisation (0.0001)','Light regularisation (0.001)','Medium regularisation (0.01)','Heavy regularisation (0.1)','Very heavy regularisation (1)','Extremely heavy regularisation (10)'};
  biasreg.values = {0, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1.0, 10};
else
  biasreg.labels = {'Very light regularisation (0.0001)','Light regularisation (0.001)','Medium regularisation (0.01)'};
  biasreg.values = {0.0001, 0.001, 0.01};
end
biasreg.help   = {
  'Regularisation of the SPM bias field.  This parameter is controlled by the biasreg parameter if biasstr>0. Test on the BWP and real data showed that optimal corrections was in range of 0.01 and 0.0001.'
  ''
  'MR images are usually corrupted by a smooth, spatially varying artefact that modulates the intensity of the image (bias).  These artefact, although not usually a problem for visual inspection, can impede automated processing of the images.  An important issue relates to the distinction between intensity variations that arise because of bias artifact due to the physics of MR scanning, and those that arise due to different tissue properties.  The objective is to model the latter by different tissue classes, while modelling the former with a bias field.  We know a priori that intensity variations due to MR physics tend to be spatially smooth, whereas those due to different tissue types tend to contain more high frequency information.  A more accurate estimate of a bias field can be obtained by including prior knowledge about the distribution of the fields likely to be encountered by the correction algorithm.  For example, if it is known that there is little or no intensity non-uniformity, then it would be wise to penalise large values for the intensity non-uniformity parameters.  This regularisation can be placed within a Bayesian context, whereby the penalty incurred is the negative logarithm of a prior probability for any particular pattern of non-uniformity.  Knowing what works best should be a matter of empirical exploration.  For example, if your data has very little intensity non-uniformity artifact, then the bias regularisation should be increased.  This effectively tells the algorithm that there is very little bias in your data, so it does not try to model it.  '
  ''
};


% biasfwhm:
%------------------------------------------------------------------------
% Test on the BWP and real data demonstrate that 60 mm works best for most
% datasets. Only 7 Tesla data need further adaptation, larger filter size is
% normaly not required (RD 2017-03)!
%  - 30-40 mm: low filter size for very strong fields (e.g. 7 or 3 Tesla data)
%  - 50-60 mm: medium filter size works best for >95% of the data, and do not overfit in case of low bias 
%  - 70-90 mm: high filter size in case of low bias data
%  -   >90 mm: better to avoid that, because there is mostly a low bias in the data that is normally not visible 
%------------------------------------------------------------------------
biasfwhm        = cfg_menu;
biasfwhm.tag    = 'biasfwhm';
biasfwhm.name   = 'Bias FWHM';
if 0
  biasfwhm.labels = {'30mm cutoff','40mm cutoff','50mm cutoff','60mm cutoff','70mm cutoff','80mm cutoff','90mm cutoff','100mm cutoff','110mm cutoff','120mm cutoff','130mm cutoff','140mm cutoff','150mm cutoff','No correction'};
  biasfwhm.values = {30,40,50,60,70,80,90,100,110,120,130,140,150,Inf};
else
  biasfwhm.labels = {'30mm cutoff','40mm cutoff','50mm cutoff','60mm cutoff','70mm cutoff','80mm cutoff','90mm cutoff'};
  biasfwhm.values = {30,40,50,60,70,80,90};
end
biasfwhm.def    = @(val)cat_get_defaults('opts.biasfwhm', val{:});
biasfwhm.help   = {
  'FWHM of Gaussian smoothness of bias.  This parameter is controlled by the biasreg parameter if biasstr>0.  Test on the BWP and real data showed that 50 to 60 mm works best for nearly all datasets and only some 7 Tesla scans require further adaptation! '
  '  30-40 mm:  low filter size for very strong fields (e.g. 7 or 3 Tesla data) '
  '  50-60 mm:  medium filter size works best for >95% of the data, and do not overfit in case of low bias '
  '  70-90 mm:  high filter size in case of low bias data '
  ''
  'If your intensity non-uniformity is very smooth, then choose a large FWHM.  This will prevent the algorithm from trying to model out intensity variation due to different tissue types.  The model for intensity non-uniformity is one of i.i.d. Gaussian noise that has been smoothed by some amount, before taking the exponential.  Note also that smoother bias fields need fewer parameters to describe them.  This means that the algorithm is faster for smoother intensity non-uniformities.  '
  ''
};

biasspm        = cfg_branch;
biasspm.tag    = 'spm';
biasspm.name   = 'Original SPM bias correction parameter';
biasspm.val    = {biasfwhm biasreg};
biasspm.help   = {
  'SPM bias correction parameter biasfwhm and biasreg.' 
}; 

bias        = cfg_choice;
bias.tag    = 'bias';
bias.name   = 'Biascorrection parameter';
if cat_get_defaults('opts.biasstr')>0
  bias.val = {biasstr};
else
  bias.val = {biasspm};
end
bias.values = {biasstr biasspm};
bias.help   = {
  'Bias correction parameters.' 
}; 







% warpreg: 
%------------------------------------------------------------------------
% no useful changes in the following testcases:
%   [0 0.001  0.5   0.05 0.2]   % the default setting
%   [0 0.0001 0.001 0.01 0.1]   % lower  initial regularision with stepwise increasement 
%   [0 0.001  0.01  0.1  0.2]   % low    initial regularision with stepwise increasement 
%   [0.5 0.4  0.3   0.2  0.1]   % medium initial regularision with stepwise decreasment 
%   [1.0 0.8  0.6   0.4  0.2]   % 
%   [0.0 0.8  0.2   0.8  0.2]   % 
%------------------------------------------------------------------------
warpreg         = cfg_entry;
warpreg.def     = @(val)cat_get_defaults('opts.warpreg', val{:});
warpreg.tag     = 'warpreg';
warpreg.name    = 'Warping Regularisation';
warpreg.strtype = 'r';
warpreg.num     = [1 5];
warpreg.help    = {
  'The objective function for registering the tissue probability maps to the image to process, involves minimising the sum of two terms.  One term gives a function of how probable the data is given the warping parameters.  The other is a function of how probable the parameters are, and provides a penalty for unlikely deformations.  Smoother deformations are deemed to be more probable.  The amount of regularisation determines the tradeoff between the terms.  Pick a value around one.  However, if your normalised images appear distorted, then it may be an idea to increase the amount of regularisation (by an order of magnitude).  More regularisation gives smoother deformations, where the smoothness measure is determined by the bending energy of the deformations. '
  ''
};


% affreg
%------------------------------------------------------------------------
% no large differences 
% - mni was most stable
% - rigid did not work in ~20% of the cases (and is of course not meaningful here)
% - subj and none led to identical results 
% - no registration only for animals
%------------------------------------------------------------------------
affreg        = cfg_menu;
affreg.tag    = 'affreg';
affreg.name   = 'Affine Regularisation';
affreg.help   = {
  'The procedure is a local optimisation, so it needs reasonable initial starting estimates.  Images should be placed in approximate alignment using the Display function of SPM before beginning.  A Mutual Information affine registration with the tissue probability maps (D''Agostino et al, 2004) is used to achieve approximate alignment.  Note that this step does not include any model for intensity non-uniformity.  This means that if the procedure is to be initialised with the affine registration, then the data should not be too corrupted with this artifact.  If there is a lot of intensity non-uniformity, then manually position your image in order to achieve closer starting estimates, and turn off the affine registration.  Affine registration into a standard space can be made more robust by regularisation (penalising excessive stretching or shrinking).  The best solutions can be obtained by knowing the approximate amount of stretching that is needed (e.g. ICBM templates are slightly bigger than typical brains, so greater zooms are likely to be needed). For example, if registering to an image in ICBM/MNI space, then choose this option.  If registering to a template that is close in size, then select the appropriate option for this.'
  ''
};
if expert
  affreg.labels = {'ICBM space template - European brains','ICBM space template - East Asian brains','No regularisation','No Affine Registration'};
  affreg.values = {'mni','eastern','none',''};
  affreg.help   = [affreg.help {
    'No affine registration was added for processing of animals, where registration may fail!'
    ''
  }];
else
  affreg.labels = {'ICBM space template - European brains','ICBM space template - East Asian brains','No regularisation'};
  affreg.values = {'mni','eastern','none'};
end
affreg.def    = @(val)cat_get_defaults('opts.affreg', val{:});



% samp:
%------------------------------------------------------------------------
% Surprisingly, there is no systematical advantage in using higher
% resolution! Only very slightly in single cases, e.g. 7 Tesla. 
%------------------------------------------------------------------------
samp         = cfg_entry;
samp.tag     = 'samp';
samp.name    = 'Sampling distance';
samp.strtype = 'r';
samp.num     = [1 1];
samp.def     = @(val)cat_get_defaults('opts.samp', val{:});
samp.help    = {
  'This encodes the approximate distance between sampled points when estimating the model parameters.  Smaller values use more of the data, but the procedure is slower and needs more memory.  Determining the "best" setting involves a compromise between speed and accuracy.'
  ''
};

% SPM processing accuracy
tol         = cfg_menu;
tol.tag     = 'tol';
tol.name    = 'SPM iteration accuracy';
tol.help    = { ...
    'Parameter to control the iteration stop criteria of SPM preprocessing functions. In most cases the standard value is good enough for the initialization in CAT. However, some images with servere (local) inhomogeneities or atypical anatomy may benefit by further iterations. '
  };
tol.def    = @(val)cat_get_defaults('opts.tol', val{:}); 
tol.labels = {'average (default)' 'high (slow)' 'ultra high (very slow)'};
tol.values = {1e-4 1e-8 1e-16};
if 0 %expert
  tol.labels = [{'ultra low (superfast)' 'low (fast)'} tol.labels];
  tol.values = [{1e-1 1e-2} tol.values];
end

% single parameter 
accspm        = cfg_branch;
accspm.tag    = 'spm';
accspm.name   = 'Original SPM accuracy parameter';
accspm.val    = {samp tol};
accspm.help   = {
  'Official SPM resolution parameter "samp" and internal SPM iteration parameter "tol".' 
}; 

% combined SPM processing accuracy parameter
accstr         = cfg_menu;
accstr.tag     = 'accstr';
accstr.name    = 'SPM processing accuracy';
accstr.help    = { ...
    'Parameter to control the accuracy of SPM preprocessing functions. In most images the standard accuracy is good enough for the initialization in CAT. However, some images with severe (local) inhomogeneities or atypical anatomy may benefit by additional iterations and higher resolution. '
  };
accstr.labels = {'average (default)' 'high (slow)' 'ulta high (very slow)'};
accstr.values = {0.5 0.75 1.0};
accstr.def    = @(val)cat_get_defaults('opts.accstr', val{:}); % no cat_defaults entry
if expert
  %accstr.labels = [{'ultra low (superfast)' 'low (fast)'} accstr.labels];
  %accstr.values = [{0 0.25} accstr.values];
  accstr.help   = [accstr.help; 
   {''
   ['Overview of parameters: ' ...
    '  accstr:  0.50   0.75   1.00' ...
    '  samp:    3.00   2.00   1.00 (in mm)' ...
    '  tol:     1e-4   1e-8   1e-16' ...
    '' ...
    'SPM default is samp = 3 mm with tol = 1e-4. ']}];
end

% single parameter
acc        = cfg_choice;
acc.tag    = 'acc';
acc.name   = 'SPM preprocessing accuracy parameters';
if cat_get_defaults('opts.accstr')>0
  acc.val  = {accstr};
else
  acc.val  = {accspm};
end
acc.values = {accstr accspm};
acc.help   = {
  'Choose between single or combined SPM preprocessing accuracy parameters.' 
}; 


redspmres         = cfg_entry;
redspmres.tag     = 'redspmres';
redspmres.name    = 'SPM preprocessing output resolution limit';
redspmres.strtype = 'r';
redspmres.num     = [1 1];
redspmres.def     = @(val)cat_get_defaults('opts.redspmres', val{:});
redspmres.help    = {'Limit SPM preprocessing resolution to improve robustness and performance. Use 0 to process data in the full internal resolution.' ''};


%------------------------------------------------------------------------
opts      = cfg_branch;
opts.tag  = 'opts';
opts.name = 'Options for initial SPM12 preprocessing';
opts.help = {
    'CAT uses the Unified Segmentation of SPM12 for initial registration, bias correction, and segmentation.  The parameters used here were optimized for a variety of protocols and anatomies.  Only in case of strong inhomogeneity of high-field MR scanners we recommend to increase the biasstr parameter.  For children data we recommend to use customized TPMs created by the Template-O-Matic toolbox. '  
    ''
  };
if expert>1
  opts.val  = {tpm,affreg,ngaus,warpreg,bias,acc,redspmres};
  opts.help = [opts.help; {
    'Increasing the initial sampling resolution to 1.5 or 1.0 mm may help in some cases of strong inhomogeneity but in general it only increases processing time.'
    ''
    'Strength of the bias correction "biasstr" controls the biasreg and biasfwhm parameter if biasstr>0!'
    ''
  }];
elseif expert==1
  opts.val  = {tpm,affreg,biasstr,accstr};
  opts.help = [opts.help; {
    'Increasing the initial sampling resolution to 1.5 or 1.0 mm ma help in some cases of strong inhomogeneity but in general it only increases processing time.'
    ''
  }];
else
  opts.val  = {tpm,affreg,biasacc};
   
end

