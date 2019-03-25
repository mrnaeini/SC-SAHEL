function varargout = param_range(varargin)
% Please reference to:
% Matin Rahnamay Naeini, Tiantian Yang, Mojtaba Sadegh, Amir Aghakouchak,
% Kuo-lin Hsu, Soroosh Sorooshian, Qingyun Duan, and Xiaohui Lei. "Shuffled 
% complex-self adaptive hybrid evolution (SC-SAHEL) optimization
% framework." Environmental Modelling & Software, 104:215 - 235, 2018.
% PARAM_RANGE MATLAB code for param_range.fig
%      PARAM_RANGE, by itself, creates a new PARAM_RANGE or raises the existing
%      singleton*.
%
%      H = PARAM_RANGE returns the handle to a new PARAM_RANGE or the handle to
%      the existing singleton*.
%
%      PARAM_RANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAM_RANGE.M with the given input arguments.
%
%      PARAM_RANGE('Property','Value',...) creates a new PARAM_RANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before param_range_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to param_range_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help param_range

% Last Modified by GUIDE v2.5 21-Mar-2018 18:06:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @param_range_OpeningFcn, ...
                   'gui_OutputFcn',  @param_range_OutputFcn, ...
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


% --- Executes just before param_range is made visible.
function param_range_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to param_range (see VARARGIN)
if exist('par_range.mat','file')
    load('par_range.mat');
    set(handles.table,'data',par_range);
end

% Choose default command line output for param_range
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes param_range wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = param_range_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
par_range = get(handles.table,'data');
if sum(par_range(:,1) > par_range(:,2)) > 1
    msgbox('Upper bound should be larger than lower bound!')
    return
end
if get(handles.samerange,'value') == 1
    n = str2double(get(handles.dim,'string'));
    par_range = repmat(par_range,n,1);
end
% Save the variables
save('par_range.mat','par_range');
close('param_range')



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 0
    set(handles.range_ad,'enable','off')
    set(handles.range_sel,'enable','off')
elseif get(hObject,'value') == 1
    set(handles.range_ad,'enable','on')
    set(handles.range_sel,'enable','on')
end
% Hint: get(hObject,'Value') returns toggle state of checkbox1



function range_ad_Callback(hObject, eventdata, handles)
% hObject    handle to range_ad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range_ad as text
%        str2double(get(hObject,'String')) returns contents of range_ad as a double


% --- Executes during object creation, after setting all properties.
function range_ad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range_ad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in range_sel.
function range_sel_Callback(hObject, eventdata, handles)
% hObject    handle to range_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath] = uigetfile('*.mat','Select the parameters range file');
ExPath = fullfile(FilePath,FileName);
set(handles.range_ad,'String',ExPath);
w = who('-file',ExPath);
load(ExPath);
eval(['dum = ',w{1},';']);
if size(dum,2) > 2
    msgbox('The parameter range should be in nby2 matrix!')
    return
end
set(handles.table,'data',dum);


function dim_Callback(hObject, eventdata, handles)
% hObject    handle to dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.samerange,'value') == 0
    n = str2double(get(hObject,'String'));
    dummyvar = zeros(n,2);
    set(handles.table,'data',dummyvar);
end
% Hints: get(hObject,'String') returns contents of dim as text
%        str2double(get(hObject,'String')) returns contents of dim as a double


% --- Executes during object creation, after setting all properties.
function dim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function table_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in samerange.
function samerange_Callback(hObject, eventdata, handles)
% hObject    handle to samerange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    set(handles.table,'data',[0,0])
else
    n = str2double(get(handles.dim,'String'));
    dummyvar = zeros(n,2);
    set(handles.table,'data',dummyvar)
end
% Hint: get(hObject,'Value') returns toggle state of samerange
