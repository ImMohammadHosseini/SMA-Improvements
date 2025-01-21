
function [Convergence_curve,Ave]=SMA(N,Max_iter,lb,ub,dim,fobj,Run_no)

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
	
	maxFitness = max(AllFitness);
	scaledFitness = (exp(AllFitness) - 1) / (exp(maxFitness) - 1);

        [SmellOrder,SmellIndex] = sort(scaledFitness);  %Eq.(2.6)
        worstFitness = SmellOrder(N);
        bestFitness = SmellOrder(1);

        S=bestFitness-worstFitness+eps;  % plus eps to avoid denominator zero


        for i=1:N
            for j=1:dim
                if i<=(N/2)  %Eq.(2.5)
                    weight(SmellIndex(i),j) = 1+rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
                else
                    weight(SmellIndex(i),j) = 1-rand()*log10((bestFitness-SmellOrder(i))/(S)+1);
                end
            end
        end


        if bestFitness < Destination_fitness
            bestPositions=X(SmellIndex(1),:);
            Destination_fitness = bestFitness;
        end

        a = atanh(-(it/Max_iter)+1);   %Eq.(2.4)
        b = 1-it/Max_iter;

        for i=1:N
            if rand<z     %Eq.(2.7)
                X(i,:) = (ub-lb)*rand+lb;
            else
                p =tanh(abs(AllFitness(i)-Destination_fitness));  %Eq.(2.2)
                vb = unifrnd(-a,a,1,dim);  %Eq.(2.3)
                vc = unifrnd(-b,b,1,dim);
                for j=1:dim
                    r = rand();
                    A = randi([1,N]);  % two positions randomly selected from population
                    B = randi([1,N]);
                    if r<p    %Eq.(2.1)
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
fprintf("\nSMA = %d",Ave);
writeDataToFile(sprintf('SMA = %d', mean(best_run)), fullfile('Results', 'Numerical_results.txt'));
% save(fullfile('Results', 'SMA_Result.mat'), 'Convergence_curve');
save(fullfile('Results', strrep(func2str(fobj), '@', ''), 'SMA_Result.mat'), 'Convergence_curve');

end
