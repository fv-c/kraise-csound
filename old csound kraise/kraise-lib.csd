/*
kraise-lib.csd

Written by Francesco Vitucci, Anthony Di Furia, Giuseppe Silvi, Daniele Annese, 2024

Ambisonics Encoder - ACN SN3D 
Explicit Ambix formulas for High Order Ambisonics
http://pcfarina.eng.unipr.it/Aurora/HOA_explicit_formulas.htm
*/

;--------------LOAD FILE-------------------------
opcode LoadFile, iii, S

    gSfilepath xin

    ;N CHANNELS
    gichans    filenchnls    gSfilepath           
    cabbageSetValue "nch", gichans
 
    ;WRITE TO EMPTY TABLE
    gitableL    ftgen    1,0,0,1,gSfilepath,0,0,1
    gitableR    ftgen    2,0,0,1,gSfilepath,0,0,1
    if gichans==2 then
    gitableR    ftgen    2,0,0,1,gSfilepath,0,0,2
    endif
  
    ;RATE PHASOR
    iphasfreq = sr / (ftlen(gitableL))
 
    ;DRAW WAVEFORM
    Smessage sprintfk "file(%s)", gSfilepath
    chnset Smessage, "filer1"  
  
    xout  iphasfreq, gitableL, gitableR

endop
;--------------LOAD FILE-------------------------


;--------------PLAYER-------------------------
opcode PLAYER, aa, iiikk

itableL, itableR, iphasfreq, kRatePlay, kStart xin

        if changed(kStart)= 1 then
        reinit REPLAY
        endif
         
        REPLAY:
        ares phasor iphasfreq * kRatePlay, i(kStart)  
               
        aOutL table ares, itableL, 1 
        aOutR table ares, itableR, 1

        aMono = (aOutL + aOutR) / 2
    xout  aMono, ares

endop
;--------------PLAYER-------------------------


;-------------FFT-------------------------------------------
opcode FFT_ANALYSIS, k[]k[], aiikk

        aMono, iFFTsize, iOverlaps, gkFFTPITCH, gkFREEZE xin

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
        kCount = kCount + ksmps * (1 - gkFREEZE)
        ;-----------------------------------
  
      xout  gkOutFreq, gkOutAmp

endop  
;-------------FFT-------------------------------------------   



;----------------ENCODER 1 order AMBIX----------------------
opcode EncoderBformat, a[], akk ;SIG, AZI, ELEV

    ain1,kAzi0,kEle0 xin

    aEnc[] init 4

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
  
    xout aEnc

endop
;----------------ENCODER 1 order AMBIX----------------------





;----------------ENCODER 2 order AMBIX----------------------
opcode Encoder2order, a[], akk ;SIG, AZI, ELEV

    ain1,kAzi0,kEle0 xin

    aEnc[] init 9

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
  
    xout aEnc

endop
;----------------ENCODER 2 order AMBIX----------------------




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