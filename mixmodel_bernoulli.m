function [like,theta,p_k]=mixmodel_bernoulli(inputs,M,maxiter)
%
% function [like,mu,covar,mix]=mixmodel(inputs,M,maxiter)
%
% inputs = training data as D dimensional row vectors
% M = number of coins
% maxiter = max number of iterations
% like = vector of log likelihoods at each iteration
%
N=size(inputs,1);
D=size(inputs,2);
like=[];
thresh=1e-6;
converged=0;
iter=0;
ll=-inf;

%my starting ?_k will be 1/M
p_k = ones(M,1)/M;
rng('shuffle')
theta(1:M)= rand(1,M);
heads = zeros(N,1);

for i=1:N
    heads(i) = sum(inputs(i,:) == 1);
end

while (iter<maxiter) & ~converged
  for i=1:M
    for n=1:N
      tau(n,i) = p_k(i)*(theta(i)^heads(n)) * ((1-theta(i))^(D-heads(n)));
    end
  end
  prev=ll;
  ll = 0;
  for n=1:N
      l_n=sum(tau(n,:));
      tau(n,:)=tau(n,:)/l_n;
      for i=1:M
          ll = ll + tau(n,i) + (log(theta(i))*heads(n)) + (log(1-theta(i))*(D-heads(n))) + log(p_k(i));
      end
  end
  
  if (ll-prev<thresh)
    converged=1;
  end
  like=[like ll];
  sumsumtau=0;
  for i=1:M
    sumtau(i)=sum(tau(:,i));
    theta(i) = 0;
    p_k(i)=0;
    for j=1:N
        theta(i) = theta(i) + tau(j,i)*heads(j);
    end
    theta(i) = theta(i)/(D*sumtau(i));
    p_k(i)=sumtau(i);
  end
  p_k = p_k/sum(sumtau);
  iter=iter+1;
end