function tiff = LoadTiffStack(Stack)

tiff=imread(Stack,1);
tiff_info = imfinfo(Stack);

for i = 2 : size(tiff_info, 1)
    temp_tiff = imread(Stack, i);
    tiff = cat(3 , tiff, temp_tiff);
end

end