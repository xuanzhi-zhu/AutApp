classdef ETM
    methods (Static)
        function out = C(hx1,hx2,xc)
            global delta
            if norm(xc-hx1)<=delta
                out = 1;
            else
                out = 0;
            end
        end
        function out = D(hx1,hx2,xc)
            global delta
            if norm(xc-hx1)>=delta
                out = 1;
            else
                out = 0;
            end
        end
    end
end

