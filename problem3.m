function problem3(K)

rawim = Tiff('trees.tif','r');
im = rawim.readRGBAImage();
image = im2double(im(1:200,1:200,:));

%for non randomness comment next line
rng(0,'twister');
%K=3;
k_centers=zeros(K,1,3);
for i=1:K
    k_centers(i,1,:) = rand(3,1);
end
new_centers=zeros(K,1,3);
point_in=zeros(K,1);
ddist=zeros(K,1);
r = randi([1, 200],1,1000);
for i=1:K
    image(r(K+i),r(K+i+1),:);
    k_centers(i,1,:) = image(r(K+i),r(K+i+1),:);
end

%k_centers(1,1,:) = [0 0 0];
%k_centers(2,1,:) = [1 1 1];
%k_centers(1,1,:) = [1 0 0];
%k_centers(2,1,:) = [0 1 0];
%k_centers(3,1,:) = [0 0 1];

k_centers;
first=1;

while 1
    if first == 0
        k_centers(:) = new_centers(:);
    end
    if ~isequal(k_centers,new_centers)
        break;
    end
    first = 0;
    for i=1:200
        for j=1:200
            for n=1:K
                ddist(n) = distance('eucleidian',k_centers(n,1,:),image(i,j,:));
            end
            [M,I] = min(ddist);
            point_in(I) = point_in(I) +1;
            new_centers(I,1,:) = new_centers(I,1,:) + image(i,j,:);
        end
    end
    for n=1:K
        if point_in ~= 0
            point_in(n)
            new_centers(n) = new_centers(n)./point_in(n);
        end
    end
end
new_im = image;
for i=1:200
    for j=1:200
       for n=1:K
            ddist(n) = distance('eucleidian',k_centers(n,1,:),image(i,j,:));
       end
       [M,I] = min(ddist);
       new_im(i,j,:) = k_centers(I,1,:);
    end
end

imshow(new_im);

end

function dist = distance(method,point1,point2)
    euclidDistance = @(x,y)  sqrt(sum( (x-y).^2));
    switch method
        case 'eucleidian'
            dist = euclidDistance(point1, point2);
    end
end