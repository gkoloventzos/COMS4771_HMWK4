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
theta = rand(M,1);
heads = zeros(N,1);
tails = zeros(N,1);

for i=1:N
    heads(i) = sum(inputs(i,:) == 1);
end

while (iter<maxiter) & ~converged
  iter
  prev=ll;
  ll=0;
  tau=ones(N,M);
  for i=1:M
    for n=1:N
      tau(n,i) = p_k(i)*(theta(i)^heads(n) * (1-theta(i))^(N-heads(n)));
    end
  end
  for n=1:N
    l_n=sum(tau(n,:));
    tau(n,:)=tau(n,:)./l_n;
    ll=ll+log(l_n);
  end
  if (ll-prev<thresh)
    converged=1;
  end
  like=[like ll];
  for i=1:M
    sumtau=sum(tau(:,i));
    p_k(i)=sumtau/N;
    theta(i) = 0;
    for j=1:N
        theta(i) = theta(i) + tau(j,i)*heads(j);
    end
    theta(i) = theta(i)/sumtau;
  end
  iter=iter+1;
end