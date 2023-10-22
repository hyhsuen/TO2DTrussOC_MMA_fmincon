% file plotsupports.m
% illustrates the boundary conditions on the structure
% Original version by Brian Rømer, September 2003
% Modified by Ole Sigmund, August 2008 and August 2010
% Modified ddmmyyyy 21/02/2023 by Ho Yuen Henry Suen 

if  exist('mesh','var')  
X=mesh.X;
IX=mesh.IX;
neqn=mesh.neqn;
bound=mesh.bound;
end

if size(X,2)==2
    %finding the size of the strcture and the deformed (new) coordinates
    Dx=1:2:neqn;
    Dy=2:2:neqn;
    Xnew(:,1)=X(:,1)+D(Dx);
    Xnew(:,2)=X(:,2)+D(Dy);

    maxX=max(Xnew(:,1));
    minX=min(Xnew(:,1));
    maxY=max(Xnew(:,2));
    minY=min(Xnew(:,2));

    sizeY=maxY-minY;
    sizeX=maxX-minX;

    %if size is 1 in the X-dimension used for the supports "dsup" are 0.015
    dsup=max([sizeX,sizeY])*0.015;

    % Plotting the soupports
    for b=1:size(bound,1)
        nodedof = [bound(b,1)*2-1 bound(b,1)*2];
        XX=Xnew(bound(b,1),1);
        YY=Xnew(bound(b,1),2);
        dsup=abs(dsup); %hvis fortegnet har været vendt
        if bound(b,2)==1  %hold in X-direction
            if XX==maxX %and minX<>maxX %liiger helt til højre i en ikke "smal" konstruktionen
                dsup=-dsup;
            end
            plot(XX,YY,'ko','LineWidth',1.5)
            plot([XX,XX-2*dsup],[YY,YY+2*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX-2*dsup],[YY-2*dsup,YY+2*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX],[YY-2*dsup,YY],'k','LineWidth',1)
            plot(XX-3*dsup,YY+dsup,'ko','LineWidth',0.7)
            plot(XX-3*dsup,YY-dsup,'ko','LineWidth',0.7)
            plot([XX-4*dsup,XX-4*dsup],[YY-2*dsup,YY+2*dsup],'k','LineWidth',1)

            plot([XX-4*dsup,XX-5*dsup],[YY+2*dsup,YY+1.005*dsup],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY+1*dsup,YY+0.004*dsup/0.025],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY+0.0000,YY-0.995*dsup],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY-1*dsup,YY-1.990*dsup],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY-2*dsup,YY-2.985*dsup],'k','LineWidth',1)
        elseif bound(b,2)==2    %hold in the y-direction
            if YY==maxY  %holder fast i toppen af en ikke flad konstruktion
                dsup=-dsup;
            end
            plot(XX,YY,'ko','LineWidth',1.5)
            plot([XX,XX-2*dsup],[YY,YY-2*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX+2*dsup],[YY-2*dsup,YY-2*dsup],'k','LineWidth',1)
            plot([XX+2*dsup,XX],[YY-2*dsup,YY],'k','LineWidth',1)
            plot(XX-dsup,YY-3*dsup,'ko','LineWidth',0.7)
            plot(XX+dsup,YY-3*dsup,'ko','LineWidth',0.7)
            plot([XX-2*dsup,XX+2*dsup],[YY-4*dsup,YY-4*dsup],'k','LineWidth',1)

            plot([XX+2*dsup,XX+1.01*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX+1*dsup,XX+0.004*dsup/0.025],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX+0*dsup,XX-0.995*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX-1*dsup,XX-1.990*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX-2.985*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
        end %if and elseif
    end %for b=1:nbound

elseif size(X,2)==3 %Beam
    Dx=1:3:neqn;
    Dy=2:3:neqn;
    Xnew(:,1)=X(:,1)+D(Dx);
    Xnew(:,2)=X(:,2)+D(Dy);

    maxX=max(Xnew(:,1));
    minX=min(Xnew(:,1));
    maxY=max(Xnew(:,2));
    minY=min(Xnew(:,2));

    sizeY=maxY-minY;
    sizeX=maxX-minX;

    %if size is 1 in the X-dimension used for the supports "dsup" are 0.015
    dsup=max([sizeX,sizeY])*0.015;

    % Plotting the soupports
    for b=1:size(bound,1)
        nodedof = [bound(b,1)*2-1 bound(b,1)*2];
        XX=Xnew(bound(b,1),1);
        YY=Xnew(bound(b,1),2);
        dsup=abs(dsup); %hvis fortegnet har været vendt
        if bound(b,2)==1  %hold in X-direction
            if XX==maxX %and minX<>maxX %liiger helt til højre i en ikke "smal" konstruktionen
                dsup=-dsup;
            end
            plot(XX,YY,'ko','LineWidth',1.5)
            plot([XX,XX-2*dsup],[YY,YY+2*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX-2*dsup],[YY-2*dsup,YY+2*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX],[YY-2*dsup,YY],'k','LineWidth',1)
            plot(XX-3*dsup,YY+dsup,'ko','LineWidth',0.7)
            plot(XX-3*dsup,YY-dsup,'ko','LineWidth',0.7)
            plot([XX-4*dsup,XX-4*dsup],[YY-2*dsup,YY+2*dsup],'k','LineWidth',1)

            plot([XX-4*dsup,XX-5*dsup],[YY+2*dsup,YY+1.005*dsup],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY+1*dsup,YY+0.004*dsup/0.025],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY+0.0000,YY-0.995*dsup],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY-1*dsup,YY-1.990*dsup],'k','LineWidth',1)
            plot([XX-4*dsup,XX-5*dsup],[YY-2*dsup,YY-2.985*dsup],'k','LineWidth',1)
        elseif bound(b,2)==2    %hold in the y-direction
            if YY==maxY  %holder fast i toppen af en ikke flad konstruktion
                dsup=-dsup;
            end
            plot(XX,YY,'ko','LineWidth',1.5)
            plot([XX,XX-2*dsup],[YY,YY-2*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX+2*dsup],[YY-2*dsup,YY-2*dsup],'k','LineWidth',1)
            plot([XX+2*dsup,XX],[YY-2*dsup,YY],'k','LineWidth',1)
            plot(XX-dsup,YY-3*dsup,'ko','LineWidth',0.7)
            plot(XX+dsup,YY-3*dsup,'ko','LineWidth',0.7)
            plot([XX-2*dsup,XX+2*dsup],[YY-4*dsup,YY-4*dsup],'k','LineWidth',1)

            plot([XX+2*dsup,XX+1.01*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX+1*dsup,XX+0.004*dsup/0.025],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX+0*dsup,XX-0.995*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX-1*dsup,XX-1.990*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
            plot([XX-2*dsup,XX-2.985*dsup],[YY-4*dsup,YY-5*dsup],'k','LineWidth',1)
        elseif bound(b,2)==3    %hold in totation theta_z
            plot(XX,YY, 'o', 'color', 'black', 'markersize', 16, 'linewidth', 1.5)
        end %if and elseif
    end %for b=1:nbound

else

end
