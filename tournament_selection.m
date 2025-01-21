function selected = tournament_selection(fitness, N, tournament_size)
    selected = zeros(1, N);
    
    for i = 1:N
        % Randomly select tournament_size individuals
        tournament_individuals = randi([1, N], [1, tournament_size]);
        tournament_fitness = fitness(tournament_individuals);
        
        % Select the individual with the best fitness in the tournament
        [~, best_idx] = min(tournament_fitness);  % Assuming minimization
        selected(i) = tournament_individuals(best_idx);
    end
end
