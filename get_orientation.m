data = zeros(474336,4);
j = 0;
for i = 1:9
    path_Name = '/media/computation/FantomHD/CAPS_LOOK_DIR/';
    file_Name = strcat(num2str(2003 + i),'_saturn_SSE');
    full_file_Name = strcat(path_Name, file_Name)
    fileID = fopen(full_file_Name, 'r');
    fgetl(fileID);
    fgetl(fileID);
    next = fgetl(fileID);

    while ~strcmp(next,' ') & next ~= -1
        j = j + 1;
        a = next;
        all_columns = strsplit(a,{'-','T',':',' '});   
        data(j,1) = round(24*60*(datenum(str2double(all_columns(1)),1,1) + str2double(all_columns(2))-1 ...
            + str2double(all_columns(3))/24 + str2double(all_columns(4))/(24*60) - datenum(2004,1,1)));

        data(j,2) = str2double(all_columns(7));

        b = fgetl(fileID);
        all_columns = strsplit(b,' ');
        data(j,3) = str2double(all_columns(3));

        c = fgetl(fileID);
        all_columns = strsplit(c,' ');
        data(j,4) = str2double(all_columns(3));
        
        fgetl(fileID);
        next = fgetl(fileID);
    end
end
orientation = data;
save('orientation','orientation')
