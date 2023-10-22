classdef sensor_ETM
    methods (Static)
        function next_q = dynamics_jump(q)
            global q_max
            next_q = mod(q,q_max)+1;
        end
        function out = C(tau,q)
            global tau_max q_max
            if (tau <= tau_max) && (q <= q_max)
                out = 1;
            else
                out = 0;
            end
        end
        function out = D(tau,q)
            global tau_max q_max
            if (tau >= tau_max) && (q == q_max)
                out = 1;
            else
                out = 0;
            end
        end
    end
end

