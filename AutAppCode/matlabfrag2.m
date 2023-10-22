function matlabfrag2(filename)
%
% MATLABFRAG(filename) - creates filename.tex and filename.eps for use with
% LaTeX with the code
%
% \begin{figure}
% \input{filename.tex}
% \includegraphics{filename.eps}
% \end{figure}
%
% Workflow:
% - Use cell arrays Handles, PropertyName, OldLabel to save user data
% - Replace text data with dummy data
% - Revert changes
%
    %create psfrag file
    fid = fopen([filename '.tex'],'w+');
    
    %Process text objects
    TexObj = findall(gcf,'Type','Text');
    set(TexObj,'FontName','fixedwidth')
    n_TexObj = numel(TexObj);
    Handle = cell(n_TexObj,1);
    PropertyName = cell(n_TexObj,1);
    OldLabel = cell(n_TexObj,1);
    for I = 1:n_TexObj
        Handle{I}       = TexObj(I);
        PropertyName{I} = 'string';
        OldLabel{I}     = get(TexObj(I),'string');
        set(TexObj(I),'string',sprintf('%03d',I));
        aux = get(Handle{I},'verticalalignment');
        switch aux
            case 'bottom'
                va = 'b';
            case 'baseline'
                va = 'B';
            case 'top'
                va = 't';
            otherwise
                va = '';
        end
        aux = get(Handle{I},'horizontalalignment');
        switch aux
            case 'left'
                ha = 'l';
            case 'right'
                ha = 'r';
            otherwise
                ha = '';
        end
        fprintf(fid,['\\psfrag{%03d}[' va ha '][' va ha ']{\\small %s}\n'],I,OldLabel{I});
    end
    %Process axes objects
    AxeObj = findall(gcf,'Type','Axes');
    n_AxeObj = numel(AxeObj);
    n = n_TexObj;
    for I = 1:n_AxeObj
        for a = 'xyz'
            Labels = get(AxeObj(I),[a 'ticklabel']);
            nLabels = numel(Labels);
            Handle = [Handle;{AxeObj(I)}];
            PropertyName = [PropertyName;[a 'ticklabel']];
            OldLabel = [OldLabel;{Labels}];
            set(AxeObj(I),[a 'ticklabel'],...
                arrayfun(@(s) sprintf('%03d',s),(n+1:n+nLabels)',...
                'uniformoutput',false));
            for K = 1:nLabels
                switch a
                    case 'x'
                        loc = get(AxeObj(I),[a 'axislocation']);
                        if strcmpi(loc,'bottom')
                            fprintf(fid,'\\psfrag{%03d}[tc][tc]{\\small $%s$}\n',n+K,Labels{K});
                        else
                            fprintf(fid,'\\psfrag{%03d}[bc][bc]{\\small $%s$}\n',n+K,Labels{K});
                        end
                    case 'y'
                        loc = get(AxeObj(I),[a 'axislocation']);
                        if strcmpi(loc,'left')
                            fprintf(fid,'\\psfrag{%03d}[cr][cr]{\\small $%s$}\n',n+K,Labels{K});
                        else
                            fprintf(fid,'\\psfrag{%03d}[cl][cl]{\\small $%s$}\n',n+K,Labels{K});
                        end
                    otherwise
                        fprintf(fid,'\\psfrag{%03d}[][]{\\small $%s$}\n',n+K,Labels{K});
                end
            end
            n = n+nLabels;
        end
    end
    %Process legend objects
    LegObj = findall(gcf,'Type','legend');
    n_LegObj = numel(LegObj);
    
    for I = 1:n_LegObj
        Handle = [Handle;{LegObj(I)}];
        PropertyName = [PropertyName;'string'];
        Labels = get(LegObj(I),'string');
        nLabels = numel(Labels);
        OldLabel = [OldLabel;{Labels}];
        set(LegObj(I),'string',...
            arrayfun(@(s) sprintf('%03d',s),n+1:n+nLabels,...
            'uniformoutput',false));
        for K=1:nLabels
            fprintf(fid,'\\psfrag{%03d}[cl][cl]{\\small %s}\n',n+K,Labels{K});
        end
        set(LegObj(I),'location','none')
        n = n+nLabels;
    end
     %Process colorbar objects
    ColObj = findall(gcf,'Type','Colorbar');
    n_ColObj = numel(ColObj);
    for I=1:n_ColObj
        Handle = [Handle;{ColObj(I)}];
        PropertyName = [PropertyName;'ticklabels'];
        Labels = get(ColObj(I),'ticklabels');
        nLabels = size(Labels,1);
        OldLabel = [OldLabel;{Labels}];
        set(ColObj(I),'ticklabels',...
            arrayfun(@(s) sprintf('%03d',s),n+1:n+nLabels,...
            'uniformoutput',false));
        for K=1:nLabels
            fprintf(fid,'\\psfrag{%03d}[cl][cl]{\\small %s}\n',n+K,Labels(K,:));
        end
        n = n+nLabels;
    end
    nLabels = numel(Handle);
    fclose(fid);
    %set(gcf,'renderer','painters')
    %options.Format = 'eps';
    %hgexport(gcf,[filename '.eps'],options);
    print('-painters','-depsc',[filename '.eps'])
    for I = 1:nLabels
        set(Handle{I},PropertyName(I),OldLabel(I));
    end
    
        
    