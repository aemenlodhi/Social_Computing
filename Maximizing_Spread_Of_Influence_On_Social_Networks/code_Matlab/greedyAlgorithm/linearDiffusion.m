function activated = linearDiffusion(s1,N)

    runDiffusion=1;
    
    while runDiffusion==1
        runDiffusion=0;
        for i=1:N
            if s1(i).status==0
                numNeighbors=length(s1(i).neighbor);
                neighborPush=0;
                for j=1:numNeighbors
                    neighborPush=neighborPush+s1(i).neighborWeight(j)*s1(s1(i).neighbor(j)).status;
                end
                if neighborPush>s1(i).threshold
                   s1(i).toActivate=1; 
                end
                
            end %end if
        end %end for
        
        for i=1:N
           if s1(i).toActivate==1
              runDiffusion=1;
              s1(i).toActivate=0;
              s1(i).status=1;
           end
        end
        
    end %end while
    
    activated=-1;
    for i=1:N
       if s1(i).status==1
          activated=activated+1; 
       end
    end %end for
    
end

