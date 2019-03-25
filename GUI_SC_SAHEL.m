function varargout = GUI_SC_SAHEL(varargin)
% Please reference to:
% Matin Rahnamay Naeini, Tiantian Yang, Mojtaba Sadegh, Amir Aghakouchak,
% Kuo-lin Hsu, Soroosh Sorooshian, Qingyun Duan, and Xiaohui Lei. "Shuffled 
% complex-self adaptive hybrid evolution (SC-SAHEL) optimization
% framework." Environmental Modelling & Software, 104:215 - 235, 2018.
% GUI_SC_SAHEL MATLAB code for GUI_SC_SAHEL.fig
%      GUI_SC_SAHEL, by itself, creates a new GUI_SC_SAHEL or raises the existing
%      singleton*.
%
%      H = GUI_SC_SAHEL returns the handle to a new GUI_SC_SAHEL or the handle to
%      the existing singleton*.
%
%      GUI_SC_SAHEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SC_SAHEL.M with the given input arguments.
%
%      GUI_SC_SAHEL('Property','Value',...) creates a new GUI_SC_SAHEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_SC_SAHEL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_SC_SAHEL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_SC_SAHEL

% Last Modified by GUIDE v2.5 21-Mar-2018 19:48:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_SC_SAHEL_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_SC_SAHEL_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_SC_SAHEL is made visible.
function GUI_SC_SAHEL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_SC_SAHEL (see VARARGIN)

% Choose default command line output for GUI_SC_SAHEL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_SC_SAHEL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_SC_SAHEL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in About.
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
about


% --- Executes on button press in Manual.
function Manual_Callback(hObject, eventdata, handles)
% hObject    handle to Manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('SC-SAHEL-Manual.pdf')


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NumOfComp = str2double(get(handles.NumOfComp,'String'));
if isnan(NumOfComp)
    msgbox('Number of complexes is not specified properly!');
end
% load the parameters
if exist('par_range.mat', 'file') == 2
    load('par_range.mat')
else
    msgbox('Please specify the parameters range and save the ranges!')
    return
end
lb = par_range(:,1)';
ub = par_range(:,2)';
MaxFcal = str2double(get(handles.MaxItr,'String'));
if isnan(MaxFcal)
    msgbox('Maximum number of function evaluation is not specified properly!')
end

% Get objective function
obj_dir = get(handles.obj_ad,'string');
if isempty(obj_dir)
    msgbox('Please specify the objective function!');
    return
else
    addpath(fileparts(obj_dir));
    [~,ObjFun] = fileparts(obj_dir);
end
% Get Data file
input_dir = get(handles.input_ad,'string');
if isempty(input_dir)
    Data = '';
else
    Data = load(input_dir);
end

if get(handles.default,'value') == 1
    [X_optimum,F_optimum,misc] = SC_SAHEL(lb,ub,MaxFcal,ObjFun,'NumOfComplex',NumOfComp,'Data',Data);
    save('X_optimum','X_optimum');save('F_optimum','F_optimum');save('misc','misc');
    Plot_SC_SAHEL(misc);
else
    EAs = {};
    if get(handles.CCE,'value') == 1
        EAs{end+1} = 'CCE';
    end
    if get(handles.MCCE,'value') == 1
        EAs{end+1} = 'MCCE';
    end
    if get(handles.DEF,'value') == 1
        EAs{end+1} = 'DEF';
    end
    if get(handles.GWO,'value') == 1
        EAs{end+1} = 'GWO';
    end
    if get(handles.FL,'value') == 1
        EAs{end+1} = 'FL';
    end
    if isempty(EAs)
        EAs = {'MCCE','CCE'};
    end
    SizeOfComp = str2double(get(handles.SizeOfComp,'String'));
    if isnan(SizeOfComp)
        SizeOfComp = 2*size(par_range,1) + 1;
    end
    EvolStep = str2double(get(handles.EvolStep,'String'));
    if isnan(EvolStep)
        EvolStep = max(10,size(par_range,1)+1);
    end
    if get(handles.LHS,'value')
        SampMethod = 'LHsamp';
    else
        SampMethod = 'LHsamp';
    end
    if get(handles.URS,'value')
        SampMethod = 'URsamp';
    end
    if get(handles.Ref,'value')
        BoundHand = 'ReflectBH';
    else
        BoundHand = 'ReflectBH';
    end
    if get(handles.SB,'value')
        BoundHand = 'SetToBound';
    end
    if get(handles.par,'value')
        Parallel = true;
    else
        Parallel = false;
    end
    if get(handles.dimres,'value')
        DimRest = true;
    else
        DimRest = false;
    end
    if get(handles.gaures,'value')
        ReSamp = true;
    else
        ReSamp = false;
    end
    StopSP = str2double(get(handles.grange,'String'));
    if isnan(StopSP)
        StopSP = 1e-7;
    end
    StopStep = str2double(get(handles.numofit,'String'));
    if isnan(StopStep)
        StopStep = 50;
    end
    StopIMP = str2double(get(handles.imp,'String'));
    if isnan(StopIMP)
        StopIMP = 0.1;
    end
    if StopIMP > 100
        msg('Improvement threshold should be smaller than 100!')
        return
    end
    [X_optimum,F_optimum,misc] = SC_SAHEL(lb,ub,MaxFcal,ObjFun,...
    'EAs',EAs,'NumOfComplex',NumOfComp,'ComplexSize',SizeOfComp,...
    'EvolStep',EvolStep,'SampMethod',SampMethod,'BoundHand',BoundHand,...
    'Parallel',Parallel,'DimRest',DimRest,'ReSamp',ReSamp,'StopSP',StopSP,...
    'StopStep',StopStep,'StopIMP',StopIMP,'Data',Data);
    save('X_optimum','X_optimum');save('F_optimum','F_optimum');save('misc','misc');
    Plot_SC_SAHEL(misc);
end





% --- Executes on button press in par.
function par_Callback(hObject, eventdata, handles)
% hObject    handle to par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of par


% --- Executes on button press in dimres.
function dimres_Callback(hObject, eventdata, handles)
% hObject    handle to dimres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dimres


% --- Executes on button press in gaures.
function gaures_Callback(hObject, eventdata, handles)
% hObject    handle to gaures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gaures


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LHS.
function LHS_Callback(hObject, eventdata, handles)
% hObject    handle to LHS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    set(handles.URS,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of LHS


% --- Executes on button press in URS.
function URS_Callback(hObject, eventdata, handles)
% hObject    handle to URS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    set(handles.LHS,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of URS



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Ref.
function Ref_Callback(hObject, eventdata, handles)
% hObject    handle to Ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    set(handles.SB,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of Ref


% --- Executes on button press in SB.
function SB_Callback(hObject, eventdata, handles)
% hObject    handle to SB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    set(handles.Ref,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of SB



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CCE.
function CCE_Callback(hObject, eventdata, handles)
% hObject    handle to CCE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CCE


% --- Executes on button press in MCCE.
function MCCE_Callback(hObject, eventdata, handles)
% hObject    handle to MCCE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MCCE


% --- Executes on button press in DEF.
function DEF_Callback(hObject, eventdata, handles)
% hObject    handle to DEF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DEF


% --- Executes on button press in GWO.
function GWO_Callback(hObject, eventdata, handles)
% hObject    handle to GWO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GWO


% --- Executes on button press in FL.
function FL_Callback(hObject, eventdata, handles)
% hObject    handle to FL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FL



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function NumOfComp_Callback(hObject, eventdata, handles)
% hObject    handle to NumOfComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumOfComp as text
%        str2double(get(hObject,'String')) returns contents of NumOfComp as a double


% --- Executes during object creation, after setting all properties.
function NumOfComp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumOfComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxItr_Callback(hObject, eventdata, handles)
% hObject    handle to MaxItr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxItr as text
%        str2double(get(hObject,'String')) returns contents of MaxItr as a double


% --- Executes during object creation, after setting all properties.
function MaxItr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxItr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RangeOfParam.
function RangeOfParam_Callback(hObject, eventdata, handles)
% hObject    handle to RangeOfParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
param_range



function obj_ad_Callback(hObject, eventdata, handles)
% hObject    handle to obj_ad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obj_ad as text
%        str2double(get(hObject,'String')) returns contents of obj_ad as a double


% --- Executes during object creation, after setting all properties.
function obj_ad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_ad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BrowseObj.
function BrowseObj_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath] = uigetfile('*.m','Select objective function');
ExPath = fullfile(FilePath,FileName);
set(handles.obj_ad,'String',ExPath);


function input_ad_Callback(hObject, eventdata, handles)
% hObject    handle to input_ad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_ad as text
%        str2double(get(hObject,'String')) returns contents of input_ad as a double


% --- Executes during object creation, after setting all properties.
function input_ad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_ad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in input_browse.
function input_browse_Callback(hObject, eventdata, handles)
% hObject    handle to input_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath] = uigetfile('*.mat','Select data file');
ExPath = fullfile(FilePath,FileName);
set(handles.input_ad,'String',ExPath);

% --- Executes on button press in default.
function default_Callback(hObject, eventdata, handles)
% hObject    handle to default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    set(handles.uipanel3,'visible','off')
    set(handles.uipanel4,'visible','off')
    set(handles.uipanel5,'visible','off')
    set(handles.uipanel6,'visible','off')
else
    set(handles.uipanel3,'visible','on')
    set(handles.uipanel4,'visible','on')
    set(handles.uipanel5,'visible','on')
    set(handles.uipanel6,'visible','on')
end
% Hint: get(hObject,'Value') returns toggle state of default



function SizeOfComp_Callback(hObject, eventdata, handles)
% hObject    handle to SizeOfComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SizeOfComp as text
%        str2double(get(hObject,'String')) returns contents of SizeOfComp as a double


% --- Executes during object creation, after setting all properties.
function SizeOfComp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SizeOfComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EvolStep_Callback(hObject, eventdata, handles)
% hObject    handle to EvolStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EvolStep as text
%        str2double(get(hObject,'String')) returns contents of EvolStep as a double


% --- Executes during object creation, after setting all properties.
function EvolStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EvolStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numofit_Callback(hObject, eventdata, handles)
% hObject    handle to numofit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numofit as text
%        str2double(get(hObject,'String')) returns contents of numofit as a double


% --- Executes during object creation, after setting all properties.
function numofit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numofit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function grange_Callback(hObject, eventdata, handles)
% hObject    handle to grange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grange as text
%        str2double(get(hObject,'String')) returns contents of grange as a double


% --- Executes during object creation, after setting all properties.
function grange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imp_Callback(hObject, eventdata, handles)
% hObject    handle to imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imp as text
%        str2double(get(hObject,'String')) returns contents of imp as a double


% --- Executes during object creation, after setting all properties.
function imp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
