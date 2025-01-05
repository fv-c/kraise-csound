;-------------FFT-------------------------------------------
opcode FFT_ANALYSIS, k[]k[], aii

        aMono, iFFTsize, iOverlaps xin

        ifftsize  = iFFTsize
        ibw = sr / ifftsize ; BIN BANDWITH
        iNumBin = ifftsize / 2
        giNumBin = iNumBin
        iTabSize = (ifftsize / 2) + 2
        ihopsize  = ifftsize / iOverlaps 
        iwinsize  = ifftsize; finestra temporale
        iwinshape = 1 ;von-Hann window
        
        fftin pvsanal aMono, ifftsize, ihopsize, iwinsize, iwinshape;fft-analysis of the audio-signal

        gkInFreq[]  init iTabSize;frequenze della fft
        gkInAmp[]   init iTabSize
        gkOutFreq[]  init iTabSize;frequenze della fft
        gkOutAmp[]   init iTabSize
 
        kframe  pvs2tab gkInAmp, gkInFreq, fftin ;Copia i dati spettrali nei due array (amp,freq)

        kCount init 0 

        if kCount >= ihopsize  then
 
            gki = 0 
            until gki == iNumBin  do
               gkOutFreq[gki] = gkInFreq[gki]
               gkOutAmp[gki] = gkInAmp[gki]
       
               gki = gki + 1
            od
            kCount = 0  
        endif
        kCount = kCount + ksmps 
        ;-----------------------------------
  
      xout  gkOutFreq, gkOutAmp

endop  
;-------------FFT-------------------------------------------   



   
;----------------ENCODER 3 order AMBIX----------------------
opcode Encoder3order, a[], akk ;SIG, AZI, ELEV

    ain1,kAzi0,kEle0 xin

    aEnc[] init 16

    iPI = 4 * taninv(1.0)

    kEle = kEle0 * iPI / 180
    kAzi = kAzi0 * iPI / 180

    ;ACN - SN3D
    ;0 order
    aEnc[0] = ain1
  
    ;1 order
    aEnc[1] = ain1 * sin(kAzi) * cos(kEle) 
    aEnc[2] = ain1 * sin(kEle)
    aEnc[3] = ain1 * cos(kAzi) * cos(kEle)
    
    ;2 order
    aEnc[4] = ain1 * sqrt(3/4) * sin(2 * kAzi) * (cos(kEle))^2
    aEnc[5] = ain1 * sqrt(3/4) * sin(kAzi) * sin(2 * kEle)
    aEnc[6] = ain1 * (1/2) * (3 * (sin(kEle))^2-1)
    aEnc[7] = ain1 * sqrt(3/4) * cos(kAzi) * sin(2 * kEle)
    aEnc[8] = ain1 * sqrt(3/4) * cos(2 * kAzi) * (cos(kEle))^2
  
    ;3 order
    aEnc[9] = ain1 * sqrt(5/8) * sin(3 * kAzi) * (cos(kEle))^3
    aEnc[10] = ain1 * sqrt(15/4) * sin(2 * kAzi) * sin(kEle) * (cos(kEle))^2
    aEnc[11] = ain1 * sqrt(3/8) * sin(kAzi) * cos(kEle) * (5 * (sin(kEle))^2 - 1)
    aEnc[12] = ain1 * (1/2) * sin(kEle) * (5 * (sin(kEle))^2 - 3)
    aEnc[13] = ain1 * sqrt(3/8) * cos(kAzi) * cos(kEle) * (5 * (sin(kEle))^2 - 1)
    aEnc[14] = ain1 * sqrt(15/4) * cos(2 * kAzi) * sin(kEle) * (cos(kEle))^2
    aEnc[15] = ain1 * sqrt(5/8) * cos(3 * kAzi) * (cos(kEle))^3
  
    xout aEnc

endop
;----------------ENCODER 3 order AMBIX----------------------


;----------------ENCODER 7 order AMBIX----------------------
opcode Encoder7order, a[], akk ;SIG, AZI, ELEV

    ain1,kAzi0,kEle0 xin

    aEnc[] init 64

    iPI = 4 * taninv(1.0)

    kEle = kEle0 * iPI / 180
    kAzi = kAzi0 * iPI / 180

    ;ACN - SN3D
    ;0 order
    aEnc[0] = ain1
  
    ;1 order
    aEnc[1] = ain1 * sin(kAzi) * cos(kEle) 
    aEnc[2] = ain1 * sin(kEle)
    aEnc[3] = ain1 * cos(kAzi) * cos(kEle)
    
    ;2 order
    aEnc[4] = ain1 * sqrt(3/4) * sin(2 * kAzi) * (cos(kEle))^2
    aEnc[5] = ain1 * sqrt(3/4) * sin(kAzi) * sin(2 * kEle)
    aEnc[6] = ain1 * (1/2) * (3 * (sin(kEle))^2-1)
    aEnc[7] = ain1 * sqrt(3/4) * cos(kAzi) * sin(2 * kEle)
    aEnc[8] = ain1 * sqrt(3/4) * cos(2 * kAzi) * (cos(kEle))^2
  
    ;3 order
    aEnc[9] = ain1 * sqrt(5/8) * sin(3 * kAzi) * (cos(kEle))^3
    aEnc[10] = ain1 * sqrt(15/4) * sin(2 * kAzi) * sin(kEle) * (cos(kEle))^2
    aEnc[11] = ain1 * sqrt(3/8) * sin(kAzi) * cos(kEle) * (5 * (sin(kEle))^2 - 1)
    aEnc[12] = ain1 * (1/2) * sin(kEle) * (5 * (sin(kEle))^2 - 3)
    aEnc[13] = ain1 * sqrt(3/8) * cos(kAzi) * cos(kEle) * (5 * (sin(kEle))^2 - 1)
    aEnc[14] = ain1 * sqrt(15/4) * cos(2 * kAzi) * sin(kEle) * (cos(kEle))^2
    aEnc[15] = ain1 * sqrt(5/8) * cos(3 * kAzi) * (cos(kEle))^3

    ;4 order
    aEnc[16] = ain1 * sqrt(35/64) * sin(4 * kAzi) * (cos(kEle))^4 
    aEnc[17] = ain1 * sqrt(35/8) * sin(3 * kAzi) * sin(kEle) * (cos(kEle))^3
    aEnc[18] = ain1 * sqrt(5/16) * sin(2 * kAzi) * (cos(kEle))^2 * (7 * (sin(kEle))^2 - 1)
    aEnc[19] = ain1 * sqrt(5/32) * sin(kAzi) * sin(2 *kEle) * (7 * (sin(kEle))^2 - 3)
    aEnc[20] = ain1 * (1/8) * (35 * sin(kEle)^4 - 30 * sin(kEle)^2 + 3)
    aEnc[21] = ain1 * sqrt(5/32) * cos(kAzi) * sin(2 *kEle) * (7 * (sin(kEle))^2 - 3)
    aEnc[22] = ain1 * sqrt(5/16) * cos(2 * kAzi) * (cos(kEle))^2 * (7 * (sin(kEle))^2 - 1)
    aEnc[23] = ain1 * sqrt(35/8) * cos(3 * kAzi) * sin(kEle) * (cos(kEle))^3
    aEnc[24] = ain1 * sqrt(35/64) * cos(4 * kAzi) * (cos(kEle))^4

    ;5 order
    aEnc[25] = ain1 * sqrt(35/64) * cos(4 * kAzi) * (cos(kEle))^4
    aEnc[26] = ain1 * sqrt(315/64) * sin(4 * kAzi) * sin(kEle) * (cos(kEle))^4
    aEnc[27] = ain1 * sqrt(35/128) * sin(3 * kAzi) * (cos(kEle))^3 * (9 * (sin(kEle))^2 - 1)
    aEnc[28] = ain1 * sqrt(105/16) * sin(2 * kAzi) * sin(kEle) * (cos(kEle))^2 * (3 * (sin(kEle))^2 - 1)
    aEnc[29] = ain1 *  sqrt(15/64) * sin(kAzi) * cos(kEle) * (21 * (sin(kEle))^4 - 14 * (sin(kEle))^2 + 1)
    aEnc[30] = ain1 * (1/8) * (63 * (sin(kEle))^5 - 70 * sin(kEle)^3 + 15 * sin(kEle))
    aEnc[31] = ain1 * sqrt(15/64) * cos(kAzi) * cos(kEle) * (21 * (sin(kEle))^4 - 14 * (sin(kEle))^2 + 1)
    aEnc[32] = ain1 * sqrt(105/16) * cos(2 * kAzi) * sin(kEle) * (cos(kEle))^2 * (3 * (sin(kEle))^2 - 1)
    aEnc[33] = ain1 * sqrt(35/128) * cos(3 * kAzi) * (cos(kEle))^3 * (9 * (sin(kEle))^2 - 1)
    aEnc[34] = ain1 * sqrt(315/64) * cos(4 * kAzi) * sin(kEle) * (cos(kEle))^4
    aEnc[35] = ain1 * sqrt(63/128) * cos(5 * kAzi) * (cos(kEle))^5

    ;6 order
    aEnc[36] = ain1 * (1/16) * sqrt(231/2) * sin(6 * kAzi) * (cos(kEle))^6
    aEnc[37] = ain1 * (3/8) * sqrt(77/2) * sin(5 * kAzi) * sin(kEle) * (cos(kEle))^5
    aEnc[38] = ain1 * (3/16) * sqrt(7) * sin(4 * kAzi) * (cos(kEle))^4 * (11 * (sin(kEle))^2 - 1)
    aEnc[39] = ain1 * (1/8) * sqrt(105/2) * sin(3 * kAzi) * sin(kEle) * (cos(kEle))^3 * (11 * (sin(kEle))^2 - 3)
    aEnc[40] = ain1 * (1/16) * sqrt(105/2) * sin(2 * kAzi) * (cos(kEle))^2 * (33 * (sin(kEle))^4 - 18 * (sin(kEle))^2 + 1)
    aEnc[41] = ain1 * (1/16) * sqrt(21) * sin(kAzi) * sin(2 * kEle) * (33 * (sin(kEle))^4 - 30 * (sin(kEle))^2 + 5)
    aEnc[42] = ain1 * (1/16) * (231 * (sin(kEle))^6 - 315 * (sin(kEle))^4 + 105 * (sin(kEle))^2 - 5)
    aEnc[43] = ain1 * (1/16) * sqrt(21) * cos(kAzi) * sin(2 * kEle) * (33 * (sin(kEle))^4 - 30 * (sin(kEle))^2 + 5)
    aEnc[44] = ain1 * (1/16) * sqrt(105/2) * cos(2 * kAzi) * (cos(kEle))^2 * (33 * (sin(kEle))^4 - 18 * (sin(kEle))^2 + 1)
    aEnc[45] = ain1 * (1/8) * sqrt(105/2) * cos(3 * kAzi) * sin(kEle) * (cos(kEle))^3 * (11 * (sin(kEle))^2 - 3)
    aEnc[46] = ain1 * (3/16) * sqrt(7) * cos(4 * kAzi) * (cos(kEle))^4 * (11 * (sin(kEle))^2 - 1)
    aEnc[47] = ain1 * (3/8) * sqrt(77/2) * cos(5 * kAzi) * sin(kEle) * (cos(kEle))^5
    aEnc[48] = ain1 * (1/16) * sqrt(231/2) * cos(6 * kAzi) * (cos(kEle))^6

    ;7 order
    aEnc[49] = ain1 * (1/32) * sqrt(429) * sin(7 * kAzi) * (cos(kEle))^7
    aEnc[50] = ain1 * (1/16) * sqrt(3003/2) * sin(6 * kAzi) * sin(kEle) * (cos(kEle))^6
    aEnc[51] = ain1 * (1/32) * sqrt(231) * sin(5 * kAzi) * (13 * (sin(kEle))^2 - 1) * (cos(kEle))^5
    aEnc[52] = ain1 * (1/16) * sqrt(231) * sin(4 * kAzi) * (13 * (sin(kEle))^3 - 3 * sin(kEle)) * (cos(kEle))^4
    aEnc[53] = ain1 * (1/32) * sqrt(21) * sin(3 * kAzi) * (143 * (sin(kEle))^4 - 66 * (sin(kEle))^2 + 3) * (cos(kEle))^3
    aEnc[54] = ain1 * (1/16) * sqrt(21/2) * sin(2 * kAzi) * (143 * (sin(kEle))^5 - 110 * (sin(kEle))^3 + 15 * sin(kEle)) * (cos(kEle))^2
    aEnc[55] = ain1 * (1/32) * sqrt(7) * sin(kAzi) * (429* (sin(kEle))^6 - 495 * (sin(kEle))^4 + 135* (sin(kEle))^2 - 5) * cos(kEle)
    aEnc[56] = ain1 * (1/16) * (429 * (sin(kEle))^7 - 693 * (sin(kEle))^5 + 315 * (sin(kEle))^3 - 35 * sin(kEle))
    aEnc[57] = ain1 * (1/32) * sqrt(7) * cos(kAzi) * (429 * (sin(kEle))^6 - 495 * (sin(kEle))^4 + 135 * (sin(kEle))^2 - 5) * cos(kEle)
    aEnc[58] = ain1 * (1/16) * sqrt(21/2) * cos(2 * kAzi) * (143 * (sin(kEle))^5 - 110 * (sin(kEle))^3 + 15 * sin(kEle)) * (cos(kEle))^2
    aEnc[59] = ain1 * (1/32) * sqrt(21) * cos(3 * kAzi) * (143 * (sin(kEle))^4 - 66 * (sin(kEle))^2 + 3) * (cos(kEle))^3
    aEnc[60] = ain1 * (1/16) * sqrt(231) * cos(4 * kAzi) * (13 * (sin(kEle))^3 - 3 * sin(kEle)) * (cos(kEle))^4
    aEnc[61] = ain1 * (1/32) * sqrt(231) * cos(5 * kAzi) * (13 * (sin(kEle))^2 - 1) * (cos(kEle))^5
    aEnc[62] = ain1 * (1/16) * sqrt(3003/2) * cos(6 * kAzi) * sin(kEle) * (cos(kEle))^6
    aEnc[63] = ain1 * (1/32) * sqrt(429) * cos(7 * kAzi) * (cos(kEle))^7


    xout aEnc

endop
;----------------ENCODER 7 order AMBIX----------------------
