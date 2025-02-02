
function [Convergence_curve,Ave]=LinearScaling_SMA(N,Max_iter,lb,ub,dim,fobj,Run_no)

for irun=1:Run_no

    bestPositions=zeros(1,dim);
    Destination_fitness=inf;
    AllFitness = inf*ones(N,1);
    weight = ones(N,dim);

    X=initialization(N,dim,ub,lb);
    Convergence_curve=zeros(1,Max_iter);
    it=1;  
    lb=ones(1,dim).*lb; 
    ub=ones(1,dim).*ub;
    z=0.03; 


    while  it <= Max_iter

        for i=1:N
            Flag4ub=X(i,:)>ub;
            Flag4lb=X(i,:)<lb;
            X(i,:)=(X(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
            AllFitness(i) = fobj(X(i,:));
        end

        [SmellOrder,SmellIndex] = sort(AllFitness);  %Eq.(2.6)

	    minFitness = min(AllFitness);
	    maxFitness = max(AllFitness);
	    scaledFitness = (AllFitness - minFitness) / (maxFitness - minFitness);
	    scaledFitness = max(0, min(1, scaledFitness));  % Ensure within [0, 1]

        [SmellOrderScaled,SmellIndexScaled] = sort(scaledFitness);  
        worstFitness = SmellOrderScaled(N);
        bestFitness = SmellOrderScaled(1);

        S=bestFitness-worstFitness+eps;  

        for i=1:N
            for j=1:dim
                if i<=(N/2)  
                    weight(SmellIndexScaled(i),j) = 1+rand()*log10((bestFitness-SmellOrderScaled(i))/(S)+1);
                else
                    weight(SmellIndexScaled(i),j) = 1-rand()*log10((bestFitness-SmellOrderScaled(i))/(S)+1);
                end
            end
        end


        if minFitness < Destination_fitness
            bestPositions=X(SmellIndex(1),:);
            Destination_fitness = minFitness;
        end

        a = atanh(-(it/Max_iter)+1);   
        b = 1-it/Max_iter;

        for i=1:N
            if rand<z    
                X(i,:) = (ub-lb)*rand+lb;
            else
                p =tanh(abs(AllFitness(i)-Destination_fitness));  
                vb = unifrnd(-a,a,1,dim);  
                vc = unifrnd(-b,b,1,dim);
                for j=1:dim
                    r = rand();
                    A = randi([1,N]);  
                    B = randi([1,N]);
                    if r<p    
                        X(i,j) = bestPositions(j)+ vb(j)*(weight(i,j)*X(A,j)-X(B,j));
                    else
                        X(i,j) = vc(j)*X(i,j);
                    end
                end
            end
        end
        Convergence_curve(it)=Destination_fitness;
        best_run(irun)=Destination_fitness;

        it=it+1;
    end
end
Ave = mean(best_run);
fprintf("\nLinearScaling_SMA = %d",Ave);
writeDataToFile(sprintf('LinearScaling_SMA = %d', mean(best_run)), fullfile('Results', 'Numerical_results.txt'));
% save(fullfile('Results', 'SMA_Result.mat'), 'Convergence_curve');
save(fullfile('Results', strrep(func2str(fobj), '@', ''), 'LinearScaling_SMA_Result.mat'), 'Convergence_curve');

end
