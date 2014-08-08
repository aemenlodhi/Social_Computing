function [ c_array,n_array] = LINEAR_THRESHOLD(LT )

% Implement Linear Threshold 
clear all
clc

%LT='Random' ; % 'HighDeg'  'Cental' 'Random'
load X2.mat
clear X1 X2
load S_LT2.mat
load('NODE_CENTRALITY2.mat')

if strcmp(LT,'HighDeg')
    display('HighDeg_LT')
elseif strcmp(LT,'Random')
    display('Random')
elseif strcmp(LT,'Central')
    display('Central')
else
    display('Nothing Mentioned EXIT ....')
    error('line 21')
end


n_array=[5 10 15 20 25 30];
No_of_simulations=100; % average over the no of simulations
%n_array=30;
c_array=zeros(length(n_array),No_of_simulations);


for k=1:length(n_array)
display(k)
n=n_array(k);
c=zeros(1,No_of_simulations);


for j=1:No_of_simulations
    if rem(j,10)==0 
        display(j) 
    end
      
    
    
if strcmp(LT,'HighDeg')
    A=neighbour_Cardinality(1:n,2);
elseif strcmp(LT,'Random')
    A=randi([1 N],n,1,'single');
elseif strcmp(LT,'Central')
    A=NODE_CENTRALITY(1:n);
else
    display('Nothing Mentioned EXIT ....')
    exit
end
   



    % refreshing s1
    theta=rand(1,N);
    for k1=1:N
        s1(k1).Theta=theta(k1);
    end
    [s1.sensor]=deal(int8(0));
    [s1(A).sensor]=deal(int8(2));

% this tracks the nodes already got the message
GOT_MESSAGE=A'; % A is column matrix
NOT_MESSAGE=setdiff(1:N,GOT_MESSAGE);
NEIGHBOUR_GOT_MESSAGE=[s1(GOT_MESSAGE).neighbour];
NEIGHBOUR_GOT_MESSAGE=unique(NEIGHBOUR_GOT_MESSAGE);
NEIGHBOUR_GOT_MESSAGE=intersect(NEIGHBOUR_GOT_MESSAGE,NOT_MESSAGE);
NEIGHBOUR_GOT_MESSAGE=setdiff(NEIGHBOUR_GOT_MESSAGE,GOT_MESSAGE);

incr=1;index_prev=0;
while incr >0
   index_prev=length(GOT_MESSAGE);
       
    % it tracks the nodes getting message at current iteration T=t
    track=[]; 
    for i=NEIGHBOUR_GOT_MESSAGE
        %if s1(i).sensor==0
            t=s1(i).neighbour ;
            t1=[s1(t).sensor];
            t2=s1(i).neighbour_weight ;
            Theta_t=sum(t2(find(t1==2)));
            if Theta_t >=s1(i).Theta
                s1(i).sensor=int8(1);
                track=[track  i];
            end
        %end
    end 
    
   if ~isempty(track)
       [s1(track).sensor]=deal(int8(2));
   end
   
   GOT_MESSAGE=[GOT_MESSAGE track];
   NOT_MESSAGE=setdiff(1:N,GOT_MESSAGE);
   NEIGHBOUR_GOT_MESSAGE=[s1(GOT_MESSAGE).neighbour];
   NEIGHBOUR_GOT_MESSAGE=unique(NEIGHBOUR_GOT_MESSAGE);
   NEIGHBOUR_GOT_MESSAGE=intersect(NEIGHBOUR_GOT_MESSAGE,NOT_MESSAGE);
   NEIGHBOUR_GOT_MESSAGE=setdiff(NEIGHBOUR_GOT_MESSAGE,GOT_MESSAGE);
   incr=length(GOT_MESSAGE)-index_prev;
end  % end while loop

c(j)=index_prev;


end
c_array(k,:)=c;
%plot(c);grid on


end

%plot(n_array,mean(c_array,2));
%save random_LT.mat c_array n_array
if strcmp(LT,'HighDeg')
    save HighDeg_LT.mat c_array n_array
elseif strcmp(LT,'Random')
    save Random_LT.mat c_array n_array
elseif strcmp(LT,'Central')
    save Central_LT.mat c_array n_array
else
    display('Nothing Mentioned EXIT ....')
    exit
end


end






