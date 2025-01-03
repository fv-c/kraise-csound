/*
kraiseControls.csd

Written by Francesco Vitucci, Anthony Di Furia, Giuseppe Silvi, Daniele Annese, 2024
https://github.com/fv-c/kraise
*/

;------------CONTROLS----------------------------------------------
        ;filepath
        gSfilepath      cabbageGetValue "filename" 
        ;play stop
        gkPlayStop      cabbageGetValue "PlayStop"   
        gkRatePlay      cabbageGetValue "ratePlay"
        ;Position
        gkBeg           cabbageGetValue "beg"
        gkEnd           cabbageGetValue "len"
        
        ;FFT
        gkFFTSIZE       cabbageGetValue "FFTSIZE"
        gkOVERLAPS      cabbageGetValue "OVERLAPS"
        gkFFTPITCH      cabbageGetValue "FFTPITCH"
        gkFREEZE        cabbageGetValue "FREEZE"
        gkrangeMIN_BIN  cabbageGetValue "rangeMIN_BIN"
        gkrangeMAX_BIN  cabbageGetValue "rangeMAX_BIN"
        
        ;ENVETS
        gkDENS          cabbageGetValue "DENS"
        gkDENSRAND      cabbageGetValue "DENSRAND"
        gkDUR           cabbageGetValue "DUR"
        gkDURRAND       cabbageGetValue "DURRAND"
        gkBINtoSYNTH    cabbageGetValue "BINtoSYNTH"
        
        ;SYNTH
        gkENV           cabbageGetValue "ENV"
        gkENVFORM       cabbageGetValue "ENVFORM"
        gkPITCHSHIFT    cabbageGetValue "PITCHSHIFT"
        gkFREQSHIFT     cabbageGetValue "FREQSHIFT"
        gkMAGFREQ       cabbageGetValue "MAGFREQ"
        gkMAGPERC       cabbageGetValue "MAGPERC"
        gkAM_FREQ_RATIO cabbageGetValue "AM_FREQ_RATIO"
        gkAM            cabbageGetValue "AM"
        gkFM_FREQ_RATIO cabbageGetValue "FM_FREQ_RATIO"
        gkFM            cabbageGetValue "FM"
        gkSPSpatial     cabbageGetValue "SPSpatial"
        gkAZI           cabbageGetValue "AZI"
        gkELEV          cabbageGetValue "ELEV"
        
        ;MASTER
        gkDRY           cabbageGetValue "DRY"
        gkWET           cabbageGetValue "WET"
;------------CONTROLS----------------------------------------------