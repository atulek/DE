%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA107
% Project Title: Implementation of Differential Evolution (DE) in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, Differential Evolution (DE) in MATLAB (URL: https://yarpiz.com/231/ypea107-differential-evolution), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;
clear;
close all;

%% Problem Definition

CostFunction = @(x) Sphere(x);    % Cost Function

nVar = 20;            % Number of Decision Variables

VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = -5;          % Lower Bound of Decision Variables
VarMax = 5;          % Upper Bound of Decision Variables

%% DE Parameters

MaxIt = 1000;      % Maximum Number of Iterations

nPop = 50;        % Population Size

beta_min = 0.2;   % Lower Bound of Scaling Factor
beta_max = 0.8;   % Upper Bound of Scaling Factor

pCR = 0.2;        % Crossover Probability

%% Initialization

empty_individual.Position = [];					% boş birey pozisyon bilgisi
empty_individual.Cost = [];					% boş birey maliyet bilgisi

BestSol.Cost = inf;						% boş en iyi çözüm maliyet bilgisi

pop = repmat(empty_individual, nPop, 1);			% boş bireyi popülasyon sayısı kadar çoğalt

for i = 1:nPop							% başlangıç popülasyonu oluştur

    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);		% her birey için pozisyonları min-max aralığında, 
    								% problem boyutu kadar doldur	
    pop(i).Cost = CostFunction(pop(i).Position);		% pozisyonları maliyet problemine gönder,
    								% çözümleri Cost alanına kaydet
    if pop(i).Cost<BestSol.Cost
        BestSol = pop(i);					% en iyi çözümü (hem pozisyon hem maliyet) kaydet
    end
    
end

BestCost = zeros(MaxIt, 1);

%% DE Main Loop

for it = 1:MaxIt		% maksimum iterasyon sayısı kadar
    
    for i = 1:nPop		% her birey için
        
        x = pop(i).Position;	% mevcut bireyin pozisyon bilgisini x'e kopyala
        
        A = randperm(nPop);	% nPop'a kadar olan sayıları rasgele üret (tekrarsız)
        
        A(A == i) = [];		% mevcut bireyin seçilmemesi için o bireyi sil
        
        a = A(1);		% ilk üç bireyi (rasgele) a, b ve c ye aktar
        b = A(2);
        c = A(3);
        
        % Mutation
        %beta = unifrnd(beta_min, beta_max);
        beta = unifrnd(beta_min, beta_max, VarSize);			% betayı hesapla
        y = pop(a).Position+beta.*(pop(b).Position-pop(c).Position);	% a + beta*(b-c) pozisyonları hesapla
        y = max(y, VarMin);						% oluşan yeni pozisyonları min-max değerleri arasında tut
	y = min(y, VarMax);
		
        % Crossover
        z = zeros(size(x));
        j0 = randi([1 numel(x)]);
        for j = 1:numel(x)
            if j == j0 || rand <= pCR
                z(j) = y(j);
            else
                z(j) = x(j);
            end
        end
        
        NewSol.Position = z;
        NewSol.Cost = CostFunction(NewSol.Position);
        
        if NewSol.Cost<pop(i).Cost
            pop(i) = NewSol;
            
            if pop(i).Cost<BestSol.Cost
               BestSol = pop(i);
            end
        end
        
    end
    
    % Update Best Cost
    BestCost(it) = BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end

%% Show Results

figure;
%plot(BestCost);
semilogy(BestCost, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
