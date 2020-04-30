% define transfer functions
s = tf('s');
C =@(Kp,Ki) Kp + Ki/s;
G = tf([1 3],[1 0.6 1.05]);

% Take input 
KpMin=input('Write Minimum value of Kp = ');
KpMax=input('Write Maximum value of Kp = ');

KiMin=input('Write Minimum value of Ki = ');
KiMax=input('Write Maximum value of Ki = ');
k_step = 0.01;

% loop through given combinations of Kp and Ki
for Kp = KpMin:k_step:KpMax
    for Ki = KiMin:k_step:KiMax
    % Create Closed Loop TF
    H0 = feedback(C(Kp,Ki)*G,1);
    H1 = feedback(C(Kp,Ki+k_step)*G,1);
    H2 = feedback(C(Kp,Ki-k_step)*G,1);
    H3 = feedback(C(Kp+k_step,Ki)*G,1);
    H4 = feedback(C(Kp+k_step,Ki+k_step)*G,1);
    H5 = feedback(C(Kp+k_step,Ki-k_step)*G,1);
    H6 = feedback(C(Kp-k_step,Ki)*G,1);
    H7 = feedback(C(Kp-k_step,Ki+k_step)*G,1);
    H8 = feedback(C(Kp-k_step,Ki-k_step)*G,1);
    
    % Create a unit Step input
    [Y0,T0] = step(H0,50);
    [Y1,T1] = step(H1,50);
    [Y2,T2] = step(H2,50);
    [Y3,T3] = step(H3,50);
    [Y4,T4] = step(H4,50);
    [Y5,T5] = step(H5,50);
    [Y6,T6] = step(H6,50);
    [Y7,T7] = step(H7,50);
    [Y8,T8] = step(H8,50);
    
    % Calculate square integral error
    e0 = Error(Y0,T0(2) - T0(1));
    e1 = Error(Y1,T1(2) - T1(1));
    e2 = Error(Y2,T2(2) - T2(1));
    e3 = Error(Y3,T3(2) - T3(1));
    e4 = Error(Y4,T4(2) - T4(1));
    e5 = Error(Y5,T5(2) - T5(1));
    e6 = Error(Y6,T6(2) - T6(1));
    e7 = Error(Y7,T7(2) - T7(1));
    e8 = Error(Y8,T8(2) - T8(1));
    
    % if current Kp and Ki is min value then break
    errors_array = e0;
    if Ki + k_step <= KiMax
        errors_array = [errors_array,e1];
    end 
    
    if Ki - k_step >= KiMin
        errors_array = [errors_array,e2];
    end 
    
    if Kp + k_step <= KpMax 
        errors_array = [errors_array,e3];
    end 
    
    if Kp + k_step <= KpMax && Ki + k_step <= KiMax
        errors_array = [errors_array,e4];
    end 
    
    if Kp + k_step <= KpMax && Ki - k_step >= KiMin
        errors_array = [errors_array,e5];
    end 
    
    if Kp - k_step >= KpMin
        errors_array = [errors_array,e6];
    end 
    
    if Kp - k_step >= KpMin && Ki + k_step <= KiMax
        errors_array = [errors_array,e7];
    end 
    
    if Kp - k_step >= KpMin && Ki - k_step >= KiMin
        errors_array = [errors_array,e8];
    end 
    
    min_error = min(errors_array);
    if e0 == min_error
       fprintf("Found :");
       Ki
       Kp
       min_error

       break
    end
    end 
end
% Error calculation function
function E = Error(Y,ts)
    E = ts * trapz((Y-1).^2);
end