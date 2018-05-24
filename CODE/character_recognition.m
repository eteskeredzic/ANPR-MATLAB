% korak 1 - ucitaj sliku
path = input('Unesi naziv slike i format: ', 's');
img = imread(strcat('OUTPUT/',path));

% korak 2 - izdvajanje backgrounda i foregrounda koristeci thresholding
% ako je intensity piksela ispod 125, bit ce bijel, u suprotnom je crn
mask = img < 125;

% korak 3 - ciscenje svijetlih dijelova slike(suma) oko najveceg dijela
% foregroundea(sto bi trebale biti tablice)
mask = imclearborder(mask);

% korak 4 - izdvajanje 9 najvecih podrucja na slici
mask = bwareafilt(mask, 9);
imshow(mask);

% korak 5 - koristenje OCR algoritma istreniranog za prepoznavanje BH
% registarskih tablica zajedno sa templateingom ugradjenim u OCR funkciju
ocrRes = ocr(mask, 'CharacterSet', 'AEJKMOT-0123456789', 'Language', 'RES\OCR_TRAINER\BH_Registarske\tessdata\BH_Registarske.traineddata');

% korak 6 - upisivanje rezultata u datoteku
S = [path,' -> ', ocrRes.Text];
fid = fopen('rezultati.txt','a+');
fprintf(fid, '\r\n%s', S);
fclose(fid);