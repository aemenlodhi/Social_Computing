function[ c_array,n_array] = WEIGHTED_CASCADE( )
WC_ARRAY={'HighDeg'  'Central' 'Random'};

for kkk=1:3
    WC=WC_ARRAY(kkk);
    WC=WC{:};
    [ c_array,n_array] = Weighted_Cascade_UG1(WC );
end

end




function [ c_array,n_array] = Weighted_Cascade_UG1(WC )
% Implement Weighted Cascode

clc
%WC='HighDeg' ; % 'HighDeg'  'Cental' 'Random'

load('NODE_CENTRALITY2.mat')
load S_IC2.mat

display('Weighted Cascade')
display(WC)
if strcmp(WC,'HighDeg')
    display('HighDeg')
elseif strcmp(WC,'Random')
    display('Random')
elseif strcmp(WC,'Central')
    display('Central')
else
    display('Nothing Mentioned EXIT ....')
    error('')
end


n_array=[5 10 15 20 25 30];
No_of_simulations=100; % average over the no of simulations

c_array=zeros(length(n_array),No_of_simulations);


for k=1:length(n_array)
display(k)
n=n_array(k);
c=zeros(1,No_of_simulations);


for j=1:No_of_simulations
      
    
% intial Population generation
if strcmp(WC,'HighDeg')
    A=neighbour_Cardinality(1:n,2);
elseif strcmp(WC,'Random')
    A=randi([1 N],n,1,'single');
elseif strcmp(WC,'Central')
    A=NODE_CENTRALITY(1:n);
else
    display('Nothing Mentioned EXIT ....')
    exit
end
%


    % refreshing s1
    [s1.sensor]=deal(int8(0));
    %[s1.active]=deal(int8(0));
    [s1(A).sensor]=deal(int8(1));
    %[s1(A).active]=deal(int8(1));
    ACTIVE_NODES=A';
    

incr=1;
while incr >0

       
    % it tracks the nodes getting message at current iteration T=t
    NEXT_ACTIVE_NODES=[]; 
    for i=ACTIVE_NODES
        
         s1(i).active=0;
         t=s1(i).neighbour ;
         pt=rand(1,length(t));
         for m=1:length(t)
                     
            if pt(m) <=WC_P(t(m))
                if s1(t(m)).sensor==0 
                    s1(t(m)).sensor=1; %s1(t(i1)).active=1;
                    NEXT_ACTIVE_NODES=[NEXT_ACTIVE_NODES t(m)];
                end
            end
         end
      
    end 
    ACTIVE_NODES=NEXT_ACTIVE_NODES;
    
   if isempty(ACTIVE_NODES)
      incr=-1;
   end
   
   
  
end  % end while loop

c(j)=sum([s1.sensor]);


end
c_array(k,:)=c;
%plot(c);grid on


end

%plot(n_array,mean(c_array,2));
%save random_LT.mat c_array n_array
if strcmp(WC,'HighDeg')
    save HighDeg_WC.mat c_array n_array
elseif strcmp(WC,'Random')
    save Random_WC.mat c_array n_array
elseif strcmp(WC,'Central')
    save Central_WC.mat c_array n_array
else
    display('Nothing Mentioned EXIT ....')
    error('error in line 127');
end




end






