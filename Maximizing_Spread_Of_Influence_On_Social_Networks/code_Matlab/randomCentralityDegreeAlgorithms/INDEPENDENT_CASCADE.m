
function [ c_array,n_array] = INDEPENDENT_CASCADE(p)
IC_ARRAY={'HighDeg'  'Central' 'Random'};
%p=0.1;
for kkk=1:3
    IC=IC_ARRAY(kkk);
    IC=IC{:};
    [ c_array,n_array] = Independent_Cascade_UG1(IC,p);
end
end



function [ c_array,n_array] = Independent_Cascade_UG1(IC,p )
% Implement Independent Cascode
%clear all
clc


%IC='HighDeg' ; % 'HighDeg'  'Cental' 'Random'
%p=0.1; % 10

display('Independent Cascade')
display(IC)
display(p)

load('NODE_CENTRALITY2.mat')
load S_IC2.mat

if strcmp(IC,'HighDeg')
    display('HighDeg')
elseif strcmp(IC,'Random')
    display('Random')
elseif strcmp(IC,'Central')
    display('Central')
else
    display('Nothing Mentioned EXIT ....')
    error('Error in Line 38')
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
    %display(j)
      
    
    
    
% intial Population generation
if strcmp(IC,'HighDeg')
    A=neighbour_Cardinality(1:n,2);
elseif strcmp(IC,'Random')
    A=randi([1 N],n,1,'single');
elseif strcmp(IC,'Central')
    A=NODE_CENTRALITY(1:n);
else
    display('Nothing Mentioned EXIT ....')
    error('Error in Line 69')
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
         for i1=1:length(t)
                     
            if pt(i1) <=p 
                if s1(t(i1)).sensor==0 
                    s1(t(i1)).sensor=1; %s1(t(i1)).active=1;
                    NEXT_ACTIVE_NODES=[NEXT_ACTIVE_NODES t(i1)];
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
if strcmp(IC,'HighDeg')
    if p>0.05
        save HighDeg_IC2.mat c_array n_array p
    else
        save HighDeg_IC.mat c_array n_array p
    end
elseif strcmp(IC,'Random')
    if p>0.05
        save Random_IC2.mat c_array n_array p
    else
        save Random_IC.mat c_array n_array p
    end
elseif strcmp(IC,'Central')
    if p>0.05
        save Central_IC2.mat c_array n_array p
    else
        save Central_IC.mat c_array n_array p
    end
else
    display('Nothing Mentioned EXIT ....')
    error('Error in Line 146')
end


end

