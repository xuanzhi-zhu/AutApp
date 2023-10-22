classdef sensor
    methods (Static)
        function dhx1 = dynamics_flow(hx1,y,u)
            global Ad Bd Hd L1d
            dhx1 = Ad*hx1+Bd*u+L1d*(y-Hd*hx1);
        end
    end
end