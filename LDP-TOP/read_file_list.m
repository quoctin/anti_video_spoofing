%Copyright (c) 2017 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato

function list = read_file_list(path)
%   This function returns content of a file
%   path: file path

    fileID = fopen(path);
    cell = textscan(fileID, '%s', 'EndOfLine', '\n', 'Whitespace', '\t');
    fclose(fileID);
    list = cell{:};
end
