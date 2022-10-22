function [y1] = createLabels(y,W,setupMdl)
if setupMdl.name == "SVM" || setupMdl.name == "KNN" || setupMdl.name == "RF"
    y1 = cell(W*length(y), 1);
    iii = 1;
    for i = 1:length(y)
        for ii = 1:W
            y1{iii} = y{i};
            iii = iii + 1;
        end
    end
else
    y1 = zeros(W*length(y), 1);
    iii = 1;
    for i = 1:length(y)
        for ii = 1:W
            y1(iii) = y(i);
            iii = iii + 1;
        end
    end
end
end