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


;----------------ENCODER 7 order AMBIX----------------------
opcode Encoder7order, a[], aaa ;SIG, AZI, ELEV

    ain1,aAzi0,aEle0 xin

    aEnc[] init 64

    iPI = 4 * taninv(1.0)

    aEle = aEle0 * iPI / 180
    aAzi = aAzi0 * iPI / 180

    ;ACN - SN3D
    ;0 order
    aEnc[0] = ain1
  
    ;1 order
    aEnc[1] = ain1 * sin(aAzi) * cos(aEle) 
    aEnc[2] = ain1 * sin(aEle)
    aEnc[3] = ain1 * cos(aAzi) * cos(aEle)
    
    ;2 order
    aEnc[4] = ain1 * sqrt(3/4) * sin(2 * aAzi) * (cos(aEle))^2
    aEnc[5] = ain1 * sqrt(3/4) * sin(aAzi) * sin(2 * aEle)
    aEnc[6] = ain1 * (1/2) * (3 * (sin(aEle))^2-1)
    aEnc[7] = ain1 * sqrt(3/4) * cos(aAzi) * sin(2 * aEle)
    aEnc[8] = ain1 * sqrt(3/4) * cos(2 * aAzi) * (cos(aEle))^2
  
    ;3 order
    aEnc[9] = ain1 * sqrt(5/8) * sin(3 * aAzi) * (cos(aEle))^3
    aEnc[10] = ain1 * sqrt(15/4) * sin(2 * aAzi) * sin(aEle) * (cos(aEle))^2
    aEnc[11] = ain1 * sqrt(3/8) * sin(aAzi) * cos(aEle) * (5 * (sin(aEle))^2 - 1)
    aEnc[12] = ain1 * (1/2) * sin(aEle) * (5 * (sin(aEle))^2 - 3)
    aEnc[13] = ain1 * sqrt(3/8) * cos(aAzi) * cos(aEle) * (5 * (sin(aEle))^2 - 1)
    aEnc[14] = ain1 * sqrt(15/4) * cos(2 * aAzi) * sin(aEle) * (cos(aEle))^2
    aEnc[15] = ain1 * sqrt(5/8) * cos(3 * aAzi) * (cos(aEle))^3

    ;4 order
    aEnc[16] = ain1 * sqrt(35/64) * sin(4 * aAzi) * (cos(aEle))^4 
    aEnc[17] = ain1 * sqrt(35/8) * sin(3 * aAzi) * sin(aEle) * (cos(aEle))^3
    aEnc[18] = ain1 * sqrt(5/16) * sin(2 * aAzi) * (cos(aEle))^2 * (7 * (sin(aEle))^2 - 1)
    aEnc[19] = ain1 * sqrt(5/32) * sin(aAzi) * sin(2 *aEle) * (7 * (sin(aEle))^2 - 3)
    aEnc[20] = ain1 * (1/8) * (35 * sin(aEle)^4 - 30 * sin(aEle)^2 + 3)
    aEnc[21] = ain1 * sqrt(5/32) * cos(aAzi) * sin(2 *aEle) * (7 * (sin(aEle))^2 - 3)
    aEnc[22] = ain1 * sqrt(5/16) * cos(2 * aAzi) * (cos(aEle))^2 * (7 * (sin(aEle))^2 - 1)
    aEnc[23] = ain1 * sqrt(35/8) * cos(3 * aAzi) * sin(aEle) * (cos(aEle))^3
    aEnc[24] = ain1 * sqrt(35/64) * cos(4 * aAzi) * (cos(aEle))^4

    ;5 order
    aEnc[25] = ain1 * sqrt(35/64) * cos(4 * aAzi) * (cos(aEle))^4
    aEnc[26] = ain1 * sqrt(315/64) * sin(4 * aAzi) * sin(aEle) * (cos(aEle))^4
    aEnc[27] = ain1 * sqrt(35/128) * sin(3 * aAzi) * (cos(aEle))^3 * (9 * (sin(aEle))^2 - 1)
    aEnc[28] = ain1 * sqrt(105/16) * sin(2 * aAzi) * sin(aEle) * (cos(aEle))^2 * (3 * (sin(aEle))^2 - 1)
    aEnc[29] = ain1 *  sqrt(15/64) * sin(aAzi) * cos(aEle) * (21 * (sin(aEle))^4 - 14 * (sin(aEle))^2 + 1)
    aEnc[30] = ain1 * (1/8) * (63 * (sin(aEle))^5 - 70 * sin(aEle)^3 + 15 * sin(aEle))
    aEnc[31] = ain1 * sqrt(15/64) * cos(aAzi) * cos(aEle) * (21 * (sin(aEle))^4 - 14 * (sin(aEle))^2 + 1)
    aEnc[32] = ain1 * sqrt(105/16) * cos(2 * aAzi) * sin(aEle) * (cos(aEle))^2 * (3 * (sin(aEle))^2 - 1)
    aEnc[33] = ain1 * sqrt(35/128) * cos(3 * aAzi) * (cos(aEle))^3 * (9 * (sin(aEle))^2 - 1)
    aEnc[34] = ain1 * sqrt(315/64) * cos(4 * aAzi) * sin(aEle) * (cos(aEle))^4
    aEnc[35] = ain1 * sqrt(63/128) * cos(5 * aAzi) * (cos(aEle))^5

    ;6 order
    aEnc[36] = ain1 * (1/16) * sqrt(231/2) * sin(6 * aAzi) * (cos(aEle))^6
    aEnc[37] = ain1 * (3/8) * sqrt(77/2) * sin(5 * aAzi) * sin(aEle) * (cos(aEle))^5
    aEnc[38] = ain1 * (3/16) * sqrt(7) * sin(4 * aAzi) * (cos(aEle))^4 * (11 * (sin(aEle))^2 - 1)
    aEnc[39] = ain1 * (1/8) * sqrt(105/2) * sin(3 * aAzi) * sin(aEle) * (cos(aEle))^3 * (11 * (sin(aEle))^2 - 3)
    aEnc[40] = ain1 * (1/16) * sqrt(105/2) * sin(2 * aAzi) * (cos(aEle))^2 * (33 * (sin(aEle))^4 - 18 * (sin(aEle))^2 + 1)
    aEnc[41] = ain1 * (1/16) * sqrt(21) * sin(aAzi) * sin(2 * aEle) * (33 * (sin(aEle))^4 - 30 * (sin(aEle))^2 + 5)
    aEnc[42] = ain1 * (1/16) * (231 * (sin(aEle))^6 - 315 * (sin(aEle))^4 + 105 * (sin(aEle))^2 - 5)
    aEnc[43] = ain1 * (1/16) * sqrt(21) * cos(aAzi) * sin(2 * aEle) * (33 * (sin(aEle))^4 - 30 * (sin(aEle))^2 + 5)
    aEnc[44] = ain1 * (1/16) * sqrt(105/2) * cos(2 * aAzi) * (cos(aEle))^2 * (33 * (sin(aEle))^4 - 18 * (sin(aEle))^2 + 1)
    aEnc[45] = ain1 * (1/8) * sqrt(105/2) * cos(3 * aAzi) * sin(aEle) * (cos(aEle))^3 * (11 * (sin(aEle))^2 - 3)
    aEnc[46] = ain1 * (3/16) * sqrt(7) * cos(4 * aAzi) * (cos(aEle))^4 * (11 * (sin(aEle))^2 - 1)
    aEnc[47] = ain1 * (3/8) * sqrt(77/2) * cos(5 * aAzi) * sin(aEle) * (cos(aEle))^5
    aEnc[48] = ain1 * (1/16) * sqrt(231/2) * cos(6 * aAzi) * (cos(aEle))^6

    ;7 order
    aEnc[49] = ain1 * (1/32) * sqrt(429) * sin(7 * aAzi) * (cos(aEle))^7
    aEnc[50] = ain1 * (1/16) * sqrt(3003/2) * sin(6 * aAzi) * sin(aEle) * (cos(aEle))^6
    aEnc[51] = ain1 * (1/32) * sqrt(231) * sin(5 * aAzi) * (13 * (sin(aEle))^2 - 1) * (cos(aEle))^5
    aEnc[52] = ain1 * (1/16) * sqrt(231) * sin(4 * aAzi) * (13 * (sin(aEle))^3 - 3 * sin(aEle)) * (cos(aEle))^4
    aEnc[53] = ain1 * (1/32) * sqrt(21) * sin(3 * aAzi) * (143 * (sin(aEle))^4 - 66 * (sin(aEle))^2 + 3) * (cos(aEle))^3
    aEnc[54] = ain1 * (1/16) * sqrt(21/2) * sin(2 * aAzi) * (143 * (sin(aEle))^5 - 110 * (sin(aEle))^3 + 15 * sin(aEle)) * (cos(aEle))^2
    aEnc[55] = ain1 * (1/32) * sqrt(7) * sin(aAzi) * (429* (sin(aEle))^6 - 495 * (sin(aEle))^4 + 135* (sin(aEle))^2 - 5) * cos(aEle)
    aEnc[56] = ain1 * (1/16) * (429 * (sin(aEle))^7 - 693 * (sin(aEle))^5 + 315 * (sin(aEle))^3 - 35 * sin(aEle))
    aEnc[57] = ain1 * (1/32) * sqrt(7) * cos(aAzi) * (429 * (sin(aEle))^6 - 495 * (sin(aEle))^4 + 135 * (sin(aEle))^2 - 5) * cos(aEle)
    aEnc[58] = ain1 * (1/16) * sqrt(21/2) * cos(2 * aAzi) * (143 * (sin(aEle))^5 - 110 * (sin(aEle))^3 + 15 * sin(aEle)) * (cos(aEle))^2
    aEnc[59] = ain1 * (1/32) * sqrt(21) * cos(3 * aAzi) * (143 * (sin(aEle))^4 - 66 * (sin(aEle))^2 + 3) * (cos(aEle))^3
    aEnc[60] = ain1 * (1/16) * sqrt(231) * cos(4 * aAzi) * (13 * (sin(aEle))^3 - 3 * sin(aEle)) * (cos(aEle))^4
    aEnc[61] = ain1 * (1/32) * sqrt(231) * cos(5 * aAzi) * (13 * (sin(aEle))^2 - 1) * (cos(aEle))^5
    aEnc[62] = ain1 * (1/16) * sqrt(3003/2) * cos(6 * aAzi) * sin(aEle) * (cos(aEle))^6
    aEnc[63] = ain1 * (1/32) * sqrt(429) * cos(7 * aAzi) * (cos(aEle))^7


    xout aEnc

endop
;----------------ENCODER 7 order AMBIX----------------------
