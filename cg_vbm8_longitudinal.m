%-----------------------------------------------------------------------
% Job configuration for longitudinal VBM
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.realign.estwrite.data = {'<UNDEFINED>'};
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = {''};
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep;
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tname = 'Session';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec = {};
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).src_output = substruct('.','rmean');
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(2) = cfg_dep;
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(2).tname = 'Session';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(2).tgt_spec = {};
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(2).sname = 'Realign: Estimate & Reslice: Realigned Images (Sess 1)';
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(2).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(2).src_output = substruct('.','sess', '()',{1}, '.','cfiles');
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = {''};
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{3}.spm.tools.vbm8.tools.bias.subj.mov(1) = cfg_dep;
matlabbatch{3}.spm.tools.vbm8.tools.bias.subj.mov(1).tname = 'Longitudinal images for one subject';
matlabbatch{3}.spm.tools.vbm8.tools.bias.subj.mov(1).tgt_spec = {};
matlabbatch{3}.spm.tools.vbm8.tools.bias.subj.mov(1).sname = 'Realign: Estimate & Reslice: Resliced Images (Sess 1)';
matlabbatch{3}.spm.tools.vbm8.tools.bias.subj.mov(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.tools.vbm8.tools.bias.subj.mov(1).src_output = substruct('.','sess', '()',{1}, '.','rfiles');
matlabbatch{3}.spm.tools.vbm8.tools.bias.bias_opts.nits = 8;
matlabbatch{3}.spm.tools.vbm8.tools.bias.bias_opts.fwhm = 60;
matlabbatch{3}.spm.tools.vbm8.tools.bias.bias_opts.reg = 1e-06;
matlabbatch{3}.spm.tools.vbm8.tools.bias.bias_opts.lmreg = 1e-06;
matlabbatch{4}.spm.tools.vbm8.estwrite.data(1) = cfg_dep;
matlabbatch{4}.spm.tools.vbm8.estwrite.data(1).tname = 'Volumes';
matlabbatch{4}.spm.tools.vbm8.estwrite.data(1).tgt_spec = {};
matlabbatch{4}.spm.tools.vbm8.estwrite.data(1).sname = 'Realign: Estimate & Reslice: Mean Image';
matlabbatch{4}.spm.tools.vbm8.estwrite.data(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.tools.vbm8.estwrite.data(1).src_output = substruct('.','rmean');
matlabbatch{4}.spm.tools.vbm8.estwrite.extopts.dartelwarp = 1;
matlabbatch{4}.spm.tools.vbm8.estwrite.extopts.print = 1;
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.tpm = {fullfile(spm('dir'),'toolbox','Seg','TPM.nii')};
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.affmethod = 1;
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.affreg = 'mni';
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
matlabbatch{4}.spm.tools.vbm8.estwrite.opts.samp = 3;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.GM.native = 1;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.GM.warped = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.GM.modulated = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.GM.dartel = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.WM.native = 1;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.WM.warped = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.WM.modulated = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.WM.dartel = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.CSF.native = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.CSF.warped = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.CSF.modulated = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.CSF.dartel = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.bias.native = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.bias.warped = 1;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.bias.affine = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.label.native = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.label.warped = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.label.dartel = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.jacobian.warped = 0;
matlabbatch{4}.spm.tools.vbm8.estwrite.output.warps = [1 0];
matlabbatch{5}.spm.tools.vbm8.estwrite.data(1) = cfg_dep;
matlabbatch{5}.spm.tools.vbm8.estwrite.data(1).tname = 'Volumes';
matlabbatch{5}.spm.tools.vbm8.estwrite.data(1).tgt_spec = {};
matlabbatch{5}.spm.tools.vbm8.estwrite.data(1).sname = 'Intra-subject bias correction: Bias corrected images (Subj 1)';
matlabbatch{5}.spm.tools.vbm8.estwrite.data(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.tools.vbm8.estwrite.data(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{5}.spm.tools.vbm8.estwrite.extopts.dartelwarp = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.extopts.print = 1;
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.tpm = {fullfile(spm('dir'),'toolbox','Seg','TPM.nii')};
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.ngaus = [2 2 2 3 4 2];
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.biasreg = 0.0001;
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.biasfwhm = 60;
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.affmethod = 1;
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.affreg = 'mni';
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.warpreg = 4;
matlabbatch{5}.spm.tools.vbm8.estwrite.opts.samp = 3;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.GM.native = 1;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.GM.warped = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.GM.modulated = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.GM.dartel = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.WM.native = 1;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.WM.warped = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.WM.modulated = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.WM.dartel = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.CSF.native = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.CSF.warped = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.CSF.modulated = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.CSF.dartel = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.bias.native = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.bias.warped = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.bias.affine = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.label.native = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.label.warped = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.label.dartel = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.jacobian.warped = 0;
matlabbatch{5}.spm.tools.vbm8.estwrite.output.warps = [0 0];
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(1) = cfg_dep;
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(1).tname = 'Session';
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(1).tgt_spec = {};
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(1).sname = 'VBM8: Estimate & Write: p1 Images';
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(1).src_output = substruct('.','tiss', '()',{1}, '.','c', '()',{':'});
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(2) = cfg_dep;
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(2).tname = 'Session';
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(2).tgt_spec = {};
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(2).sname = 'VBM8: Estimate & Write: p1 Images';
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(2).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{6}.spm.spatial.realign.estimate.data{1}(2).src_output = substruct('.','tiss', '()',{1}, '.','c', '()',{':'});
matlabbatch{6}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch{6}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch{6}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
matlabbatch{6}.spm.spatial.realign.estimate.eoptions.rtm = 1;
matlabbatch{6}.spm.spatial.realign.estimate.eoptions.interp = 2;
matlabbatch{6}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch{6}.spm.spatial.realign.estimate.eoptions.weight = {''};
matlabbatch{7}.spm.tools.vbm8.tools.defs.field(1) = cfg_dep;
matlabbatch{7}.spm.tools.vbm8.tools.defs.field(1).tname = 'Deformation Field';
matlabbatch{7}.spm.tools.vbm8.tools.defs.field(1).tgt_spec = {};
matlabbatch{7}.spm.tools.vbm8.tools.defs.field(1).sname = 'VBM8: Estimate & Write: Deformation Field';
matlabbatch{7}.spm.tools.vbm8.tools.defs.field(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.spm.tools.vbm8.tools.defs.field(1).src_output = substruct('()',{1}, '.','fordef', '()',{':'});
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(1) = cfg_dep;
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(1).tname = 'Apply to';
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(1).tgt_spec = {};
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(1).sname = 'VBM8: Estimate & Write: p1 Images';
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(1).src_output = substruct('.','tiss', '()',{1}, '.','c', '()',{':'});
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(2) = cfg_dep;
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(2).tname = 'Apply to';
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(2).tgt_spec = {};
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(2).sname = 'VBM8: Estimate & Write: p2 Images';
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(2).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{7}.spm.tools.vbm8.tools.defs.fnames(2).src_output = substruct('.','tiss', '()',{2}, '.','c', '()',{':'});
matlabbatch{7}.spm.tools.vbm8.tools.defs.interp = 5;
matlabbatch{7}.spm.tools.vbm8.tools.defs.modulate = 0;
