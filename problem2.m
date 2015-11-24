function coins = mine(M)
%

if nargin < 1
    M=5;
end

dataset = importdata('../data/problem2forHW4.mat');
%load('problem2forHW4.mat');
N=size(dataset,1);

indices = crossvalind('Kfold',N,10);
average_train = zeros(M,1);
average_test = zeros(M,1);
stdev_train = zeros(M,1);
stdev_test = zeros(M,1);

for i=1:M
    train_l = zeros(M,1);
    test_l = zeros(M,1);
    for j = 1:10
        test = dataset(find(indices(:) == j),:);
        train = dataset(find(indices(:) ~= j),:);
        tmp_train_l =[];
        [tmp_train_l, theta, p_k] = mixmodel_bernoulli(train,i,100);
        train_l(j) = tmp_train_l(end);
        test_l(j) = log_l(test,theta,p_k);
    end
    average_train(i) = mean(train_l);
    average_test(i) = mean(test_l);
    stdev_train(i) = std2(train_l);
    stdev_test(i) = std2(test_l);
end

%optimal number of coins
average_test
coins = find(average_test == max(average_test));
    
figure(01);
plot([1:M], stdev_train, [1:M], stdev_test);
legend('Train', 'Test');
xlabel('Number of coins (K)');
ylabel('Stdev Log likelihood (10-fold cross-validation)');

figure(02)
plot([1:M], average_train, [1:M], average_test);
legend('Train', 'Test');
xlabel('Number of coins (K)');
ylabel('Mean Log likelihood (10-fold cross-validation)');
end

function like=log_l(dataset,theta,p_k)

  K = size(p_k, 1);
  N = size(dataset,1);
  D = size(dataset,2);
  
  heads = zeros(N,1);

  for i=1:N
    heads(i) = sum(dataset(i,:) == 1);
  end
  for k=1:K
    for n=1:N
        tau(n,k) = p_k(k)*(theta(k)^(heads(n)))*((1-theta(k))^(D-heads(n)));
    end
  end
  ll=0;
  for n=1:N
    l=sum(tau(n,:));
    tau(n,:)=tau(n,:)/l;
    for k=1:K
        ll = ll + tau(n,k)*(log(theta(k))*(heads(n))+log(1-theta(k))*(D-heads(n))+log(p_k(k)));
    end
  end
  like = ll;
end