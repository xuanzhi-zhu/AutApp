classdef ETM
    methods (Static)
        function out = C(timer)
            global timer_max
            if timer<=timer_max
                out = 1;
            else
                out = 0;
            end
        end
        function out = D(timer)
            global timer_max
            if timer>=timer_max
                out = 1;
            else
                out = 0;
            end
        end
    end
end

