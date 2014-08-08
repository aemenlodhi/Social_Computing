function activated = greedyLinear(k)
    %UNTITLED4 Summary of this function goes here
    %   Detailed explanation goes here
    load chimp.mat 
    N=max(length(X1),length(X2));

    s1(1:N)=struct('neighbor',[],'neighborWeight',[],'threshold',double(0),'status',int8(0),'neighborAttempt',[],'toActivate',int8(0));

    temp=max(length(X1),length(X2));
    for i=1:temp
        s1(X1(i)).neighbor=[s1(X1(i)).neighbor X2(i)];
        s1(X2(i)).neighbor=[s1(X2(i)).neighbor X1(i)];

    end 

    for i=1:N
        s1(i).neighbor=unique(s1(i).neighbor);
        s1(i).threshold=rand;
        s1(i).status=0;
        s1(i).toActivate=0;
    end

    for i=1:N
        tempLen=length(s1(i).neighbor);
        s1(i).neighborWeight=zeros(1,tempLen);
        s1(i).neighborAttemp=zeros(1,tempLen);
        for j=1:tempLen
            s1(i).neighborWeight(j)=rand;
        end

        tempSum=sum(s1(i).neighborWeight);

        for j=1:tempLen
           s1(i).neighborWeight(j)=s1(i).neighborWeight(j)/tempSum;

        end

    end

    %%%%%%% for debugging purposes
    % disp(N)
    % for i=1:N
    %     disp(s1(i).neighborWeight)
    % end
    %%%%%%%

    s=[];
    activated=0;
    chosen=0;
    iteration=0;

    %run actual diffusion process
    while length(s)<k

        sprintf('Iteration %d',iteration)

        predictions=-1*ones(1,N);
        for i=1:N
           if(s1(i).status==0)

               sprintf('Predicting for %d',i)

               s1(i).status=1;
               predictedActivation=linearDiffusion(s1,N);
               if predictedActivation>activated

                   %sprintf('Pre-prediction: %d and Post-prediction: %d',activated,predictedActivation)
                   predictions(i)=predictedActivation;
                   s1(i).status=0;
               end %end if
           end %end if
        end %end for

        [val,index]=max(predictions);

        %sprintf('Max diffusion %d',val)


        if val>-1

            %sprintf('Max diffusion through %d',index)
            s1(index).status=1;
            activated=activated+1;
            s=[s index];

            %sprintf('s is')
            %disp(s)
            %%%%%%%updating s1
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

            activated=0;
            for i=1:N
               if s1(i).status==1
                  activated=activated+1; 
               end
            end %end for

            %sprintf('Activated %d\n',activated)
        end

        iteration=iteration+1;
        if iteration>N
            break;
        end
    end %end while

    %disp(s)


end

