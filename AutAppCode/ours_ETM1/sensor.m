classdef sensor
    methods (Static)
        function [dhx1,dhx2] = dynamics_flow(hx1,hx2,y,u)
            global Ad Bd Hd L1d L2d
            dhx1 = Ad*hx1+Bd*u+L1d*(y-Hd*hx1);
            dhx2 = Ad*hx2+Bd*u+L2d*(y-Hd*hx2);
        end
        function [next_hx1,next_hx2] = dynamics_jump(hx1,hx2)
            global inv_H1d inv_H2d
            test_H2d=eye(6)-inv_H1d^(-1);
%             next_hx1 = inv_H1d\hx1+inv_H2d\hx2;
next_hx1 = inv_H1d\hx1+test_H2d*hx2;%!!use equality H1d+H2d=I to define H2d rather than numerically computing H2d
            next_hx2 = next_hx1;
        end
        function out = C(tau)
            global tau_max
            if (tau <= tau_max)
                out = 1;
            else
                out = 0;
            end
        end
        function out = D(tau)
            global tau_max
            if (tau >= tau_max)
                out = 1;
            else
                out = 0;
            end
        end
    end
end