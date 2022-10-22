# Introduction
ScatWaveNILM is a scattering wavelet approach for solving the load identification task. The aim is to identify different electrical loads from the current and voltage signatures as provided in many load identification datasets. Furthermore, as load identification is a n important aspect of Non-Intrusive Load Monitoring (NILM) the ScatWaveNILM toolkit can be used to investigate feature invariance for applications like transfer learning in NILM.

# Publication
The BaseNILM toolkit is part of the following NILM paper:

# Datasets
An overview of a few datasets that can be used with the ScatWaveNILM toolkit and their locations:

1) PLAID:  https://kilthub.cmu.edu/articles/dataset/PLAID_2017/11605215
2) WHITED: https://www.cs.cit.tum.de/dis/resources/whited/

Please note that due to the size of the HF datasets these cannot be provided in the repository. The input size of the dataset should be in the following form: 

a) One .mat file per dataset
b) 

# Dependencies
The ScatWaveNILM toolkit was implemented using the following dependencies:
- Matlab R2022a
- Cuda 11

For GPU based calculations CUDA in combination has been used utilizing the Nvidia RTX 3000 series for calculation. The following versions have been tested and proven to work with the ScatWaveNILM toolkit:
- CUDA 11.4
- Driver 472.39

# Usage
For a first test run use start.m to train, test and write results to the console. The initial test run is using SVM as a classifier raw current signatures as features. The test run utilizes 10-fold cross-validation and bayesian hyper parameter optimization, while the data (PLAID2017) has been down-sampled to 3 kHz.

# Results
For the setup described in usage the results can be found below. 

          name            classes      macroAVG    microAVG
    ________________    ___________    ________    ________

    "true_positive"     1×12 double     139.83      139.83 
    "false_positive"    1×12 double     9.5833      9.5833 
    "false_negative"    1×12 double     9.5833      9.5833 
    "true_negative"     1×12 double       1634        1634 
    "precision"         1×12 double    0.87727     0.93586 
    "sensitivity"       1×12 double        NaN     0.93586 
    "specificity"       1×12 double    0.99416     0.99417 
    "accuracy"          1×12 double    0.93586     0.93586 
    "F-measure"         1×12 double        NaN     0.93586 
    
# Development
As failure and mistakes are inextricably linked to human nature, the toolkit is obviously not perfect, thus suggestions and constructive feedback are always welcome. If you want to contribute to the ScatWaveNILM toolkit or spotted any mistake, please contact me via: p.schirmer@herts.ac.uk

# License
The software framework is provided under the MIT license.

# Cite
