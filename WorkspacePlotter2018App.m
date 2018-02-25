classdef WorkspacePlotter2018App < handle
%
% Usage:
%     app.WorkspacePlotter2018App

  properties
      AppPath = {'/WorkspacePlotter2018/code'};
	  AppClass = 'WorkspacePlotter2018App';
	  AppHandle;
	  AppCount = 0;
      Increment = 1;
	  Decrement = 0;
      Output;
      CurrClass;
      Version = '13a';
  end  
  methods (Static)
      function count = refcount(increment)
          mlock;
          persistent AppCount;
          if(isempty(AppCount))              
              AppCount = 1;
          else
              if(increment)
                  AppCount = plus(AppCount,1);
              else
                  AppCount = minus(AppCount,1);
              end
          end
          count = AppCount;
       end
  end
  
  methods
    % Create the application object
    function obj = WorkspacePlotter2018App()      
      obj.CurrClass = metaclass(obj);
      startApp(obj)
    end

    function value = get.AppPath(obj)
       appview = com.mathworks.appmanagement.AppManagementViewSilent;
       appAPI = com.mathworks.appmanagement.AppManagementApiBuilder.getAppManagementApiCustomView(appview);
           
       myAppsLocation = char(appAPI.getMyAppsLocation);
       
       value = cellfun(@(x) fullfile(myAppsLocation, x), obj.AppPath, 'UniformOutput', false);
    end

    % Start the application
    function startApp(obj)
        % Put the application directory on the path
        %allpaths = genpath(obj.AppPath{:});
        %addpath(strrep(allpaths, [obj.AppPath{:} filesep 'metadata;'], ''));      

        % Must load function (force by using function handle) or nargout lies.
        % Check if the app is a GUIDE app
        if nargout(@WORKSPACE_PLOTTER_OOP) == 0  
            eval('WORKSPACE_PLOTTER_OOP');
        else
			obj.AppHandle = eval('WORKSPACE_PLOTTER_OOP');   
        end 
        % Increment the reference count by one    
        WorkspacePlotter2018App.refcount(obj.Increment);

        if(ishandle(obj.AppHandle))
	        % Setup cleanup code on figure handle using onCleanup object
            cleanupObj = onCleanup(@()appinstall.internal.stopapp([],[],obj));
            appdata = getappdata(obj.AppHandle);
            appfields = fields(appdata);
            found = cellfun(@(x) strcmp(x,'AppCleanupCode'), appfields);
            if(~any(found))
                setappdata(obj.AppHandle, 'AppCleanupCode', cleanupObj);     
            end  
        elseif isa(obj.AppHandle,'handle') && ~isvalid(obj.AppHandle)
            % Cleanup in the case where the handle was invalidated before here
            appinstall.internal.stopapp([],[],obj)
        end
    end
  end
end
