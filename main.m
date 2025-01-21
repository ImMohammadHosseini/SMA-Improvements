clear all;
clc;
create_folder_file();

Run_number = 1;
Agent_number = 50;
Max_iteration = 200;

for i=1:23
    [lb,ub,dim,fobj]=Get_Functions_details(['F' num2str(i)]);
    fprintf("\n**************** F%d ****************",i);
    writeDataToFile(sprintf("**************** F%d ****************",i), fullfile('Results', 'Numerical_results.txt'));


    %% EO
    [Convergence_curve_EO,best_EO]=EO(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %% EO2
    [Convergence_curve_EO2_best_EO2]=EO2(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %% IMPEO
    [Convergence_curve_IMPEO,Apply_Diffusion_best_IMPEO]=IMPEO(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %%  GSA
    [Convergence_curve_GSA,best_GSA]=GSA(i,Agent_number,Max_iteration,Run_number);
    %% GWO
    [Convergence_curve_GWO, best_GWO]=GWO(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %% HHO
    [Convergence_curve_HHO, best_HHO]=HHO(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %% MVO
    [Convergence_curve_MVO, best_MVO]=MVO(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %% SMA
    [Convergence_curve_SMA, best_SMA]=SMA(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %% WOA
    [Convergence_curve,best_WOA]=WOA(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);


end


    %     %% PSO
    %     [Convergence_curve_PSO, best_PSO]=PSO(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);
    %     %% SSA
    %     [Convergence_curve,best_SSA]=SSA(Agent_number,Max_iteration,lb,ub,dim,fobj,Run_number);