patches-own [r1]
breed [subaks]  ; Water-management collectives
breed [dams]    ; Dams are used to manage ho  w water is divided between subaks
breed [damdam]  ; Links specifying how water travels directly from dam to dam (?)
breed [damsubaks damsubak]     ; Links from subaks to the dams to which they can send water (?)
breed [subakdams subakdam]     ; Links from dams to the subaks to which they can send water (?)
breed [subaksubaks subaksubak] ; Neighbor links between subaks: These determine which subaks' cropping patterns can be copied, and how pests spread.

subaks-own [
  old? 
  mip 
  stillgrowing 
  dpests 
  pestneighbors 
  damneighbors 
  totharvestarea 
  area 
  SCC ;Subak's crop plan
  sd ; start date (month)
  SCCc; help variable during imitation process 
  sdc ;help variable during imitation process
  pests 
  nMS ; counter for number of subaks in masceti  ; <- Janssen's comment.  Variable appears to be UNUSED.
  MS ; masceti (i.e. temple group: a group of subaks)  ; <- Janssen's comment.  Variable appears to be UNUSED.
  masceti ; group of subaks
  dmd
  ulunswi 
  pyharvest 
  pyharvestha 
  WSS  ; seems to have something to do with water usage during rice growth 
  harvest 
  crop 
  ricestage 
  Ymax 
  pest-damage 
  pestloss 
  totLoss 
  source 
  return
]

dams-own [flow0 flow elevation 
WSarea ; WSarea is area (ha) of dams' watershed
damht rain 
EWS ; Effective Watershed Area
areadam Runoff d1 d3 XS 
WSD ; Water Stress Dam
totWSD]

;; These are links between subaks and dams, so the distanceab is the distance between then (?)
damdam-own [a b distanceab]
damsubaks-own [a b distanceab]
subakdams-own [a b distanceab]
subaksubaks-own [a b distanceab]

globals [ subak-data dam-data subaksubak-data subakdam-data new-subaks subaks_array dams_array subakdams_array 
        damsubaks_array Rel Rem Reh month ET RRT LRS Xf devtime yldmax pestsens growthrate cropuse 
        totpestloss  ; reported in the Pestloss plot
        totpestlossarea 
        totWS ; total water stress (?), reported in the Waterstress plot
        totWSarea ; total water stress area (?)
        avgharvestha ; average harvest per hectare?
        ]

to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  set-default-shape subaks "circle"
  set-default-shape dams "square"
  set-default-shape damdam "line"
  set-default-shape damsubaks "line"
  set-default-shape subakdams "line"
  set-default-shape subaksubaks "line"
  
  ;; These will be filled bo load-data (?)
  set subaks_array []
  set dams_array []
  set subakdams_array []
  set damsubaks_array []
  
  ;; There are four possible crops: 3 varieties of rice, and a vegetable.
  ;; Based on procedure growrice, it appears that 0 reps fallow, and 1, 2, 3 rep rice varieties.  4 reps another crop, but that's never used here.
  ;; Note that the fastest-growing, highest max yield is also most sensitive to pests.
  set devtime [0 6 4 3] ; development time for crops
  set yldmax [0 5 5 10] ; maximum yld of rice crops
  set pestsens [0 0.5 0.75 1.0] ; sensitivity of crops to pests
  
  ;; There are 5 elements next, 4 above.  Maybe above is fallow + 3 rice varieties, and this includes also vegetable?
  ;; Or above is vegetable plus rice, and we have fallow here as well?
  ;; Maybe the fifth entries are for the vegetable, since the values are so different.  (?)
  
  ;; The middle 3 values in the next line will be ignored: They're about to be replaced by a value from a slider:
  set growthrate [0.1 2.2 2.2 2.2 0.33] ; monthly growth rate parameter
  set growthrate replace-item 1 growthrate pestgrowth-rate  ; i.e. replace the second element in growthrate with value of the pestgrowth-rate slider
  set growthrate replace-item 2 growthrate pestgrowth-rate  ; i.e. replace the third element ...
  set growthrate replace-item 3 growthrate pestgrowth-rate  ; etc.
  
  set cropuse [0 0.015 0.015 0.015 0.003]  ; use of water per crop parameter
  
  set month 0
  set totpestloss 0       ; reported in the Pestloss plot
  set totpestlossarea 0
  set totWS 0             ; reported in the Waterstress plot
  set totWSarea 0
  set avgharvestha 0      ; average harvest per hectare (?)
  set ET 50 / 30000  ;between 40 and 60 Evapotranspiration rate, mm/mon => m/d
  set RRT ET + 50 / 30000 ;between 0 and 100 Rain-Runoff threshold for 1:1, mm/mon => m/d
  set LRS 1 - ET / RRT  ;LowRainSlope, below threshold for RR relation
  set Xf 1.0 ;between 0.8 and 1.2 X factor for changing minimum groundwater flow

  ask patches [set pcolor (rgb 80 0 80)] ; choose a color that will make all subaks and dams visible under all settings [MA]

  load-data

  ask subaks [set old? false]
  set dams_array sort-by [[who] of ?1 < [who] of ?2] dams
  set subaks_array sort-by [[who] of ?1 < [who] of ?2] subaks

  ask dams [set areadam 0]
  ask subaks [
    let returndam self ; dummy value initialization: overwritten a few lines down
 	  let sourcedam self ; dummy value initialization: overwritten a few lines down
 	  let subak self
 	  set stillgrowing false
    set returndam [b] of one-of subakdams with [a = subak]
    set sourcedam [a] of one-of damsubaks with [b = subak]
    let areasubak area
    ifelse (returndam = sourcedam) [
      ask returndam [set areadam areadam + areasubak] 
    ][
      ask sourcedam [set areadam areadam + areasubak]
    ]
    set pyharvest 0
    set pyharvestha 0
    ; initial cropping plans are randomly allocated
    set SCC random nrcropplans  ; Note: OVERWRITTEN A FEW LINES DOWN (why?)
    set sd random 12            ; Note: OVERWRITTEN A FEW LINES DOWN (why?)
    cropplan SCC sd             ; set subak's current crop. Note: OVERWRITTEN A FEW LINES DOWN (why?)
    set totharvestarea 0
    if Color_subaks = "cropping plans" [set color SCC * 6 + sd] ; Note: IGNORED A FEW LINES DOWN (why?)
  ]

  ask dams [set flow0 flow0 * Xf * 86400]
  ask dams [set EWS WSarea - areadam]
  ; Effective Watershed Area EWS of each dam is reduced by cultiv'n area areadam because rain onto sowa
  ; enters the irrig'n system meeting immediate demand directly or passing on to the downstream irrigation point

  ask subaks [
    let sdhelp 0
    set SCC random nrcropplans ; Note: OVERWRITES VALUE A FEW LINES ABOVE (why?)
    set sd random 12           ; Note: OVERWRITES VALUE A FEW LINES ABOVE (why?)
;    set SCC 0  ; MARSHALL EXPERIMENT
;    set sd 0   ; MARSHALL EXPERIMENT
    set pests 0.01
    set old? false
    cropplan SCC sd            ; Note: OVERWRITES VALUE A FEW LINES ABOVE (why?)
    ricestageplan SCC sd
    let subak1 self
    ask subaks [
      if [source] of self = [source] of subak1 [ask subak1 [set damneighbors lput self damneighbors]] 
    ]
  ]
end

to go
  let gr2 0
  let gr3 0
  set gr2 pestgrowth-rate
  set gr3 pestgrowth-rate
  ask subaks [set mip sd + month if mip > 11 [set mip mip - 12]]
  ask subaks [
    cropplan SCC mip
    if stillgrowing [if ((crop = 0) or (crop = 4)) [set stillgrowing false]]
 ]
  
  demandwater
  determineflow
  growrice
  growpest
  determineharvest

  if month = 11 [set totpestloss totpestloss / totpestlossarea set totWS totWS / totWSarea]
  if month = 11 [plot-figs]
  if month = 11 [imitatebestneighbors]

  ifelse month = 11 
  [set month 0 set totWSarea 0 set totWS 0 ask subaks [set pyharvest 0 set pyharvestha 0 set totpestloss 0 set totpestlossarea 0 set totharvestarea 0 set pests 0.01]]
  [set month month + 1]
end

to demandwater
  ; determine the water demand for different subaks
    ask dams [
    if rainfall-scenario = "low" [rainfall damht 0]
    if rainfall-scenario = "middle" [rainfall damht 1]
    if rainfall-scenario = "high" [rainfall damht 2]
    set rain rain / 30000
    ifelse rain < RRT [
  	  set Runoff rain * LRS * EWS * 10000 	; 'm/d * ha* m2/ha => m3/d for basin
     ][
      set Runoff (rain - ET) * EWS * 10000
      if (Runoff < 0) [set Runoff 0]
   ]]
;       		Demand for each Subak based on cropping pattern, less any rainfall.
;        		dmd may be + or - because local rain can exceed demand ==> an excess.

  ask subaks [
;    		cropuse is m/d demand for the 4 crops:
    if Color_subaks = "crops" [
      if crop = 0 [ set color green]  ; fallow
      if crop = 1 [ set color cyan]   ; rice variety 1
      if crop = 2 [ set color yellow] ; rice variety 2
      if crop = 3 [ set color white]  ; rice variety 3
      if crop = 4 [ set color red]    ; alternate, non-rice crop (?)
      ]
    set dmd item crop cropuse - [rain] of return
    set dmd dmd * area * 10000
  ]
;			Sum the partial demands for areas 1, 2, & 3 of each dam
  ask dams [set d1 0  set d3 0  set XS 0 ]

;   			In each case, put dmd<0 into excess (XS)
;    			Total dmd for all Subaks inside basin taking flow before the dam

  ask subaks [
    let returndam self
    let sourcedam self
    let subak self
    set returndam [b] of one-of subakdams with [a = subak]
    set sourcedam [a] of one-of damsubaks with [b = subak]
    ifelse (returndam = sourcedam)
    [ 
      let dmdsubak dmd
      ifelse dmd > 0 [
        ask returndam [set d1 d1 + dmdsubak]
      ][
        ask returndam [set XS XS - dmdsubak]]]
;  			Any excess of rain>dmd for Subaks in basin but source outside 
;				Excess always returned to this dam, i.e. location = the downstream dam
      [
        let dmdsubak dmd
        if dmd < 0 [ask returndam [set XS XS - dmdsubak]]
;	  		Downstream irrig'n dmd drawn from this dam; >0 only, no excess allowed
        if dmd > 0 [ask sourcedam [set d3 d3 + dmdsubak]]]]
end

to determineflow
  let bool 0
  ask dams [
    if bool = 0 [
      set bool 1 ; dirty trick to make sure upstream subaks are updated first
      foreach dams_array [
        let dam1 self
        set flow flow0 + Runoff - d1 + XS - d3
        foreach dams_array [
          let flowadd flow
          if (count damdam with [a = self and b = dam1] + count damdam with [a = dam1 and b = self]) > 0
          [
				    ask dam1 [set flow flow + flowadd]
			    ]
        ]
				ifelse flow < 0 [
					ifelse ((d1 + d3) = 0) [][
						set WSD 1 + flow / (d1 + d3)
						set d1 d1 * WSD
						set d3 d3 * WSD
						set flow 0 ; waterstress
			  ]] [set WSD 1]
				set totWSD totWSD + WSD
	]]]
  ask subaks [
    let subak1 self
    set WSS [WSD] of [a] of one-of damsubaks with [b = subak1]
    set dmd dmd * WSS]
end

;; This is a subak-local procedure.
;; If this subak is growing rice, then advance its growth states
to growrice
    ask subaks [
      let subak1 self   ; UNUSED
      let WSDhelp self  ; UNUSED
      if crop = 0 [set ricestage 0 set WSS 1] ; Fallow period -- i.e. not growing anything
      if crop = 4 [set ricestage 0 set WSS 1] ; Growing paliwiga -- i.e. not growing rice
      if ((crop = 1) or (crop = 2) or (crop = 3)) [  ; i.e. 1, 2, and 3 are the rice varieties
        set WSS [WSD] of source 
        set ricestage ricestage + (WSS / (item crop devtime)) ; i.e. advance growing stage as a function of the rice variety and available water?
 ]]
end

to growpest
  let dxx 100
  let dt 30 ;days
  let dc 0
  let cs 0
  let cN 0
  let minimumpests 0.01
  ask subaks [
    let subak1 self
		set cs 4 * pests
		ask subaks [
		    let subak2 self
        ifelse member? subak1 pestneighbors [set cN pests - [pests] of subak1][set cN 0]
        set cs cs + cN]
    set dc (pestdispersal-rate / dxx) * ( cs - (4 * pests)) * dt ; this is the net change in pest dispersed to or from the subak
		set dpests ((item crop growthrate) * (pests + 0.5 * dc)) + (0.5 * dc)	
		if dpests < minimumpests [set dpests minimumpests]]
		
    ask subaks [set pests dpests if Color_subaks = "pests" [set color 62 + pests ]]
end

to determineharvest
    let hy 0
    let croph 0
    let cropf 0
    ask subaks [
      set harvest 0
      if ((crop = 1) or (crop = 2) or (crop = 3)) [set stillgrowing true]
        set croph crop
        cropplan SCC (mip + 1)
        set cropf crop
        set crop croph
        if (cropf = 0) or (cropf = 4)
        [
          set Ymax ricestage * (item crop yldmax)
					set pest-damage 1 - pests * (item crop pestsens)
					if pest-damage < 0 [set pest-damage 0]
          set harvest Ymax * pest-damage
					set pestloss pestloss + Ymax * (1 - pest-damage) * area
					set totLoss totLoss + pestloss
					set hy hy + harvest * area
					set pyharvest pyharvest + harvest * area
					set pyharvestha pyharvestha + harvest
					set totpestloss totpestloss + area * (1 - pest-damage) * Ymax
          set totpestlossarea totpestlossarea + area
          set totWS totWS + (1 - ricestage) * area
          set totWSarea totWSarea + area
          set totharvestarea totharvestarea + area
				]]
end

to imitatebestneighbors
  let minharvest 0
  let maxharvest 0
    ask subaks [
      if (crop = 1 or crop = 2 or crop = 3)[
      let bestneighbor self
      set minharvest pyharvestha
      set maxharvest minharvest
      foreach pestneighbors [
        ask ? [
          if pyharvestha > maxharvest
          [
            set maxharvest pyharvestha
            set bestneighbor self
      ]]
      ifelse maxharvest > minharvest [set SCCc [SCC] of bestneighbor set sdc [sd] of bestneighbor][set SCCc SCC set sdc sd]]
    ]]

  ask subaks [
    set SCC SCCc
    set sd sdc
    if Color_subaks = "cropping plans" [
      set color SCC * 6 + sd
      if-else id_colors
        [set label (word SCC ", " sd)]
        [set label ""]
    ]
  ]
end

to setup-plot
  set-current-plot "Harvest"
  set-plot-y-range 0 30
  set-current-plot "Pestloss"
  set-plot-y-range 0 1
  set-current-plot "Waterstress"
  set-plot-y-range 0 1
end

to plot-figs
  let totarea 0
  let totharvest 0
  set-current-plot "Harvest"
  ask subaks [
    set totarea totarea + totharvestarea
    set totharvest totharvest + pyharvest
  ]
  set-current-plot-pen "harvest"
  set avgharvestha totharvest / totarea
  plot avgharvestha
  
  set-current-plot "Pestloss"
  plot totpestloss
  
  set-current-plot "Waterstress"
  plot totWS
end

;========================= data ========================================
to load-data
  ifelse ( file-exists? "subakdata.txt" )
  [
    ;; We are saving the data into a list, so it only needs to be loaded once.
    set subak-data []
    file-open "subakdata.txt"
    while [ not file-at-end? ]
    [
      ;; file-read gives you variables.  
      ;; We store them in a double list (ex [[1 2 3 4 5 6] [1 2 3 4 5 6] ...
      set subak-data sentence subak-data (list (list file-read file-read file-read file-read file-read file-read)) ; 6 reads
    ]
    file-close
  ][ 
    user-message "There is no subakdata.txt file in current directory!" 
  ]
  
  ifelse ( file-exists? "damdata.txt" )
  [
    set dam-data []
    file-open "damdata.txt"
    while [ not file-at-end? ]
      [set dam-data sentence dam-data (list (list file-read file-read file-read file-read file-read file-read file-read))] ; 7 reads
    file-close
  ][ 
    user-message "There is no damdata.txt file in current directory!" 
  ]

  ifelse ( file-exists? "subaksubakdata.txt" )
  [
    set subaksubak-data []
    file-open "subaksubakdata.txt"
    while [ not file-at-end? ]
      [set subaksubak-data sentence subaksubak-data (list (list file-read file-read))] ; 2 reads
    file-close
  ][ 
    user-message "There is no subaksubakdata.txt file in current directory!" 
  ]
  
  ifelse ( file-exists? "subakdamdata.txt" )
  [
    set subakdam-data []
    file-open "subakdamdata.txt"
    while [ not file-at-end? ]
      [ set subakdam-data sentence subakdam-data (list (list file-read file-read file-read))] ; 2 reads
    file-close
  ][ 
    user-message "There is no subakdamdata.txt file in current directory!" 
  ]
  
  foreach subak-data [  
    create-subaks 1 [
      set color white 
      ;; note we skip the 0th element, which is a subak id number.
      setxy (item 1 ?) (item 2 ?) 
      set area item 3 ? 
      set masceti item 4 ? 
      set ulunswi item 5 ? ; what is this? (?)
      set pestneighbors [] 
      set damneighbors [] 
      set subaks_array lput self subaks_array
      if Color_subaks = "Temple groups" [
        if masceti = 1 [set color white]
        if masceti = 2 [set color yellow]
        if masceti = 3 [set color red]
        if masceti = 4 [set color blue]
        if masceti = 5 [set color cyan]
        if masceti = 6 [set color pink]
        if masceti = 7 [set color orange]
        if masceti = 8 [set color lime]
        if masceti = 9 [set color sky]
        if masceti = 10 [set color violet]
        if masceti = 11 [set color magenta]
        if masceti = 12 [set color green]
        if masceti = 13 [set color turquoise]
        if masceti = 14 [set color brown] 
   ]]]


;; MARSHALL HERE
  foreach dam-data [
    create-dams 1 [ 
      set color yellow
      ;; we skip the 0th element 
      setxy (item 1 ?) (item 2 ?) 
      set flow0 item 3 ? 
      set elevation item 4 ? 
      set WSarea item 5 ? 
      set damht item 6 ?
      set dams_array lput self dams_array
  ]]

  linkdams

  foreach subaksubak-data [make-subaksubak (item first ? subaks_array) (item last ? subaks_array)]

  foreach subakdam-data [make-subakdams (item first ? subaks_array) (item (item 1 ?) dams_array) (item last ? dams_array)]

end

;; Procedure to set current subak's crop from a cropping plan and month
;; A subak-local procedure: Must be called from within ask subaks [...].  References subaks-own variables.
to cropplan [nr m]          ; cropping plan number, month number (zero-based)
  if m > 11 [set m m - 12]
  ; For each month a crop is defined:
  ; Based on procedure growrice, it appears that 0 represents a fallow period, and 1, 2, & 3 represent rice varieties,
  ; and 4 reps an alternate non-rice crop.  Note none of these crop plans includes that crop.
  ; It appears that variety 1 requires 6 months to grow, variety 2 requires 4 months to grow, and variety 3 requires 3 months to grow.
  ; That's why not all possible combinations of 0's, 1's, 2's, and 3's are included.
	let cropplan0 [3 3 3 0 3 3 3 0 3 3 3 0]
	let cropplan1 [3 3 3 0 0 0 3 3 3 0 0 0]
	let cropplan2 [3 3 3 0 3 3 3 0 0 0 0 0]
	let cropplan3 [3 3 3 0 0 3 3 3 0 0 0 0]
	let cropplan4 [3 3 3 0 0 0 0 3 3 3 0 0]
	let cropplan5 [3 3 3 0 0 0 0 0 3 3 3 0]
	let cropplan6 [1 1 1 1 1 1 0 2 2 2 2 0]
	let cropplan7 [1 1 1 1 1 1 0 3 3 3 0 0]
	let cropplan8 [1 1 1 1 1 1 0 0 3 3 3 0]
	let cropplan9 [1 1 1 1 1 1 0 0 0 0 0 0]
	let cropplan10 [2 2 2 2 0 0 2 2 2 2 0 0]
	let cropplan11 [2 2 2 2 0 2 2 2 2 0 0 0]
	let cropplan12 [2 2 2 2 0 0 0 2 2 2 2 0]
	let cropplan13 [2 2 2 2 0 0 3 3 3 0 0 0]
	let cropplan14 [2 2 2 2 0 3 3 3 0 0 0 0]
	let cropplan15 [2 2 2 2 0 0 0 3 3 3 0 0]
	let cropplan16 [2 2 2 2 0 0 0 0 3 3 3 0]	
	let cropplan17 [3 3 3 0 0 2 2 2 2 0 0 0]
	let cropplan18 [3 3 3 0 0 0 2 2 2 2 0 0]
	let cropplan19 [3 3 3 0 2 2 2 2 0 0 0 0]
	let cropplan20 [3 3 3 0 0 0 0 2 2 2 2 0]

  if nr = 0 [set crop item m cropplan0]  ; i.e. set this subak's crop var to the crop number at month m in cropping plan nr
  if nr = 1 [set crop item m cropplan1]
  if nr = 2 [set crop item m cropplan2]
  if nr = 3 [set crop item m cropplan3]
  if nr = 4 [set crop item m cropplan4]
  if nr = 5 [set crop item m cropplan5]
  if nr = 6 [set crop item m cropplan6]
  if nr = 7 [set crop item m cropplan7]
  if nr = 8 [set crop item m cropplan8]
  if nr = 9 [set crop item m cropplan9]
  if nr = 10 [set crop item m cropplan10]
  if nr = 11 [set crop item m cropplan11]
  if nr = 12 [set crop item m cropplan12]
  if nr = 13 [set crop item m cropplan13]
  if nr = 14 [set crop item m cropplan14]
  if nr = 15 [set crop item m cropplan15]
  if nr = 16 [set crop item m cropplan16]
  if nr = 17 [set crop item m cropplan17]
  if nr = 18 [set crop item m cropplan18]
  if nr = 19 [set crop item m cropplan19]
  if nr = 20 [set crop item m cropplan20]
end

to ricestageplan [nr m]
	let ricestageplan0 [0 0.33 0.67 0 0 0.33 0.67 0 0 0.33 0.67 0]
	let ricestageplan1 [0 0.33 0.67 0 0 0 0 0.33 0.67 0 0 0]
	let ricestageplan2 [0 0.33 0.67 0 0 0.33 0.67 0 0 0 0 0]
	let ricestageplan3 [0 0.33 0.67 0 0 0 0.33 0.67 0 0 0 0]
	let ricestageplan4 [0 0.33 0.67 0 0 0 0 0 0.33 0.67 0 0]
	let ricestageplan5 [0 0.33 0.67 0 0 0 0 0 0 0.33 0.67 0]
	let ricestageplan6 [0 0.16 0.33 0.5 0.67 0.84 0 0 0.25 0.5 0.75 0]
	let ricestageplan7 [0 0.16 0.33 0.5 0.67 0.84 0 0 0.33 0.67 0 0]
	let ricestageplan8 [0 0.16 0.33 0.5 0.67 0.84 0 0 0 0.33 0.67 0]
	let ricestageplan9 [0 0.16 0.33 0.5 0.67 0.84 0 0 0 0 0 0]
	let ricestageplan10 [0 0.25 0.5 0.75 0 0 0 0.25 0.5 0.75 0 0]
	let ricestageplan11 [0 0.25 0.5 0.75 0 0 0.25 0.5 0.75 0 0 0]
	let ricestageplan12 [0 0.25 0.5 0.75 0 0 0 0 0.25 0.5 0.75 0]
	let ricestageplan13 [0 0.25 0.5 0.75 0 0 0 0.33 0.67 0 0 0]
	let ricestageplan14 [0 0.25 0.5 0.75 0 0 0.33 0.67 0 0 0 0]
	let ricestageplan15 [0 0.25 0.5 0.75 0 0 0 0 0.33 0.67 0 0]
	let ricestageplan16 [0 0.25 0.5 0.75 0 0 0 0 0 0.33 0.67 0]	
	let ricestageplan17 [0 0.33 0.67 0 0 0 0.25 0.5 0.75 0 0 0]
	let ricestageplan18 [0 0.33 0.67 0 0 0 0 0.25 0.5 0.75 0 0]
	let ricestageplan19 [0 0.33 0.67 0 0 0.25 0.5 0.75 0 0 0 0]
	let ricestageplan20 [0 0.33 0.67 0 0 0 0 0 0.25 0.5 0.75 0]

  if nr = 0 [set ricestage item m ricestageplan0]
  if nr = 1 [set ricestage item m ricestageplan1]
  if nr = 2 [set ricestage item m ricestageplan2]
  if nr = 3 [set ricestage item m ricestageplan3]
  if nr = 4 [set ricestage item m ricestageplan4]
  if nr = 5 [set ricestage item m ricestageplan5]
  if nr = 6 [set ricestage item m ricestageplan6]
  if nr = 7 [set ricestage item m ricestageplan7]
  if nr = 8 [set ricestage item m ricestageplan8]
  if nr = 9 [set ricestage item m ricestageplan9]
  if nr = 10 [set ricestage item m ricestageplan10]
  if nr = 11 [set ricestage item m ricestageplan11]
  if nr = 12 [set ricestage item m ricestageplan12]
  if nr = 13 [set ricestage item m ricestageplan13]
  if nr = 14 [set ricestage item m ricestageplan14]
  if nr = 15 [set ricestage item m ricestageplan15]
  if nr = 16 [set ricestage item m ricestageplan16]
  if nr = 17 [set ricestage item m ricestageplan17]
  if nr = 18 [set ricestage item m ricestageplan18]
  if nr = 19 [set ricestage item m ricestageplan19]
  if nr = 20 [set ricestage item m ricestageplan20]
end

to linkdams
  make-damdam (item 0 dams_array) (item 5 dams_array)
  make-damdam (item 5 dams_array) (item 6 dams_array)
  make-damdam (item 6 dams_array) (item 8 dams_array)
  make-damdam (item 1 dams_array) (item 7 dams_array)
  make-damdam (item 7 dams_array) (item 8 dams_array)
  make-damdam (item 2 dams_array) (item 9 dams_array)
  make-damdam (item 3 dams_array) (item 9 dams_array)
  make-damdam (item 4 dams_array) (item 9 dams_array)
  make-damdam (item 9 dams_array) (item 10 dams_array)
  make-damdam (item 10 dams_array) (item 11 dams_array)
end

to rainfall [hight level]
; rainfall scenarios for different latitudes
  if (hight = 0) [
    set Rel [114 118 100   8  21   0   0  2   1   0  28 114]
    set Rem [252 269 167  67  96  96 110 48  64 101 150 271]
    set Reh [390 420 234 126 171 192 220 94 127 202 272 428]
  levelrainfall level]

  if hight = 1 [
    set Rel [200 167 131  63  42  62   0   0   0  26  92 156]
    set Rem [364 278 230 135 131 153 160  84 109 194 220 298]
    set Reh [528 389 329 207 220 244 320 168 218 362 348 440]
  levelrainfall level]

  if hight = 2 [
    set Rel [215 227 205 100 121  51   6   4  67  45 138 243]
    set Rem [282 274 319 181 206 141  95 138 249 265 267 327]
    set Reh [349 321 433 262 291 231 184 272 431 485 396 411]
  levelrainfall level] 

  if hight = 3 [
    set Rel [148 210 120  53  53  54   8  13   0  45 112 192]
    set Rem [348 291 221 138 124 160 183 106 136 179 241 312]
    set Reh [548 372 322 223 195 266 358 199 272 313 370 432]
  levelrainfall level]

  if hight = 4 [
    set Rel [289 234 249 125  78  13   0   6  10  57 141 281]
    set Rem [418 384 372 246 208 128 114  68  77 162 268 405]
    set Reh [547 534 495 367 338 243 228 130 144 267 395 529]
  levelrainfall level] 

end

to levelrainfall [level]
  if level = 0 [set rain item month Rel] 
  if level = 1 [set rain item month Rem] 
  if level = 2 [set rain item month Reh] 
end

to make-damdam [dam1 dam2]
  create-damdam 1
  [
    set color blue
    set a dam1
    set b dam2
    reposition-edges
  ]
end

to make-subaksubak [s1 s2]
  create-subaksubaks 1
  [
    set color green
    set a s1
    set b s2
    reposition-edges
  ]
  ask s1 [set pestneighbors lput s2 pestneighbors] 
end

to make-subakdams [s1 s2 s3]
  create-subakdams 1
  [
    set color blue
    set a s1
    set b s2
    reposition-edges
    if not viewdamsubaks [set size 0]
  ]
    create-damsubaks 1
  [
    set color blue
    set a s3
    set b s1
    reposition-edges
    if not viewdamsubaks [set size 0]
  ]
  ask s1 [set source s3 set return s2]
end

to reposition-edges  ;; edges procedure
  setxy ([xcor] of a) ([ycor] of a)
  set size distance b
  set distanceab distance b
  ;; watch out for special case where a and b are
  ;; at the same place
  if size != 0
  [
    ;; position edges at midpoint between a and b
    set heading towards b
    jump size / 2
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
178
11
798
652
30
30
10.0
1
10
1
1
1
0
0
0
1
-30
30
-30
30
0
0
1
ticks
30.0

BUTTON
108
11
171
44
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
108
48
171
81
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
11
99
44
num-subaks
num-subaks
172
172
172
1
1
NIL
HORIZONTAL

SLIDER
7
48
99
81
num-dams
num-dams
12
12
12
1
1
NIL
HORIZONTAL

SLIDER
4
96
176
129
pestgrowth-rate
pestgrowth-rate
2
2.4
2.2
0.01
1
NIL
HORIZONTAL

SLIDER
1
135
178
168
pestdispersal-rate
pestdispersal-rate
0.6
1.5
1
0.01
1
NIL
HORIZONTAL

PLOT
803
15
1128
247
Harvest
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"harvest" 1.0 0 -10899396 true "" ""

CHOOSER
1
268
176
313
rainfall-scenario
rainfall-scenario
"low" "middle" "high"
1

PLOT
802
473
1127
696
Pestloss
NIL
NIL
0.0
1.0
0.0
0.1
true
false
"" ""
PENS
"totpestloss" 1.0 0 -2674135 true "" ""

PLOT
801
248
1127
472
Waterstress
NIL
NIL
0.0
1.0
0.0
0.1
true
false
"" ""
PENS
"totWS" 1.0 0 -13345367 true "" ""

SWITCH
2
318
146
351
viewdamsubaks
viewdamsubaks
1
1
-1000

CHOOSER
1
174
176
219
nrcropplans
nrcropplans
6 21
1

CHOOSER
0
358
148
403
Color_subaks
Color_subaks
"Temple groups" "cropping plans" "crops" "pests"
1

SWITCH
1
454
120
487
id_colors
id_colors
1
1
-1000

TEXTBOX
5
411
155
453
If on, display identifiying info on whatever subak colors represent:
11
0.0
1

TEXTBOX
5
490
155
518
(Not yet implemented for all choices.)
11
0.0
1

@#$#@#$#@
## LICENSE

This is a replication of the model reported in Lansing, J.S., J.N. Kremer (1993) Emergent properties of Balinese water temples. American Anthropologist 95 (1), 97-114, based on code provided by the authors

The replication is performed by Marco A. Janssen, Arizona State University, November 2006.  
Replication of Lansing and Kremer model Copyright (C) 1993 Lansing and Kremer ((original) Copyright (C) 2006 M.A. Janssen (replication)  
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.  
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.  
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

## ODD DESCRIPTION

The purpose of this model is to understand how local interactions between subaks, local irrigation communities, lead to high performance of rice production is a complex irrigation network.  
Reference: Lansing, J. Stephen, and James N. Kremer (1993) Emergent properties of Balinese water temples. American Anthropologist 95:97-114.

State variables and scales

The model consists of 172 subaks, who act as independent agents. These subaks are within a complex irrigation network that describes 2 rivers. A total of 11 dams act as points where subaks get their water or return their water left over.  
Subaks are indirectly connected via waterways, they share water from the same dams, and directly via spatial proximity which makes it possible for pests to spread between neighboring subaks. Each subak has a specific area of land available which affect the demand for water.

Process overview and scheduling

One time step is equivalent to one month. Subaks decide each year which of the 21 cropping patterns to follow. A cropping pattern determines which crop to plant in which month. There are 3 rice variety, fallow and vegetables.  
Subaks imitate the cropping pattern of a neighbor, if there is a neighboring subak who had a higher harvest per ha during the previous year. Since Lansing and Kremer are not clear in their definition of neighbors, we implemented two type of neighbors, those who are directly connected in the spread of pests, and secondly, those subaks with whom a subak share the same dam as the source of water.  
Practically, a subak can not directly implement a new cropping pattern in the new year, since it may still have crops on the fields. It is not clear how Lansing and Kremer implemented this. To reproduce their results, we assumed that each year the pest start at initial values (0.01) and a new cropping pattern. 

The monthly schedule of activities is to determine for all subaks the following processes:  
- Demand for water  
- Water flows  
- Rice  
- Pest  
- Harvest

Design concepts

Emergence: the evolving pattern of cropping plans mimic the temple groups at the masceti temple level. Thus local adjustments of synchronization of cropping plans lead to high performance of harvest with similar organization structures as observed in the field.  
Adaptation: Each year the subak can adapt their cropping plan.  
Fitness: harvest of rice per ha is used to evaluate the performance of a cropping plan for a subak.  
Stochasticity: the only stochasticity is the initialization of the cropping plans.

Initialization  
Each subaks get randomly allocated one of the 21 cropping plans, and start this plan in a randomly determined month.

Inputs  
The following data are input in the model, and are provided in the code of the model:  
- Water network of dams and subaks  
- Network of subaks who can disperse pest to eachother  
- rainfall per month for different elevations (three different scenarios are provided)  
- cropping plans.  
- area of subaks  
- masceti temple subaks belong to  
- for each crop: maximum yield, duration of crop on land before harvest, sensitivity to pests, growth rate of pests when specific crop in on the land.

Submodels  
Demand for irrigation water  
Demand for irrigation water for a subak depends on the difference between the water the crop needs per ha and the rain that fell per ha. This difference is multiplied by the area of land available in the subak.

Demand = (cropuse - rain)*area

     

Water flows  
Starting with dams upstream, the waterflows in dams and subaks are calculated taking into account rainfall and water streaming into canals from upstream.

Rice  
If not enough water is derived for rice, there is waterstress. If rice takes X months to grow, each month the rice is assumed to grow 1/X part. If only a fraction Y<1 of the demanded water is provided, the rice grows that month for a smaller part: Y/X

Pest  
For all neighboring subaks between which pests can disperse calculate the sum (sumpestdif) of pests level of the own subak minus the pest level of a neighboring subak.  
Then calculate dc   
dc = (pestdispersal-rate / dx) * sumpestdif * dt  
and finally determine the pest level:  
Pests = growthrate * (Pests + 0.5 * dc)) + (0.5 * dc)

Harvest  
If it is time to harvest, the harvest of a subak is calculated as follows:  
harvest = ricestage * yldmax * (1 - pests * pestsens) * area,

where ricestage is a value between 0 and 1 representing which fraction of the water demand is provided over the course of the time rice was on the land, yldmax is the maximum yield in optimal conditions, and pestsens is the amount of rice lost for a unit of pest on the land.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>avgharvestha</metric>
    <steppedValueSet variable="pestdispersal-rate" first="0.6" step="0.1" last="1.5"/>
    <enumeratedValueSet variable="num-dams">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-subaks">
      <value value="172"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Templeview">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="who_to_imitate">
      <value value="&quot;pest-neighbors&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="pestgrowth-rate" first="2" step="0.05" last="2.4"/>
  </experiment>
  <experiment name="experiment2" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>avgharvestha</metric>
    <enumeratedValueSet variable="num-subaks">
      <value value="172"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrcropplans">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <steppedValueSet variable="pestgrowth-rate" first="2" step="0.05" last="2.4"/>
    <enumeratedValueSet variable="who_to_imitate">
      <value value="&quot;pestdam-neighbors&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="pestdispersal-rate" first="0.6" step="0.1" last="1.5"/>
    <enumeratedValueSet variable="num-dams">
      <value value="12"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment3" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="121"/>
    <metric>avgharvestha</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2"/>
      <value value="2.1"/>
      <value value="2.2"/>
      <value value="2.3"/>
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-subaks">
      <value value="172"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-dams">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrcropplans">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="0.6"/>
      <value value="1"/>
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;crops&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
