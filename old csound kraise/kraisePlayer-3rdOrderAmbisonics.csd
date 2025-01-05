/*
kraisePlayer-3rdOrderAmbisonics.csd

Written by Francesco Vitucci, Anthony Di Furia, Giuseppe Silvi, Daniele Annese, 2024
https://github.com/fv-c/kraise
*/

<Cabbage> bounds(0, 0, 0, 0)
    form caption("Kraise player - 3rd Order Ambisonics") size(850, 600), pluginId("vit3"), colour("40,40,40,255")
    ;TITOLO
    label bounds(294, 10, 551, 25) channel("label10021") text("Kraise player - 3rd Order Ambisonics")
    ;LOAD FILE - RATEPLAY - PLAY/STOP
    filebutton bounds(10, 12, 100, 25), text("Open File", "Open File"),  channel("filename"), shape("ellipse")
    rslider bounds(220, 6, 70, 50), channel("ratePlay"), range(-2, 2, 1, 1, 0.001), text("RATE PLAY")
    checkbox   bounds(120, 11, 100, 25), channel("PlayStop"), text("Play/Stop"), , fontColour:0(255, 255, 255, 255)
    ;FORMA D'ONDA
    soundfiler bounds(4, 60, 843, 142), channel("beg","len"), identChannel("filer1"), colour(0, 255, 255, 255), fontColour(160, 160, 160, 255)
    ;FFT
    groupbox bounds(4, 204, 286, 137) channel("groupbox10005") text("FFT CONTROL")
    label bounds(14, 225, 80, 16) channel("label10009") text("FFT SIZE")
    combobox bounds(14, 240, 80, 20) channel("FFTSIZE") colour:0(147, 210, 0), corners(5), value(5) items("128", "256", "512","1024","2048","4096")
    label bounds(14, 260, 80, 16) channel("label10010") text("OVERLAPS")
    combobox bounds(14, 275, 80, 20) channel("OVERLAPS") colour:0(147, 210, 0), corners(5), value(2) items("2", "4", "8","16")
    checkbox bounds(106, 250, 100, 30) channel("FREEZE") text("FREEZE")
    hrange bounds(10, 295, 276, 50) channel("rangeMIN_BIN", "rangeMAX_BIN") max(1) min(0) range(0, 1, 0:1, 1, 0.001) text("RANGE BIN")
    nslider bounds(180, 265, 50, 30) channel("rangeMIN") range(0, 4096, 0, 1, 1) text("MIN")
    nslider bounds(230, 265, 50, 30) channel("rangeMAX") range(0, 4096, 0, 1, 1) text("MAX")
    ;EVENTS
    groupbox bounds(292, 204, 450, 137) channel("groupbox10004") text("EVENTS")
    rslider bounds(314, 240, 60, 60) channel("DENS") range(1, 500, 50, 1, 0.001) text("DENSITY")
    rslider bounds(378, 240, 60, 60) channel("DENSRAND") range(0, 1, 0, 1, 0.001) text("DENS RAND")
    rslider bounds(484, 240, 60, 60) channel("DUR") range(0.001, 2, 0.5, 1, 0.001) text("DURATION")
    rslider bounds(546, 240, 60, 60) channel("DURRAND") range(0, 1, 0, 1, 0.001) text("DUR RAND")
    rslider bounds(640, 240, 75, 60) channel("BINtoSYNTH") range(0, 1, 1, 1, 0.001) text("BIN to SYNTH")
    ;SYNTH
    groupbox bounds(4, 342, 738, 255) channel("groupbox10020") text("SYNTH")
    rslider bounds(38, 376, 100, 100) channel("ENV") range(0.001, 0.999, 0.5, 1, 0.001) text("ENV")
    rslider bounds(38, 476, 100, 100) channel("ENVFORM") range(0.1, 10, 1, 1, 0.001) text("ENVFORM")   
    rslider bounds(172, 376, 100, 100) channel("PITCHSHIFT") range(0, 2, 1, 1, 0.001) text("PITCH SHIFT")
    rslider bounds(172, 476, 100, 100) channel("FREQSHIFT") range(0, 5000, 0, 1, 1) text("FREQ SHIFT")   
    rslider bounds(282, 376, 100, 100) channel("MAGFREQ") range(20, 5000, 500, 1, 0.001) text("MAGNETIC FREQ")
    rslider bounds(282, 476, 100, 100) channel("MAGPERC") range(0, 200, 0, 1, 0.001) text("MAGNETIC %")   
    rslider bounds(402, 376, 100, 100) channel("AM_FREQ_RATIO") range(0, 2, 0.5, 1, 0.001) text("AM FREQ RATIO")
    rslider bounds(402, 476, 100, 100) channel("AM") range(0, 1, 0, 1, 0.001) text("AM")
    rslider bounds(516, 376, 100, 100) channel("FM_FREQ_RATIO") range(0, 2, 0.5, 1, 0.001) text("FM RATIO FREQ")
    rslider bounds(516, 476, 100, 100) channel("FM") range(0, 5, 0, 1, 0.001) text("FM") 
    rslider bounds(630, 380, 100, 60) channel("SPSpatial") range(0, 1, 0, 1, 0.001) text("SPREAD Bform")
    rslider bounds(630, 445, 100, 60) channel("AZI") range(0, 360, 0, 1, 0.001) text("AZI")
    rslider bounds(630, 510, 100, 60) channel("ELEV") range(-90, 90, 0, 1, 0.001) text("ELEV")
    ;MASTER
    groupbox bounds(744, 204, 103, 393) channel("groupbox10018") text("MASTER")
    vslider bounds(746, 230, 50, 356) channel("DRY") range(0, 1, 0, 1, 0.001) text("DRY")
    vslider bounds(795, 230, 50, 356) channel("WET") range(0, 1, 1, 1, 0.001) text("WET")

</Cabbage>

<CsoundSynthesizer>

    <CsOptions>
        -n -d -+rtmidi=NULL -M0 -m0d
    </CsOptions>

    <CsInstruments>
    ksmps = 32
    nchnls = 16
    0dbfs = 1
    
    ;libUDO FILE
    #include "kraise-lib.csd"

    ;variabili audio
    gaLDry init 0
    gaRDry init 0
    gaBformatOut[] init 16

    gSfilepath init ""
    
    giFFTSIZE_CONTROL[] fillarray 128,256,512,1024,2048,4096
    giOVERLAPS_CONTROL[] fillarray 2,4,8,16
    
    instr 1
        ;CONTROLS   
        #include "kraiseControls.csd"

        ; CHIAMA STRUMENTO 99 per caricare il file 
        prints gSfilepath
        if changed:k(gSfilepath)==1 then       
        event "i",99,0,0
        endif
 
        ;PLAY/OFF
        ktrig2    trigger    gkPlayStop,0.5,0 
        schedkwhen    ktrig2,0,0,2,0,-1  
        schedkwhen    ktrig2,0,0,3,0,-1        

    endin


    instr 99;LOAD FILE 
        
        ;UDO LoadFile
        giphasfreq, gitableL, gitableR LoadFile gSfilepath
 
    endin


    instr 2 

        if gkPlayStop==0 then 
        turnoff
        endif

        ;-----------PLAYER------------------
        kStart = gkBeg / ftlen(gitableL)
        
        aMono, ares PLAYER gitableL, gitableR, giphasfreq, gkRatePlay, kStart
   
        out aMono * gkDRY
        ;-----------------------------------
        
        
        ;---------POSITION WAVEFORM----------------------------------------
        Smessage sprintfk "scrubberPosition(%d)", (k(ares)) * ftlen(gitableL)
        chnset Smessage, "filer1"
        ;------------------------------------------------------------------
        
        
        ;----------FFT---------------------------
        if changed(gkFFTSIZE, gkOVERLAPS)= 1 then
        reinit RESTART
        endif
        
        RESTART:;restart fft - change fftsize, overlaps
        gkOutFreq[]  init giFFTSIZE_CONTROL[i(gkFFTSIZE) - 1] / 2
        gkOutAmp[]   init giFFTSIZE_CONTROL[i(gkFFTSIZE) - 1] / 2
        
        ;UDO FFT_ANAL
        gkOutFreq[],gkOutAmp[] FFT_ANALYSIS aMono, giFFTSIZE_CONTROL[i(gkFFTSIZE) - 1], giOVERLAPS_CONTROL[i(gkOVERLAPS) - 1], gkFFTPITCH, gkFREEZE
        ;-----------------------------------------
 
 
    endin

    instr 3
    
        if gkPlayStop==0 then 
        turnoff
        endif
        
        ;---------DENS - DUR ---------------------
        ktrig metro gkDENS
        schedkwhen ktrig, 0, 0, 4, 0, gkDUR
        ;------------------------------------------
 
        ;---------RANDOM BIN---------------------------------
        cabbageSetValue "rangeMIN", gkrangeMIN_BIN * giNumBin
        cabbageSetValue "rangeMAX", gkrangeMAX_BIN * giNumBin

        gkRand randomh (giNumBin * gkrangeMIN_BIN) * gkBINtoSYNTH, (giNumBin * gkrangeMAX_BIN) * gkBINtoSYNTH, gkDENS 
        
        gkIntBin = int(gkRand) 
        gkAmp = gkOutAmp[gkIntBin]
        gkFreq = gkOutFreq[gkIntBin]
        ;----------------------------------------------------
        
        ;----------SPATIAL SPREAD------------------
        gkSpredBform randomh -1 * gkSPSpatial,1 * gkSPSpatial,gkDENS
        ;------------------------------------------

    endin

    instr 4   

        ;-------ENVELOPE------------------------------------------------------------
        iAttPerc = i(gkENV)
        iDur = i(gkDUR)
        iRampL = i(gkENVFORM)
        iRampR = i(gkENVFORM)
        aEnv transeg 0, iDur * iAttPerc, iRampL, 1, iDur * (1 - iAttPerc), iRampR, 0
        ;---------------------------------------------------------------------------
         
        ;-------FREQUENCY-----------------------------------------------------------       
        iFreq0 = (i(gkFreq) * i(gkPITCHSHIFT)) + i(gkFREQSHIFT)
        iFreq = (i(gkMAGFREQ) - iFreq0) * (i(gkMAGPERC) * 0.01) + iFreq0
        ;---------------------------------------------------------------------------
        
        ;-------MODULATION----------------------------------------------------------
        aMOD_AM oscili i(gkAM), iFreq * i(gkAM_FREQ_RATIO)
        aMOD_FM oscili iFreq * i(gkFM_FREQ_RATIO) * i(gkFM), iFreq * i(gkFM_FREQ_RATIO)
        ;---------------------------------------------------------------------------
              
        ;-------OSCILI---------
        aAmp = i(gkAmp)
        aFreq = iFreq + aMOD_FM
        
        aSig oscili aAmp, aFreq
        aSigAM = aSig * aMOD_AM 
        
        ;SIGNAL OUT - ENV
        aOut = (aSig + aSigAM) * aEnv 
        ;----------------------
        
        ;------SPATIAL----------------------------------------------------------------
        aBformat[] init 4
        
        ;UDO Encoder3order
        aBformat Encoder3order aOut, i(gkAZI) + (i(gkSpredBform) * 360), i(gkELEV) + (i(gkSpredBform) * 90)
        
        gaBformatOut = gaBformatOut + aBformat;SEND TO INSTR 50
        ;---------------------------------------------------------------------------
 

    endin
    
    
    instr 50;OUTS
    
        out gaBformatOut * gkWET;OUT ARRAY
    
        clear gaBformatOut;CLEAR ARRAY GLOBAL AUDIO
    
    endin
   

    </CsInstruments>

    <CsScore>
        f0 z
        i1 0 -1
        i50 0 -1
    </CsScore>

</CsoundSynthesizer>
