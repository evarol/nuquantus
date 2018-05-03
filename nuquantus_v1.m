%%
% Nuquantus: Machine learning software for the characterization and
% quantification of cell nuclei in complex immunofluorescent tissue images
%
% Version 0.2
% https://www.cbica.upenn.edu/sbia/Erdem.Varol/nuquantus.html
%
% Copyright 2016 Erdem VAROL
%                Polina GROSS
%                Nicolas HONNORAT
%
%


javaaddpath('poi_library/poi-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('poi_library/xmlbeans-2.3.0.jar');
javaaddpath('poi_library/dom4j-1.6.1.jar');
javaaddpath('poi_library/stax-api-1.0.1.jar');
addpath('./Utilities/');
addpath('./FourierHOG/');
addpath('./LIBLINEAR/');
addpath('./LIBLINEAR/mac/matlab/');
clear all
clc
close all

[FileNameAll,PathNameAll] = uigetfile('*.tif','Select images','MultiSelect','on');
if ~iscell(FileNameAll)
    tmp=FileNameAll;
    clear FileNameAll
    FileNameAll{1}=tmp;
end
p=input('Would you like to extract features from your images first?[y/n]','s');


[FileName,PathName] = uigetfile('*.mat','Select machine learning model file (mouse or pig, etc)');

model=load([PathName '/' FileName]);

if ~strcmpi(p,'y')
    q1=input('Would you like to select excel file to write results? (answer no if you would like to create new)[y/n]','s');
    if strcmpi(q1,'y');
        [ExcelFileName,ExcelPathName] = uigetfile('*.xls*','Select excel file');
        if or(ExcelFileName==0,isempty(ExcelFileName))
            disp('Excel sheet file name not given, using results.xls instead');
            ExcelFileName='results.xls';
            ExcelPathName='./';
        end
        
    else
        ExcelFileName=input('Please give name to excel file: ','s');
        ExcelFileName=[ExcelFileName '.xls'];
        ExcelPathName='./';
    end
end

redo='n';
q2='n';

for t=1:length(FileNameAll)
    close all
    PathName=PathNameAll;
    FileName=FileNameAll{t};
    FileName_split=strsplit(FileName,'.');
    I=double(imread([PathName '/' FileName]));
    I_orig=I;
    
    
    %% Preprocessing
    
    if ~exist([PathName '/' char(FileName_split(1)) '.mat']);
        I=preprocess1(I,model.background_cutoff,model.brightness_correction_sigma,1);
        %% Feature Extraction
        [cc,I]=nuclei_detection1(I,model.size_thresh);
        cc=nucleiremoval1(I,cc);
        cc.I_orig=I_orig;
        cc.background_cutoff=model.background_cutoff;
        cc.brightness_correction_sigma=model.brightness_correction_sigma;
        X=feature_extraction1(I,cc);
        cc.X=X;
        X.feat=zscore(X.feat);
        save([PathName '/' char(FileName_split(1)) '.mat'],'I','X','cc');
    else
        load([PathName '/' char(FileName_split(1)) '.mat']);
        if strcmpi(q2,'y');
            GT=load([GroundTruthPathName '/' char(FileName_split(1)) '.mat']);
        end
    end
    
    %% Channel Splitting
    RGB=I;
    RB=I;
    RG=I;
    BG=I;
    BG(:,:,3)=BG(:,:,3).*(I(:,:,2).*I(:,:,3)>0);
    BG(:,:,2)=BG(:,:,2).*(I(:,:,2).*I(:,:,3)>0);
    BG=cleanImage(BG,model.size_thresh,[2 3]);
    RG(:,:,3)=0;
    RB(:,:,2)=0;
    RG=cleanImage(RG,model.size_thresh,2);
    s=size(I);
    RB_orig=I_orig(1:s(1),1:s(2),1:s(3));
    RB_orig(:,:,2)=0;
    
    if ~strcmpi(p,'y')
        %% Prediction
        if ~strcmpi(redo,'y');
            try
                if model.turnremoveoff==1
                    cc.remove=zeros(size(cc.remove));
                end
            catch
                disp('no model.turnremoveoff setting');
            end
            try
                [featsused,~]=ismember(cc.X.featnames,model.feat);
            catch
                disp('no model.feat exists, using all features');
                featsused=ones(1,size(cc.X.feat,2));
            end
            [~,~,Yscore]=predict(ones(size(X.feat,1),1),sparse(X.feat(:,featsused==1)),model.svm_model,'-q -b 1');
            Yscore=Yscore(:,find(model.svm_model.Label==0));
            Ypred=double(-Yscore>model.cutoff);
            Ypred(cc.remove==1)=0;
            Yscore(cc.remove==1)=100000;
            cc.Y=Ypred;
            if strcmpi(q2,'y');
                cc.Y(and(cc.Y==1,GT.cc.Y==0))=0;
            end
            
            %% Show prediction
            [cc,Ipred]=nuclei_plot_test1(I,RB,cc,0);
            if ~strcmpi(q2,'y')
                s=input('Would you like to correct labels?[y/n]','s');
            else
                s='n';
            end
            done=0;
            if strcmpi(s,'y')
                while done==0
                    disp('Click on valid cardiomyocyte nuclei');
                    [pts]=nuclei_selection2(Ipred,RB_orig,0,0);
                    if ~isempty(pts)
                        cc2=nuclei_plot1(Ipred,RB,cc,pts,0);
                        subplot(1,2,2)
                        title('GO BACK TO PROGRAM','fontsize',14);
                    else
                        cc2=cc;
                        cc2.Y=zeros(size(cc.Y));
                    end
                    s2=input('Would you like to try again?[y/n]','s');
                    if strcmpi(s2,'y')
                        done=0;
                    else
                        done=1;
                    end
                end
                cc.Y=cc2.Y;
                clear cc2
            end
            close all
            [cc,Ipred]=nuclei_plot_test1(RB,RB,cc,0);
            
            Ipred_neg=Ipred;
            Ipred_neg(:,:,3)=RB(:,:,3)-Ipred(:,:,3);
            %             if ~strcmpi(q2,'y')
            %                 s=input('Would you like to recover more nuclei?[y/n]','s');
            %             else
            %                 s='n';
            %             end
            s='n';
            done=0;
            cc_tmp=cc;
            cc_tmp.Y=double(~cc.Y);
            if strcmpi(s,'y')
                while done==0
                    disp('Click on valid cardiomyocyte nuclei');
                    [pts]=nuclei_selection2(Ipred_neg,RB_orig,0,0);
                    if ~isempty(pts)
                        cc4=nuclei_plot1(Ipred_neg,RB,cc_tmp,pts,0);
                        subplot(1,2,2)
                        title('GO BACK TO COMMAND LINE','fontsize',14);
                    end
                    s2=input('Would you like to try again?[y/n]','s');
                    if strcmpi(s2,'y')
                        done=0;
                    else
                        done=1;
                    end
                end
                if ~isempty(pts)
                    cc.Y=double(or(cc.Y,cc4.Y));
                    clear cc4
                end
            end
            close all
        end
        [cc,Ipred]=nuclei_plot_test1(RB,I_orig,cc,0);
        
        
        numB=numel(cc.Y);
        numRB=sum(cc.Y);
        %% RED + BLUE + GREEN COUNTING
        
        Ipred_neg=Ipred;
        Ipred_neg(:,:,3)=RB(:,:,3)-Ipred(:,:,3);
        
        RBG=zeros(size(Ipred));
        RBG(:,:,1)=RGB(:,:,1);
        RBG(:,:,2)=Ipred(:,:,3).*RGB(:,:,2);
        RBG(:,:,3)=Ipred(:,:,3).*RGB(:,:,2);
        RBG=cleanImage(RBG,model.size_thresh,[2 3]);
        
        
        
        hrbg=figure;
        imagesc(uint8(RBG));
        title('Final Predicted Blue + Green Cardiomyocyte Nuclei')
        hb=figure;
        imagesc(uint8(RB));
        title('Blue Nuclei')
        hrb_pos=figure;
        imagesc(uint8(Ipred))
        title('Final Predicted Blue Cardiomyocyte Nuclei')
        hrb_neg=figure;
        imagesc(uint8(Ipred_neg))
        title('Final Predicted Blue NON-Cardiomyocyte Nuclei')
        hg=figure;
        imagesc(uint8(RG));
        title('Green Nuclei')
        hbg=figure;
        imagesc(uint8(BG));
        title('Blue+Green Nuclei')
        
        numRBG=bg_counter(RG(:,:,2),Ipred(:,:,3),model.size_thresh);
        numBG=bg_counter(RG(:,:,2),RB(:,:,3),model.size_thresh);
        numG=bg_counter(RG(:,:,2),RG(:,:,2),model.size_thresh);
        clc
        disp(['Image analyzed: ' FileName])
        disp(['Number of Blue nuclei found: ' num2str(numB)]);
        disp(['Number of Green nuclei found: ' num2str(numG)]);
        disp(['Number of Red+Blue nuclei found: ' num2str(numRB)]);
        disp(['Number of Blue+Green nuclei found: ' num2str(numBG)]);
        disp(['Number of Red+Blue+Green nuclei found: ' num2str(numRBG)]);
        
        cc.X=X;
        cc.background_cutoff=model.background_cutoff;
        cc.brightness_correction_sigma=model.brightness_correction_sigma;
        cc.size_thresh=model.size_thresh;
        cc.I_orig=I_orig;
        cc.I=I;
        cc.PathName=PathName;
        cc.FileName=FileName;
        
        save([PathName '/' char(FileName_split(1)) '.mat'],'I','X','cc');
        
        if ~exist([PathName '/' char(FileName_split(1)) '_analysis'])
            mkdir([PathName '/' char(FileName_split(1)) '_analysis']);
        end
%         print(hrbg,[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_RBG.tif'],'-dtiff');
%         print(hb,[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_B.tif'],'-dtiff');
%         print(hrb_pos,[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_RB_pos.tif'],'-dtiff');
%         print(hrb_neg,[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_RB_neg.tif'],'-dtiff');
%         print(hg,[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_G.tif'],'-dtiff');
%         print(hbg,[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_BG.tif'],'-dtiff');
        
        imwrite(uint8(RBG),[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_RBG_image.tif']);
        imwrite(uint8(RB),[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_B_image.tif']);
        imwrite(uint8(Ipred),[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_RB_pos_image.tif']);
        imwrite(uint8(Ipred_neg),[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_RB_neg_image.tif']);
        imwrite(uint8(RG),[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_G_image.tif']);
        imwrite(uint8(BG),[PathName '/' char(FileName_split(1)) '_analysis/' char(FileName_split(1)) '_BG_image.tif']);
        
        
        if exist([ExcelPathName '/' ExcelFileName])>0
            disp('Results spreadsheet exists...It will append new results.')
            [~,~,textdata]=xlsread([ExcelPathName '/' ExcelFileName]);
            textdata(end+1,1:6)={FileName,numB,numRB,numG,numBG,numRBG};
        else
            textdata(1,1:6)={'Image name','Total Blue Nuclei','Cardiomyocyte Nuclei','Total Green Nuclei','All Nuclei Co-stained with Blue and Green','Cardiomyocyte Nuclei Co-stained with Green'};
            textdata(2,1:6)={FileName,numB,numRB,numG,numBG,numRBG};
        end
        try
            xlwrite([ExcelPathName '/' ExcelFileName],textdata);
        catch
            xlswrite([ExcelPathName '/' ExcelFileName],textdata);
        end
        disp('Results saved!')
        if ~strcmpi(redo,'y');
            if ~strcmpi(q2,'y')
                disp('Press ENTER to move to next image');
                pause
            else
                disp([FileName ' is processed!']);
            end
        end
    else
        disp([FileName ' is processed!']);
    end
    
    
    
end
disp('DONE WITH ALL IMAGES!');