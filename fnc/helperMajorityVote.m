function [ClassVotes,ClassCounts] = helperMajorityVote(predLabels,origLabels,classes)
% This function is in support of ECGWaveletTimeScatteringExample. It may
% change or be removed in a future release.

% Make categorical arrays if the labels are not already categorical
predLabels = categorical(predLabels);
origLabels = categorical(origLabels);
% Expects both predLabels and origLabels to be categorical vectors
Npred = numel(predLabels);
Norig = numel(origLabels);
Nwin = Npred/Norig;
predLabels = reshape(predLabels,Nwin,Norig);
ClassCounts = countcats(predLabels);
[mxcount,idx] = max(ClassCounts);
ClassVotes = classes(idx);
% Check for any ties in the maximum values and ensure they are marked as
% error if the mode occurs more than once
modecnt = modecount(ClassCounts,mxcount);
ClassVotes(modecnt>1) = categorical({'error'});
ClassVotes = ClassVotes(:);

%-------------------------------------------------------------------------
function modecnt = modecount(ClassCounts,mxcount)
modecnt = Inf(size(ClassCounts,2),1);
for nc = 1:size(ClassCounts,2)
    modecnt(nc) = histc(ClassCounts(:,nc),mxcount(nc));
end

end

% EOF
end
