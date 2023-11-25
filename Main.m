
mat = imread("INPUT/Cover_Image/ijpeg.jfif");
M = 'HELLO';
% M = 'The first recorded use of the term was in 1499 by Johannes Trithemius in his Steganographia, a treatise on cryptography and steganography, disguised as a book on magic. Generally, the hidden messages appear to be (or to be part of) something else: images, articles, shopping lists, or some other cover text. For example, the hidden message may be in invisible ink between the visible lines of a private letter. Some implementations of steganography that lack a shared secret are forms of security through obscurity, and key-dependent steganographic \n schemes adhere to Kerckhoffs';
% M = fileread("INPUT/Text/chapter1.txt");
% M = fileread("INPUT/Text/chapter1-5.txt");
len=length(M);
[x,y,z] = size(mat);

if len*4 >= x*y*z
    error("Smaller image to embed text file");
end

embed_mat = Embed(mat,M); % Function call to Embed text file into the image

% figure(1); image(embed_mat); % Image after Text Embedding

test(mat,embed_mat)
% [peaksnr, snr] = psnr(embed_mat, mat);

extracted_str = Extract(embed_mat, len); % Text extracted from image & returned
estr='';
for i = 1:length(extracted_str)
    estr=append(estr,extracted_str(i));
end
    
if strcmpi(M,estr)==1
  fprintf("\nSAME MESSAGE\n");
else
  fprintf("\nNOT SAME MESSAGE\n");
  for i = 1:length(M)
    if M(i) ~= extracted_str(i)
        try
        fprintf("%s--%s\n",M(i),extracted_str(i));
        catch
        warning('NOT POSSIBLE');
        end
    end
  end
end
% fid = fopen("Extract.txt","w");
% fwrite(fid,extracted_str);
% fclose(fid);    


