fp=fopen('CA-HepPh.txt');
%fp=fopen('dump.txt');

fw=fopen('greedyLinear.txt','at');

X=textscan(fp ,'%f %f ','HeaderLines',4);
fclose(fp) ;
X=cell2mat(X);
X1=single(X(:,1));
X2=single(X(:,2));

X3=unique(sort([X1;X2]));

for i=1:length(X3)
    Index1=find(X1==X3(i)); 
    Index2=find(X2==X3(i));
    X1(Index1)=i; 
    X2(Index2)=i;    
end


N=single(34546);
save chimp.mat X1 X2 N;

for k=1:30
   for i=1:10
       activated=greedyLinear(k);
       sprintf('Number of activated with k=%d is: %d',k,activated) 
       fprintf(fw,'\n%d\t%d',k,activated);
   end
end




fclose(fw);

