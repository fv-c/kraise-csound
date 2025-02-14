;KRAISE - 7 order Ambisonics
<CsoundSynthesizer>

    <CsOptions>
        -n -d -+rtmidi=NULL -M0 -m0d
    </CsOptions>

    <CsInstruments>
    ksmps = 32
    nchnls = 64
    0dbfs = 1
    
    ;libUDO FILE
    #include "kraiseUDO.csd"

    ;variabili audio
    gaLDry init 0
    gaRDry init 0
    gaBformatOut[] init 64
    
    giFFTSIZE_CONTROL[] fillarray 128,256,512,1024,2048,4096
    giOVERLAPS_CONTROL[] fillarray 2,4,8,16
    
    instr 1
        ;CONTROLS   
        #include "Controls.csd"
        
        schedule 10,0.001,360
        schedule 20,0.001,360
        schedule 50,0.001,360
     
    endin

    instr 10
        ;-----------IN CH------------------------        
        aMono gauss 0.1;inch 1
        
        ;out aMono
        ;----------------------------------------
        
        ;----------FFT---------------------------
        if changed(gkFFTSIZE, gkOVERLAPS) = 1 then
        reinit RESTART
        endif
        
        RESTART:;restart fft - change fftsize, overlaps
        gkOutFreq[]  init giFFTSIZE_CONTROL[i(gkFFTSIZE) - 1] / 2
        gkOutAmp[]   init giFFTSIZE_CONTROL[i(gkFFTSIZE) - 1] / 2
         
        ;UDO FFT_ANALYSIS
        gkOutFreq[],gkOutAmp[] FFT_ANALYSIS aMono, giFFTSIZE_CONTROL[i(gkFFTSIZE) - 1], giOVERLAPS_CONTROL[i(gkOVERLAPS) - 1]
        ;-----------------------------------------
        
    endin

    instr 20
        ;---------DENS - DUR ---------------------
        ;aggiungere densitÃ  e durata randommica (sempre in percentuale 50% a destrsa e 50% sinistra)
        ktrig metro gkDENS
        schedkwhen ktrig, 0, 0, 30, 0, gkDUR
        ;------------------------------------------
 
        ;---------RANDOM BIN---------------------------------
        gkRand randomh (giNumBin * gkrangeMIN_BIN) , (giNumBin * gkrangeMAX_BIN) , gkDENS 
        
        gkIntBin = int(gkRand) 
        gkAmp = gkOutAmp[gkIntBin]
        gkFreq = gkOutFreq[gkIntBin]
        ;----------------------------------------------------
        
        ;----------SPATIAL SPREAD------------------
        gkSpredBform randomh -1 * gkSPSpatial,1 * gkSPSpatial,gkDENS
        ;------------------------------------------
    endin

    instr 30     
        ;-------ENVELOPE------------------------------------------------------------
        iAttPerc = i(gkENV)
        iDur = i(gkDUR)
        iRampL = i(gkENVFORM)
        iRampR = i(gkENVFORM)
        aEnv transeg 0, iDur * iAttPerc, iRampL, 1, iDur * (1 - iAttPerc), iRampR, 0
        ;---------------------------------------------------------------------------
         
        ;-------FREQUENCY-----------------------------------------------------------       
        iFreq0 = (i(gkFreq) * i(gkPITCHSHIFT)) + i(gkFREQSHIFT)
        iFreq = (i(gkMAGFREQ) - iFreq0) * (i(gkMAGPERC)) + iFreq0
        ;---------------------------------------------------------------------------
                  
        ;-------OSCILI---------
        aAmp = i(gkAmp)
        aFreq = iFreq
        
        aSig oscili aAmp, aFreq
        
        ;SIGNAL OUT - ENV
        aOut = aSig  * aEnv 
        ;----------------------
        
        ;------SPATIAL----------------------------------------------------------------
        aBformat[] init 64
        
        ;UDO Encoder7order
        aAzi  = i(gkAZI) + (i(gkSpredBform) * 360)
        aElev = i(gkELEV) + (i(gkSpredBform) * 90)
        
        aBformat Encoder7order aOut, aAzi, aElev
        
        gaBformatOut = gaBformatOut + aBformat;SEND TO INSTR 50
        ;---------------------------------------------------------------------------ls
    endin
    
    
    instr 50;OUTS 
        out gaBformatOut * gkWET;OUT ARRAY
        gaformatOut[] init 64
        ;clear gaBformatOut ;CLEAR ARRAY GLOBAL AUDIO
    endin
   

    </CsInstruments>

    <CsScore>
        i1 0 360
        

    </CsScore>

</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
