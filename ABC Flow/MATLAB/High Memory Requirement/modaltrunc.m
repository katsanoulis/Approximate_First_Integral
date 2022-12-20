function kmatrix = modaltrunc(N)
    x = linspace(-N,N,2*N+1);
    r = zeros(1,3);
    kmatrix=zeros((2*N+1)^3,3);
    ind =1;
    for i = 1:max(size(x))
        r(1) = x(i);
        for j =1:max(size(x))
            r(2) = x(j);
            for k = 1:max(size(x))
                r(3) = x(k);
                kmatrix(ind,:) = r;
                ind = ind+1;
             end
        end
    end
    B = sqrt(kmatrix(:,1).^2 + kmatrix(:,2).^2 + kmatrix(:,3).^2);
    Bk = find(B<=N);
    kmatrix = kmatrix(Bk,:);
    kmatrix(round(end/2)+1:end,:) = flip(kmatrix(round(end/2)+1:end,:));
    
end    
