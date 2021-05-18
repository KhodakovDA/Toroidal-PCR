function [ Tt, threshold_val ] = find_Tt(skip_new, sm_cycle, Data_ct, time_ct, y_max, threshold)

min_val= mean(Data_ct(skip_new+2:skip_new+sm_cycle+1));
range = y_max - min_val;
threshold_val = range*threshold/100;

a = abs(Data_ct - threshold_val);
b = min(a);
II = find(Data_ct>threshold_val);
I = find(Data_ct<threshold_val);

val_1 = I(length(I));

if size (II) == [0,1]
    Tt = NaN;
    threshold_val = NaN;
else
    val_2 = (II(1,1));
    data_x_int(1,1) = Data_ct (val_1,1);
    data_x_int(2,1) = Data_ct (val_2,1);
    data_y_int(1,1) = time_ct (val_1,1);
    data_y_int(2,1) = time_ct (val_2,1);
    Tt= interp1(data_x_int,data_y_int,threshold_val)/60;
    Tt = round(Tt,2);
end

if range < 2
    Tt = NaN;
end

end

