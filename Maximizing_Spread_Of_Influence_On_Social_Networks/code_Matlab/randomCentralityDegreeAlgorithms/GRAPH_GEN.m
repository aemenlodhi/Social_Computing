% Forming graph and necessary data structures from data 
function[]=GRAPH_GEN(file_name)
clear all
clc

fp=fopen(file_name);
X=textscan(fp ,'%f %f ','HeaderLines',4);
fclose(fp) ;
X=cell2mat(X);
X1=single(X(:,1)); X2=single(X(:,2));

X3=unique(sort([X1;X2]));

N=length(X3);
for i=1:N
    Index1=find(X1==X3(i)); 
    Index2=find(X2==X3(i));
    X1(Index1)=i; 
    X2(Index2)=i;    
end

save X2.mat X1 X2 N ; 


% GRAPH GEN FOR LT


load X2.mat 
s1(1:N)=struct('neighbour',single([]),'neighbour_weight',single([]),'sensor',int8(0),'Theta',[]);
temp=max(length(X1),length(X2));
for i=1:temp
    s1(X1(i)).neighbour=[s1(X1(i)).neighbour X2(i)];
    s1(X2(i)).neighbour=[s1(X2(i)).neighbour X1(i)];
end 

neighbour_Cardinality=zeros(1,N);
Theta=rand(1,N);
for i=1:N
    s1(i).Theta=Theta(i);
    s1(i).neighbour=sort(s1(i).neighbour);
    temp1=unique(s1(i).neighbour);
    temp_w=[];
    for j=1:length(temp1)
        temp_w=[temp_w length(find(s1(i).neighbour==temp1(j)))];
    end 
    temp_w=temp_w/sum(temp_w);
    s1(i).neighbour=temp1;
    s1(i).neighbour_weight=temp_w; 
    neighbour_Cardinality(i)=length(s1(i).neighbour);
end 



[a b]=sort(neighbour_Cardinality,'descend');
neighbour_Cardinality=[a' b'];


save S_LT2.mat s1 neighbour_Cardinality N
%}

% GRAPH GEN FOR INDEPENDENT CASCADE 


clear all
clc
load X2.mat 
s1(1:N)=struct('neighbour',single([]),'sensor',int8(0),'active',int8(0));
temp=max(length(X1),length(X2));
for i=1:temp
    s1(X1(i)).neighbour=[s1(X1(i)).neighbour X2(i)];
    s1(X2(i)).neighbour=[s1(X2(i)).neighbour X1(i)];
end 

neighbour_Cardinality=zeros(1,N);

for i=1:N
  
    s1(i).neighbour=unique(sort(s1(i).neighbour));
     
    neighbour_Cardinality(i)=length(s1(i).neighbour);
end 

WC_P=1./neighbour_Cardinality;

[a b]=sort(neighbour_Cardinality,'descend');
neighbour_Cardinality=[a' b'];


save S_IC2.mat s1 neighbour_Cardinality N WC_P ;
graph_centrality();
end

function[]=graph_centrality()
%  Graph Centrality
%
clear all
clc
load S_IC2.mat
A=zeros(N,N);
for i=1:N
    t=s1(i).neighbour;
    for j=1:length(t)
        A(i,t(j))=1;
        A(t(j),i)=1;
    end
end

A=sparse(A);
[X,Y]=betweenness_centrality(A);


save graph_centrality  X Y ;
end
