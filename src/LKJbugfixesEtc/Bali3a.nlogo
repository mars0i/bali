globals [ subak-data dam-data subaksubak-data subakdam-data   ; filled by load-data from data in text files
          new-subaks subaks_array dams_array subakdams_array 
          damsubaks_array Rel Rem Reh 
          month ; actual month in the current year
          ET RRT LRS Xf devtime yldmax 
          pestsens ; holds sensitivity to pests of each of the rice varieties 
          growthrates cropuse 
          totpestloss  ; reported in the Pestloss plot
          totpestlossarea 
          totWS ; total water stress (?), reported in the Waterstress plot
          totWSarea ; total water stress area (?)
          avgharvestha ; average harvest per hectare?
          all-cropplans ; list all of possible cropplans, each of which is a list of 12 crop ids, one for each month, or 0 for fallow
          cropplans ; list all of chosen cropplans, each of which is a list of 12 crop ids, one for each month, or 0 for fallow
          all-ricestageplans ; list of lists of estimated initial water-used-by-month percentages for each month of each crop plan in all-cropplans
          ricestageplans ; list of lists of estimated initial water-used-by-month percentages for each month of each crop plan in cropplans
          cropplan-bools
          default-pcolor ; color of all patches except when patch color used to indicate start month
        ]

;patches-own [r1]
breed [subaks]  ; Water-management collectives
breed [dams]    ; Dams are used to manage ho  w water is divided between subaks
breed [damdam]  ; Links specifying how water travels directly from dam to dam (?)
breed [damsubaks damsubak]     ; Links from subaks to the dams to which they can send water (?)
breed [subakdams subakdam]     ; Links from dams to the subaks to which they can send water (?)
breed [subaksubaks subaksubak] ; Neighbor links between subaks: These determine which subaks' cropping patterns can be copied, and how pests spread.
                               ; Note that these are one-way links, so in order for communication to go in both directions, two subaksubaks are needed.



subaks-own [
  old? 
  stillgrowing 
  dpests ; deprecated: used in old vesion of one procedure, so I changed it to a local var, now called newpests -MA
  pestneighbors 
  damneighbors 
  totharvestarea 
  area 
  SCC ;Subak's crop plan
  sd ; start date (month).  This is an offset added to the actual month (in global month).
  mip ; "month in progress" or "month in plan"? mip is always = sd + the global var month  (Note never init'ed just takes default val of 0.)
  SCCc; help variable during imitation process ("c" means "copy"?)
  sdc ;help variable during imitation process  ("c" means "copy"?)
  pests 
  nMS ; counter for number of subaks in masceti  ; <- Janssen's comment.  Variable appears to be UNUSED.
  MS ; masceti (i.e. temple group: a group of subaks)  ; <- Janssen's comment.  Variable appears to be UNUSED.
  masceti ; group of subaks
  dmd  ; water demand. see comment in procedure demandwater.
  ulunswi 
  pyharvest   ; stores total of (harvest * area) over the course of a year. used to decide who to imitate.
  pyharvestha ; stores total of (harvest) over the course of a year. used for harvest plot.
  WSS  ; seems to have something to do with water usage during rice growth. "Water Stress Subak"?
  harvest 
  crop ; crop number of the crop am I currently growing this month
  ricestage ; How much of the water needed to grow this rice variety has already been received.
            ; This is initially set by a call to ricestageplan in the setup routine.
            ; After that, it's set in procedure growrice as a function of the water stress variable WSS
            ; and the growing time (from global devtime) of the rice variety (represented by subak variable crop).
  Ymax 
  pest-damage 
  pestloss 
  totLoss 
  source ; dam from which I get water (?)
  return ; dam to which I send leftover water (?)
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



;;;;;;;;;;;;;;;
to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  ;; __clear-all-and-reset-ticks
  clear-all

  set-default-shape subaks "circle"
  set-default-shape dams "square"
  set-default-shape damdam "line"
  set-default-shape damsubaks "line"
  set-default-shape subakdams "line"
  set-default-shape subaksubaks "line"
  set default-pcolor 6 ; gray means 5. 6 to 9 are lighter grays, lower integers get closer to black

  ask patches [set pcolor default-pcolor]
  
  ;; These will be filled by load-data.  subaks_array and dams_array will then be refilled soon after load-data is called.
  set subaks_array []
  set dams_array []
  set subakdams_array []
  set damsubaks_array []
  
  ;; There are four possible crops: 3 varieties of rice, and a vegetable.
  ;; Based on procedure growrice, it appears that 0 reps fallow, and 1, 2, 3 rep rice varieties.  4 reps another crop, but that's never used here.
  ;; Note that the fastest-growing, highest max yield is also most sensitive to pests.
  ;; Based on procedure growrice, it appears that 0 represents a fallow period, and 1, 2, & 3 represent rice varieties,
  ;; and 4 reps an alternate non-rice crop paliwiga (from a comment below).  Note none of these crop plans includes that crop.
  ;; It appears that variety 1 requires 6 months to grow, variety 2 requires 4 months to grow, and variety 3 requires 3 months to grow.
  ;; That's why not all possible combinations of 0's, 1's, 2's, and 3's are included.
  
  ;show (word "initial cropplan-bools: " cropplan-bools)
  ;if-else cropplan-bools = 0
  ;  [show "initial cropplan-bools was 0.  Really!"]
  ;  [show "initial cropplan-bools was actually not 0."]
  
  ;; COMMENT OUT TO SET THIS DIRECTLY IN BEHAVIOR SPACE??
  set cropplan-bools (list cropplan-a  cropplan-b  cropplan-c  cropplan-d  cropplan-e  cropplan-f  cropplan-g cropplan-h cropplan-i  cropplan-j  cropplan-k cropplan-l cropplan-m cropplan-n cropplan-o cropplan-p cropplan-q cropplan-r cropplan-s cropplan-t cropplan-u)

  ;show (word "cropplan-bools after possibly setting: " cropplan-bools)
 
  ;; The possible crop plans (indexed by SCC in subak) beginning from a start month (sd in subak)
  ;; 
  ;;            crop/fallow in month        crop plan number (SCC in subak)
  set all-cropplans [
                     [3 3 3 0 3 3 3 0 3 3 3 0]  ;  0  three fast-growing variety plantings
                     [3 3 3 0 0 0 3 3 3 0 0 0]  ;  1  two fast-growing variety plantings
                     [3 3 3 0 3 3 3 0 0 0 0 0]  ;  2  two fast-growing variety plantings
                     [3 3 3 0 0 3 3 3 0 0 0 0]  ;  3  two fast-growing variety plantings
                     [3 3 3 0 0 0 0 3 3 3 0 0]  ;  4  two fast-growing variety plantings
                     [3 3 3 0 0 0 0 0 3 3 3 0]  ;  5  two fast-growing variety plantings
                     [1 1 1 1 1 1 0 2 2 2 2 0]  ;  6  two multiple variety plantings
                     [1 1 1 1 1 1 0 3 3 3 0 0]  ;  7  two multiple variety plantings
                     [1 1 1 1 1 1 0 0 3 3 3 0]  ;  8  two multiple variety plantings
                     [1 1 1 1 1 1 0 0 0 0 0 0]  ;  9  one planting, traditional variety
                     [2 2 2 2 0 0 2 2 2 2 0 0]  ; 10  two traditional variety plantings
                     [2 2 2 2 0 2 2 2 2 0 0 0]  ; 11  two traditional variety plantings
                     [2 2 2 2 0 0 0 2 2 2 2 0]  ; 12  two traditional variety plantings
                     [2 2 2 2 0 0 3 3 3 0 0 0]  ; 13  two multiple variety plantings
                     [2 2 2 2 0 3 3 3 0 0 0 0]  ; 14  two multiple variety plantings
                     [2 2 2 2 0 0 0 3 3 3 0 0]  ; 15  two multiple variety plantings
                     [2 2 2 2 0 0 0 0 3 3 3 0]  ; 16  two multiple variety plantings
                     [3 3 3 0 0 2 2 2 2 0 0 0]  ; 17  two multiple variety plantings
                     [3 3 3 0 0 0 2 2 2 2 0 0]  ; 18  two multiple variety plantings
                     [3 3 3 0 2 2 2 2 0 0 0 0]  ; 19  two multiple variety plantings
                     [3 3 3 0 0 0 0 2 2 2 2 0]  ; 20  two multiple variety plantings
                    ]

  ;; These seem to be used only during initialization, in order to approximate how much water has
  ;; already been used to grow a particular crop at the moment (month) when the simulation begins.
  ;;
  ;;                % of needed water gotten by month sd at tick 1   crop plan number (SCC in subak)
  set all-ricestageplans [
                          [0 0.33 0.67 0 0 0.33 0.67 0 0 0.33 0.67 0]      ; 0
                          [0 0.33 0.67 0 0 0 0 0.33 0.67 0 0 0]            ; 1
                          [0 0.33 0.67 0 0 0.33 0.67 0 0 0 0 0]            ; 2
                          [0 0.33 0.67 0 0 0 0.33 0.67 0 0 0 0]            ; 3
                          [0 0.33 0.67 0 0 0 0 0 0.33 0.67 0 0]            ; 4
                          [0 0.33 0.67 0 0 0 0 0 0 0.33 0.67 0]            ; 5
                          [0 0.16 0.33 0.5 0.67 0.84 0 0 0.25 0.5 0.75 0]  ; 6
                          [0 0.16 0.33 0.5 0.67 0.84 0 0 0.33 0.67 0 0]    ; 7
                          [0 0.16 0.33 0.5 0.67 0.84 0 0 0 0.33 0.67 0]    ; 8
                          [0 0.16 0.33 0.5 0.67 0.84 0 0 0 0 0 0]          ; 9
                          [0 0.25 0.5 0.75 0 0 0 0.25 0.5 0.75 0 0]        ; 10
                          [0 0.25 0.5 0.75 0 0 0.25 0.5 0.75 0 0 0]        ; 11
                          [0 0.25 0.5 0.75 0 0 0 0 0.25 0.5 0.75 0]        ; 12
                          [0 0.25 0.5 0.75 0 0 0 0.33 0.67 0 0 0]          ; 13
                          [0 0.25 0.5 0.75 0 0 0.33 0.67 0 0 0 0]          ; 14
                          [0 0.25 0.5 0.75 0 0 0 0 0.33 0.67 0 0]          ; 15
                          [0 0.25 0.5 0.75 0 0 0 0 0 0.33 0.67 0]          ; 16
                          [0 0.33 0.67 0 0 0 0.25 0.5 0.75 0 0 0]          ; 17
                          [0 0.33 0.67 0 0 0 0 0.25 0.5 0.75 0 0]          ; 18
                          [0 0.33 0.67 0 0 0.25 0.5 0.75 0 0 0 0]          ; 19
                          [0 0.33 0.67 0 0 0 0 0 0.25 0.5 0.75 0]          ; 20
                         ]
  
  set cropplans filter-plans all-cropplans
  set ricestageplans filter-plans all-ricestageplans
  
  if shuffle-cropplans? [shuffle-cropplans] ; see whether reordering cropplans affects outcomes
  
  ;set-current-plot "crop plan distribution"
  ;set-histogram-num-bars (length cropplans) ; will apply to whatever is the first histogram
  
  list-cropplans

  set devtime [0 6 4 3] ; development time for crops. first one is no-crop, i.e. fallow.  the rest are for the three varieties of rice.
  set yldmax [0 5 5 10] ; maximum yld of rice crops
  set pestsens [0 0.5 0.75 1.0] ; sensitivity of crops to pests
  
  ;; There are 5 elements next, 4 above.  Maybe above is fallow + 3 rice varieties, and this includes also vegetable?
  ;; Or above is vegetable plus rice, and we have fallow here as well?
  ;; Maybe the fifth entries are for the vegetable, since the values are so different.  (?)
  
  ;; The middle 3 values in the next line will be ignored: They're about to be replaced by a value from a slider:
  set growthrates [0.1 2.2 2.2 2.2 0.33] ; monthly pest growth rate parameter. cf. Janssen 2006 pp. 173, 177, 178.  Rice values usually between 2.0 and 2.4 per Janssen 2006 pp. 173, 180
  set growthrates replace-item 1 growthrates pestgrowth-rate  ; i.e. replace the second element in growthrates with value of the pestgrowth-rate slider
  set growthrates replace-item 2 growthrates pestgrowth-rate  ; i.e. replace the third element ...
  set growthrates replace-item 3 growthrates pestgrowth-rate  ; etc.
  
  set cropuse [0 0.015 0.015 0.015 0.003]  ; use of water per crop parameter. i.e. fallow uses no water, rice use is 0.015, and paliwiga use is 0.003.
  
  set month 0  ; actual month in this year starts with zero
  set totpestloss 0       ; reported in the Pestloss plot
  set totpestlossarea 0
  set totWS 0             ; reported in the Waterstress plot
  set totWSarea 0
  set avgharvestha 0      ; average harvest per hectare (?)
  set ET 50 / 30000  ;between 40 and 60 Evapotranspiration rate, mm/mon => m/d
  set RRT ET + 50 / 30000 ;between 0 and 100 Rain-Runoff threshold for 1:1, mm/mon => m/d
  set LRS 1 - ET / RRT  ;LowRainSlope, below threshold for RR relation
  set Xf 1.0 ;between 0.8 and 1.2 X factor for changing minimum groundwater flow
  
  load-data

  ask subaks [set size 0.75]
  ask subaks [set old? false]
  set dams_array sort-by [[who] of ?1 < [who] of ?2] dams      ; overwrites filling of dams_array in load-data
  set subaks_array sort-by [[who] of ?1 < [who] of ?2] subaks  ; overwrites filling of subaks_array in load-data

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
    ;set SCC random nrcropplans  ; Note: OVERWRITTEN A FEW LINES DOWN (why?)
    ;set sd random 12            ; Note: OVERWRITTEN A FEW LINES DOWN (why?)
    ;cropplan SCC sd             ; set subak's current crop. Note: OVERWRITTEN A FEW LINES DOWN (why?)
                                 ; and why don't we call ricestageplan here as well?
    set totharvestarea 0
    ;if Color_subaks = "cropping plans"         ; NOTE that since the crop plan is changed in a moment, this coloring will be inaccurate
    ;   [display-cropping-plans] ; new version  ; so I'm going to add in this coloring code below -MA
    ;   ;[set color SCC * 6 + sd] ; original Janssen version

  ]

  ask dams [set flow0 flow0 * Xf * 86400]
  ask dams [set EWS WSarea - areadam]
  ; Effective Watershed Area EWS of each dam is reduced by cultiv'n area areadam because rain onto sowa
  ; enters the irrig'n system meeting immediate demand directly or passing on to the downstream irrigation point

  let global-sd random 12 ; used only if global-startmonth switch is on

  ; maybe init mip var here to zero, which it has by default anyway
  ask subaks [
    ;let sdhelp 0
    set SCC random (length cropplans) ; Note: OVERWRITES VALUE A FEW LINES ABOVE (why?)
    
    if-else global-startmonth
      [set sd global-sd]       ; experiment: what happens when all share same start month?
      [set sd random 12]       ; normal behavior. Note: OVERWRITES VALUE A FEW LINES ABOVE (why?)

    set pests 0.01
    set old? false
    cropplan SCC sd            ; Note: OVERWRITES VALUE A FEW LINES ABOVE (why?). Note we use sd here since initially, mip = sd. In go we use mip.
    ricestageplan SCC sd
    if Color_subaks = "cropping plans"  ; added by Marshall. changes apparently irrelevant coloring above.
       [display-cropping-plan] 
    let subak1 self
    ask subaks [
      if [source] of self = [source] of subak1                   ; if subak1 and I get water from the same dam (source)
        [ask subak1 [set damneighbors lput myself damneighbors]] ; changed "self" to "myself" 10/26/2014, which appears intended, rather than collecting instances of the same subak -MA
    ]
  ]

  
  reset-ticks
end
;;;;;;;;;;;;;;; end of setup


;;;;;;;;;;;;;;;
to go
  ;let gr2 0  ; UNUSED?
  ;let gr3 0  ; UNUSED?
  ;set gr2 pestgrowth-rate ; UNUSED?
  ;set gr3 pestgrowth-rate ; UNUSED?
  
  if-else viewdamsubaks [
    ask damsubaks [set size distanceab]
    ask subakdams [set size distanceab]
  ][
    ask damsubaks [set size 0]
    ask subakdams [set size 0]
  ]
  
  ;; UPDATE INTERNAL SUBAK GROWING/PLANTING MONTH (actual month offset by start month sd)
  ask subaks [
    set mip sd + month
    if mip > 11 [set mip mip - 12] ; sd is start month. this line increments subak's internal growing month month. (month is inc'ed below.
  ]
  
  ask subaks [
    cropplan SCC mip ; note we use mip, not sd.  sd is start month.  mip is subak's internal month in the cycle.
    if stillgrowing [if ((crop = 0) or (crop = 4)) [set stillgrowing false]]
  ]
  
  ;; CORE AGRICULTURAL PROCESSES: water use, grow rice, pests, harvest amount:
  demandwater
  determineflow
  growrice
  growpest
  determineharvest

  ; at end of year, plot summary data on harvest, pests, and water stress
  if month = 11 [
    set totpestloss totpestloss / totpestlossarea ; average loss due to pests
    set totWS totWS / totWSarea                   ; average water stress
    plot-figs
  ]

  ;; CULTURAL TRANSMISSION
  if month = 11 [imitatebestneighbors]

  ;; simple method for introducing noise (temporary)
  ;ask subaks [if random-float 1 > 0.5 [set SCC random 21 set sd random 12]]

  ; at end of year, set month back to 0 and empty all summary variables that collect info over the year
  ; (worry: do any of these variables affect operation? does zeroing them bias the process? -MA)
  ifelse month = 11 
    [set month 0
     set totWSarea 0 
     set totWS 0 
     ask subaks [
       set pyharvest 0 
       set pyharvestha 0 
       set totpestloss 0 
       set totpestlossarea 0 
       set totharvestarea 0 
       set pests 0.01]]
    [set month month + 1]

  tick
end
;;;;;;;;;;;;;;; end of go



to-report filter-plans [plans]
  if not is-list? cropplan-bools [error (word "croppplan-bools has value: " cropplan-bools)]
  if cropplan-bools = 0 [error (word "croppplan-bools has value: " cropplan-bools)]
    
  report filter-plans-helper plans cropplan-bools
end

to-report filter-plans-helper [plans bools]
  if-else (empty? bools)
    [report []]
    [if-else (first bools)
      [report (fput (first plans)
                    (filter-plans-helper (but-first plans)
                                         (but-first bools)))]
      [report (filter-plans-helper (but-first plans)
                                   (but-first bools))]]
end

;; shuffle globals cropplans and ricestageplans, preserving their correspondence
to shuffle-cropplans
  let shuffled-ints shuffle (pos-ints (length cropplans))
  set cropplans reorder-by shuffled-ints cropplans
  set ricestageplans reorder-by shuffled-ints ricestageplans
end

;; list allowable cropplans in the output window
to list-cropplans
  let i 0
  foreach cropplans
    [if (i < 10)
       [output-type " "]
     output-type (word i ": ")
     output-print ?
     set i i + 1]
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
      ]
    ]
;       		Demand for each Subak based on cropping pattern, less any rainfall.
;        		dmd may be + or - because local rain can exceed demand ==> an excess.

  ask subaks [
;    		cropuse is m/d demand for the 4 crops:
    if Color_subaks = "crops" [
      ask patch-here [set pcolor default-pcolor]
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
          if (count damdam with [a = self and b = dam1] + count damdam with [a = dam1 and b = self]) > 0 [
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
    set WSS [WSD] of [a] of one-of damsubaks with [b = subak1] ; Uh, this worries me.  Why a vs. b?  It's unidirectional. Oh, because water goes downhill? -MA
    set dmd dmd * WSS]
end

;; This is a subak-local procedure.
;; If this subak is growing rice, then advance its growth states
to growrice
    ask subaks [
      ;let subak1 self   ; UNUSED
      ;let WSDhelp self  ; UNUSED
      if crop = 0 [set ricestage 0 set WSS 1] ; Fallow period -- i.e. not growing anything
      if crop = 4 [set ricestage 0 set WSS 1] ; Growing paliwiga -- i.e. not growing rice
      if ((crop = 1) or (crop = 2) or (crop = 3)) [  ; i.e. 1, 2, and 3 are the rice varieties
        set WSS [WSD] of source 
        set ricestage ricestage + (WSS / (item crop devtime)) ; i.e. advance growing stage as a function of the rice variety and available water?
        ; devtime is a global that stores the growing time of the three rice varieties
 ]]
end

;; cf. ODD in the Info tab, ODD_LansingKremer.pdf p. 3, Janssen 2006 p. 173,
;; and the note below on differences between versions of this function.
;; non-local vars used:
;;   subak-local: pests, pestneighbors, crop
;;   globals: growthrates
;;   UI-defined: pestdispersal-rate
;; Notes:
;; Inner ask subaks implement the equation on p. 173 of Janssen 2006
;; without its assumption that there are exactly 4 neighbors.
;;
;; Janssen 2006 p. 173 eq. (1) correspondences:
;;  NetLogo                        2006
;; (item crop growthrates)        g(x_j)
;; pests                          p_j,t
;; pestdisperal-rate * dt / dxx   d       [p. 173 says eq. (1) is for monthly timesteps]
;; cs                             p_n1,j,t + p_n2,j,t + p_n3,j,t + p_n4,j,t - 4p_j,t
;;
;;   [note: The "- 4p_j,t" in eq. (1) in Janssen 2006 is needed because in that equation, the 
;;    comparison is with 4 neighbors.  In the NetLogo version, the number of neighbors varies from
;;    0 to 4, and subtracting the current subak's pest count (p_j,t or pests) is done in the inner
;;    ask subaks used to calculate cs.]
;;
to growpest
  let dxx 100           ; i.e. dx as in "dt/dx" in the ODD. causes pestdispersal-rate to be treated as a percentage. ("dx" is the name of a built-in function in NetLogo.)
  let dt 30             ; days (i.e. per month. this is why the ODD makes dx/dt = 0.3)
  let minimumpests 0.01 ; clamp lower values of pests to this number
  
  ask subaks [
    let subak1 self
    let newpests 0        ; temp var: next-tick value for subak's pests
    let sumpestdif 0      ; holds a sum of diffs with other subaks' pests (formerly cs)
    let dc 0              ; intermediate var in calc of newpests

    ask subaks [  ; for each neighbor, sum diff tween its pests and my pests into sumpestdif:
      let pestdif 0         ; temp var for diff with another subak's pests (formerly cN)
      ifelse member? subak1 pestneighbors   ; CONSIDER SIMPLIFYING by making pestneighbors into an agentset.
        [set pestdif pests - [pests] of subak1]
        [set pestdif 0]
      set sumpestdif sumpestdif + pestdif]

    set dc (pestdispersal-rate / dxx) * sumpestdif * dt ; this is the net change in pest dispersed to or from the subak.
    set newpests ((item crop growthrates) * (pests + 0.5 * dc)) + (0.5 * dc)	; Janssen 2006 doesn't explain why 0.5.

    if newpests < minimumpests
      [set newpests minimumpests]
    
    set pests newpests

    if Color_subaks = "pests" [
      ask patch-here [set pcolor default-pcolor]
      set color 62 + pests
    ]
  ] ; outer ask
end


;; NOTE on difference between new Abrams version growpest and older versions:
;; note that in the old versions,
;; cs = 4*pests + sum(cN) over pestneighbors
;; so cs - 4*pests = sum(cN) over pestneighbors
;; so we can just take the 4*pests out of cs, and then don't subtract 4*pests from it in calculating dc.
;; (I think the 4*pests may have been mistakenly derived from Janssen 2006 p. 173,
;; but the mistake was neutralized, and didn't affect outcomes.)
;; Also, in the version above I renamed cs to sumpestdif, which is clearer and fits what's written in Janssen's ODDs.


;; ORIGINAL JANSSEN VERSION of growpest (except that I renamed growthrate to growthrates -M)
;; Janssen 2006 p. 173 eq. (1) correspondences:
;;  NetLogo                        2006
;; (item crop growthrates)        g(x_j)
;; pests                          p_j,t
;; pestdisperal-rate * dt / dxx   d       [p. 173 says eq. (1) is for monthly timesteps]
;; cs                             p_n1,j,t + p_n2,j,t + p_n3,j,t + p_n4,j,t - 4p_j,t
;;
;;   [note: The "- 4p_j,t" in eq. (1) is needed because in that equation, the comparison is
;;    with 4 neighbors.  In the NetLogo version, the number of neighbors varies from 0 to 4,
;;    and subtracting the current subak's pest count (p_j,t or pests) is done in the inner
;;    ask subaks used to calculate cs.  Here the "- (4 * pests)" merely undoes the addition
;;    this value in the initial value given to cs in the outer ask subaks.  (However, it might
;;    affect numerical rounding.)]
;to growpest-janssen
;  let dxx 100
;  let dt 30 ;days [<-- Janssen's comment]
;  let dc 0
;  let cs 0
;  let cN 0
;  let minimumpests 0.01
;  ask subaks [
;    let subak1 self
;    set cs 4 * pests
;    ask subaks [
;        let subak2 self
;        ifelse member? subak1 pestneighbors [set cN pests - [pests] of subak1][set cN 0]
;        set cs cs + cN]
;    set dc (pestdispersal-rate / dxx) * ( cs - (4 * pests)) * dt ; this is the net change in pest dispersed to or from the subak
;    set dpests ((item crop growthrates) * (pests + 0.5 * dc)) + (0.5 * dc)  
;    if dpests < minimumpests [set dpests minimumpests]]
;    
;    ask subaks [set pests dpests if Color_subaks = "pests" [set color 62 + pests ]]
;end

;; version of guts of growpest based on Janssen's version, but slightly modified to make it into a function/reporter.
;; designed to be run within an ask subak block.  To test this function, add
;;     show dpests - (growpest-janssen-fn self)]
;; at the end of the outer ask subaks block.
;to-report growpest-janssen-fn [subk]
;  let dxx 100
;  let dt 30 ;days
;  let dc 0
;  let cs 0
;  let cN 0
;  let minimumpests 0.01
;  let local-dpests 0
;;  ask subaks [
;    let subak1 self
;    set cs 4 * pests
;    ask subaks [
;        let subak2 self
;        ifelse member? subak1 pestneighbors [set cN pests - [pests] of subak1][set cN 0]
;        set cs cs + cN]
;    set dc (pestdispersal-rate / dxx) * ( cs - (4 * pests)) * dt ; this is the net change in pest dispersed to or from the subak
;    set local-dpests ((item crop growthrates) * (pests + 0.5 * dc)) + (0.5 * dc)  
;    if local-dpests < minimumpests [set local-dpests minimumpests]
;;  ]
;  
;  report local-dpests
;;  ask subaks [set pests dpests if Color_subaks = "pests" [set color 62 + pests ]]
;end

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
        if (cropf = 0) or (cropf = 4) [
          set Ymax ricestage * (item crop yldmax)            ; scale max growth per hectare by fraction of needed water already received (?)
          set pest-damage 1 - pests * (item crop pestsens)
          if pest-damage < 0 [set pest-damage 0]
          set harvest Ymax * pest-damage                     ; compute harvest per hectare from max growth scaled by pest damage (?)
	  set pestloss pestloss + Ymax * (1 - pest-damage) * area
	  set totLoss totLoss + pestloss
	  set hy hy + harvest * area                         ; harvest for entire area (area is a subak variable) (?)
	  set pyharvest pyharvest + harvest * area           ; add this month's total harvest onto total for year to date (?)
	  set pyharvestha pyharvestha + harvest              ; add harvest per hectare onto per hectare for ytd
	  set totpestloss totpestloss + area * (1 - pest-damage) * Ymax
          set totpestlossarea totpestlossarea + area
          set totWS totWS + (1 - ricestage) * area           ; waterstress is percentage of needed water not yet received, times area (?) [Q: How does water flow affect this?]
          set totWSarea totWSarea + area                     ; won't this just be 12 * area at the end of 12 months??
          set totharvestarea totharvestarea + area           ; won't this be the same?
        ] ; if
    ] ; ask
end

;; A top-level procedure, not an in-subak procedure.
to imitatebestneighbors
  let minharvest 0
  let maxharvest 0
  ask subaks [
    ;show (word "subak month = " mip ", crop = " crop ", cropplan: " SCC " " (item SCC cropplans))

    if (crop = 1 or crop = 2 or crop = 3 or (imitate-when-fallow and crop = 0)) [ ; only those growing rice at the moment will imitiate.  
      let bestneighbor self  ; until I learn of someone better, I'll consider myself to be my best "neighbor".
      set minharvest pyharvestha ; set minharvest to my total harvest for the year
      set maxharvest minharvest  ; set maxharvest to my total harvest for the year

      ;; Do this here rather than in the foreach, as in earlier version, so that it also happens to subaks who are nobody's neighbors:
      set SCCc SCC ; store my current cropplan in temporary copy
      set sdc sd   ; store my current start month in temporary copy
	
      foreach pestneighbors [
	      ask ? [
	        if pyharvestha > maxharvest [ ; if your total harvest for the year is more than anyone else's so far. (note pyharvestha here is the *neighbor*'s var)
               set maxharvest pyharvestha  ; then my new max so far will be that value (maxharvest is a local outside of all subaks that we're using temporarily here)
               set bestneighbor self       ; and you will be my best neighbor so far (bestneighbor is local defined within the outer ask)
	        ]
        ]

        if maxharvest > minharvest [  ; if I found a neighbor who did better than I did
          ;show (word "found better - mine: " ([SCC] of asker) ":" ([sd] of asker) ", neighbor's: " ([SCC] of ?) ":" ([sd] of ?))
          set SCCc [SCC] of bestneighbor ; copy its cropping plan
          set sdc [sd] of bestneighbor   ; and its start month
	      ] ; removed 'else' that was here; it's now done by default before the foreach
      ] ; foreach
    ] ; if
  ] ; ask

  ; now, in each subak move its temporary copied values to its own operational variables, and update the UI if necessary
  ask subaks [
     set SCC SCCc
     set sd sdc
     if Color_subaks = "cropping plans" [
       display-cropping-plan ; new version ; original version: set color SCC * 6 + sd
     ]
  ]
end

;; VERSION PRIOR TO MERGING THE TWO OUTER ASKS TO CORRECT TREATMENT OF PEST-ISOLATED SUBAKS:
;;; A top-level procedure, not an in-subak procedure.
;to imitatebestneighbors
;  let minharvest 0
;  let maxharvest 0
;  ask subaks [
;     let asker self
;     ;show (word "subak month = " mip ", crop = " crop ", cropplan: " SCC " " (item SCC cropplans))
;     
;     ;; THIS SEEMS WRONG. WHY CAN'T I IMITATE DURING A FALLOW PERIOD?:
;     ;; This means that 
;     ;; (a) subaks with cropplans with more fallow periods examine neighbors to see if they're better less often.
;     ;; (b) subaks with sd = 0 never imitate, since this procedure is only called when month = 11, so mip = 0 + 11 = 11.  Every cropplan has crop = 0 in month 11.
;     if (crop = 1 or crop = 2 or crop = 3 or (imitate-when-fallow and crop = 0)) ; only those growing rice at the moment will imitiate.  
;        [
;         ;show "imitating ..."
;         ;ifmip = 11 [show "imititating while in month 11!"] ; this should never fire, because the final month, 11, is always fallow, i.e. crop = 0.  Yet it does fire, sometimes.
;         let bestneighbor self  ; until I learn of someone better, I'll consider myself to be my best "neighbor".
;         set minharvest pyharvestha ; set minharvest to my total harvest for the year
;         set maxharvest minharvest  ; set maxharvest to my total harvest for the year
;         foreach pestneighbors
;            [ask ?
;               [if pyharvestha > maxharvest    ; if your total harvest for the year is more than anyone else's so far. (note pyharvestha here is the *neighbor*'s var)
;                  [set maxharvest pyharvestha  ; then my new max so far will be that value (maxharvest is a local outside of all subaks that we're using temporarily here)
;                   set bestneighbor self]]     ; and you will be my best neighbor so far (bestneighbor is local defined within the outer ask)
;               ifelse maxharvest > minharvest    ; if I found a neighbor who did better than I did
;                 [;show (word "found better - mine: " ([SCC] of asker) ":" ([sd] of asker) ", neighbor's: " ([SCC] of ?) ":" ([sd] of ?))
;                  set SCCc [SCC] of bestneighbor ; copy its cropping plan
;                  set sdc [sd] of bestneighbor]  ; and its start month
;                 [set SCCc SCC                   ; otherwise "copy" my own old values
;                  set sdc sd]]
;            ]
;  ]
;
;  ; now, in each subak move its temporary copied values to its own operational variables, and update the UI if necessary
;  ask subaks [
;     set SCC SCCc
;     set sd sdc
;     if Color_subaks = "cropping plans" [
;       display-cropping-plans ; new version
;       ;set color SCC * 6 + sd  ; original Janssen version
;     ]
;  ]
;end

;; subak routine
to display-cropping-plan
  let low-scc-base-color 4
  let high-scc-base-color 6
  let sd-base-color 2
  
  if-else SCC < 14
    [set color low-scc-base-color + (10 * SCC)]         ; colors from column low-scc-base-color of swatches
    [set color high-scc-base-color + (10 * (SCC - 14))]  ; colors from column high-scc-base-color of swatches
  
  ask patch-here [set pcolor (2 + (([sd] of myself) * 10))]
  
  if-else show-subak-values
    [set label (word "[" SCC ":" sd "]")]
    [set label ""]
end

to-report compute-avg-harvest
  let totarea 0
  let totharvest 0
  ask subaks [
    set totarea totarea + totharvestarea
    set totharvest totharvest + pyharvest
  ]
  if-else totarea = 0
    [report "totarea is 0"]
    [report totharvest / totarea]
end

;to setup-plot
;  set-current-plot "Harvest"
;  set-plot-y-range 0 30
;  set-current-plot "Pestloss"
;  set-plot-y-range 0 1
;  set-current-plot "Waterstress"
;  set-plot-y-range 0 1
;end

to plot-figs
  ;; REPLACE WITH comput-avg-harvest
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
      set subaks_array lput self subaks_array ; will be overwritten in go soon after this is called, but not before being used in its present form below.
      if Color_subaks = "Temple groups" [
        ask patch-here [set pcolor default-pcolor]
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

  foreach dam-data [
    create-dams 1 [ 
      set color yellow
      ;; we skip the 0th element 
      setxy (item 1 ?) (item 2 ?) 
      set flow0 item 3 ? 
      set elevation item 4 ? 
      set WSarea item 5 ? 
      set damht item 6 ?
      set dams_array lput self dams_array ; will be overwritten in go soon after this is called, but not before being used in its present form below.
  ]]

  linkdams

  ;; here we use the versions of subaks_array and dams_array created in the present procedure load-data.  After it's run, these vars will be filled again.
  foreach subaksubak-data [make-subaksubak (item first ? subaks_array) (item last ? subaks_array)]
  foreach subakdam-data [make-subakdams (item first ? subaks_array) (item (item 1 ?) dams_array) (item last ? dams_array)]

end

;; Procedure to set current subak's crop from a cropping plan and month
;; A subak-local procedure: Must be called from within ask subaks [...].  References subaks-own variables.
;; For each month a crop is defined:
;; Based on procedure growrice, it appears that 0 represents a fallow period, and 1, 2, & 3 represent rice varieties,
;; and 4 reps an alternate non-rice crop.  Note none of these crop plans includes that crop.
;; It appears that variety 1 requires 6 months to grow, variety 2 requires 4 months to grow, and variety 3 requires 3 months to grow.
;; That's why not all possible combinations of 0's, 1's, 2's, and 3's are included.
to cropplan [plan-number mnth]
  set crop item (mnth mod 12) (item plan-number cropplans)
end

; old version of cropplan:
;to cropplan [nr m]          ; cropping plan number, month number (zero-based)
;  if m > 11 [set m m - 12]
;	let cropplan-a [3 3 3 0 3 3 3 0 3 3 3 0]
;	let cropplan-b [3 3 3 0 0 0 3 3 3 0 0 0]
;	let cropplan-c [3 3 3 0 3 3 3 0 0 0 0 0]
;	let cropplan-d [3 3 3 0 0 3 3 3 0 0 0 0]
;	let cropplan-e [3 3 3 0 0 0 0 3 3 3 0 0]
;	let cropplan-f [3 3 3 0 0 0 0 0 3 3 3 0]
;	let cropplan-g [1 1 1 1 1 1 0 2 2 2 2 0]
;	let cropplan-h [1 1 1 1 1 1 0 3 3 3 0 0]
;	let cropplan-i [1 1 1 1 1 1 0 0 3 3 3 0]
;	let cropplan-j [1 1 1 1 1 1 0 0 0 0 0 0]
;	let cropplan-k [2 2 2 2 0 0 2 2 2 2 0 0]
;	let cropplan-l [2 2 2 2 0 2 2 2 2 0 0 0]
;	let cropplan-m [2 2 2 2 0 0 0 2 2 2 2 0]
;	let cropplan-n [2 2 2 2 0 0 3 3 3 0 0 0]
;	let cropplan-o [2 2 2 2 0 3 3 3 0 0 0 0]
;	let cropplan-p [2 2 2 2 0 0 0 3 3 3 0 0]
;	let cropplan-q [2 2 2 2 0 0 0 0 3 3 3 0]	
;	let cropplan-r [3 3 3 0 0 2 2 2 2 0 0 0]
;	let cropplan-s [3 3 3 0 0 0 2 2 2 2 0 0]
;	let cropplan-t [3 3 3 0 2 2 2 2 0 0 0 0]
;	let cropplan-u [3 3 3 0 0 0 0 2 2 2 2 0]
;
;  if nr = 0 [set crop item m cropplan-a]  ; i.e. set this subak's crop var to the crop number at month m in cropping plan nr
;  if nr = 1 [set crop item m cropplan-b]
;  if nr = 2 [set crop item m cropplan-c]
;  if nr = 3 [set crop item m cropplan-d]
;  if nr = 4 [set crop item m cropplan-e]
;  if nr = 5 [set crop item m cropplan-f]
;  if nr = 6 [set crop item m cropplan-g]
;  if nr = 7 [set crop item m cropplan-h]
;  if nr = 8 [set crop item m cropplan-i]
;  if nr = 9 [set crop item m cropplan-j]
;  if nr = 10 [set crop item m cropplan-k]
;  if nr = 11 [set crop item m cropplan-l]
;  if nr = 12 [set crop item m cropplan-m]
;  if nr = 13 [set crop item m cropplan-n]
;  if nr = 14 [set crop item m cropplan-o]
;  if nr = 15 [set crop item m cropplan-p]
;  if nr = 16 [set crop item m cropplan-q]
;  if nr = 17 [set crop item m cropplan-r]
;  if nr = 18 [set crop item m cropplan-s]
;  if nr = 19 [set crop item m cropplan-t]
;  if nr = 20 [set crop item m cropplan-u]
;end

; since only called during setup, and not due to incrementing month, there's no need to modulo the month
to ricestageplan [nr m]
  set ricestage item m (item nr ricestageplans)
end

;old version:
;to ricestageplan [nr m]
;	let ricestageplan0 [0 0.33 0.67 0 0 0.33 0.67 0 0 0.33 0.67 0]
;	let ricestageplan1 [0 0.33 0.67 0 0 0 0 0.33 0.67 0 0 0]
;	let ricestageplan2 [0 0.33 0.67 0 0 0.33 0.67 0 0 0 0 0]
;	let ricestageplan3 [0 0.33 0.67 0 0 0 0.33 0.67 0 0 0 0]
;	let ricestageplan4 [0 0.33 0.67 0 0 0 0 0 0.33 0.67 0 0]
;	let ricestageplan5 [0 0.33 0.67 0 0 0 0 0 0 0.33 0.67 0]
;	let ricestageplan6 [0 0.16 0.33 0.5 0.67 0.84 0 0 0.25 0.5 0.75 0]
;	let ricestageplan7 [0 0.16 0.33 0.5 0.67 0.84 0 0 0.33 0.67 0 0]
;	let ricestageplan8 [0 0.16 0.33 0.5 0.67 0.84 0 0 0 0.33 0.67 0]
;	let ricestageplan9 [0 0.16 0.33 0.5 0.67 0.84 0 0 0 0 0 0]
;	let ricestageplan10 [0 0.25 0.5 0.75 0 0 0 0.25 0.5 0.75 0 0]
;	let ricestageplan11 [0 0.25 0.5 0.75 0 0 0.25 0.5 0.75 0 0 0]
;	let ricestageplan12 [0 0.25 0.5 0.75 0 0 0 0 0.25 0.5 0.75 0]
;	let ricestageplan13 [0 0.25 0.5 0.75 0 0 0 0.33 0.67 0 0 0]
;	let ricestageplan14 [0 0.25 0.5 0.75 0 0 0.33 0.67 0 0 0 0]
;	let ricestageplan15 [0 0.25 0.5 0.75 0 0 0 0 0.33 0.67 0 0]
;	let ricestageplan16 [0 0.25 0.5 0.75 0 0 0 0 0 0.33 0.67 0]	
;	let ricestageplan17 [0 0.33 0.67 0 0 0 0.25 0.5 0.75 0 0 0]
;	let ricestageplan18 [0 0.33 0.67 0 0 0 0 0.25 0.5 0.75 0 0]
;	let ricestageplan19 [0 0.33 0.67 0 0 0.25 0.5 0.75 0 0 0 0]
;	let ricestageplan20 [0 0.33 0.67 0 0 0 0 0 0.25 0.5 0.75 0]
;
;  if nr = 0 [set ricestage item m ricestageplan0]
;  if nr = 1 [set ricestage item m ricestageplan1]
;  if nr = 2 [set ricestage item m ricestageplan2]
;  if nr = 3 [set ricestage item m ricestageplan3]
;  if nr = 4 [set ricestage item m ricestageplan4]
;  if nr = 5 [set ricestage item m ricestageplan5]
;  if nr = 6 [set ricestage item m ricestageplan6]
;  if nr = 7 [set ricestage item m ricestageplan7]
;  if nr = 8 [set ricestage item m ricestageplan8]
;  if nr = 9 [set ricestage item m ricestageplan9]
;  if nr = 10 [set ricestage item m ricestageplan10]
;  if nr = 11 [set ricestage item m ricestageplan11]
;  if nr = 12 [set ricestage item m ricestageplan12]
;  if nr = 13 [set ricestage item m ricestageplan13]
;  if nr = 14 [set ricestage item m ricestageplan14]
;  if nr = 15 [set ricestage item m ricestageplan15]
;  if nr = 16 [set ricestage item m ricestageplan16]
;  if nr = 17 [set ricestage item m ricestageplan17]
;  if nr = 18 [set ricestage item m ricestageplan18]
;  if nr = 19 [set ricestage item m ricestageplan19]
;  if nr = 20 [set ricestage item m ricestageplan20]
;end

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
  ask s1 [set pestneighbors lput s2 pestneighbors] ; Note this makes it a one-way link
end

;; I think:
;; s1: subak
;; s2: dam
;; s3: dam
to make-subakdams [s1 s2 s3]
  create-subakdams 1
  [
    set color pink
    set a s1
    set b s2
    reposition-edges
    if not viewdamsubaks [set size 0]
  ]
    create-damsubaks 1
  [
    set color pink
    set a s3
    set b s1
    reposition-edges
    if not viewdamsubaks [set size 0]
  ]
  ask s1 [
    set source s3 
    set return s2
  ]
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

;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report modal-cropplan
  report modes [SCC] of subaks
end

to-report modal-cropplan-seq
  report item (first modal-cropplan) cropplans ; note we are indexing into the list of cropplans actually used, not the original base list
end

to-report num-with-modal-cropplan
  let mcp first modal-cropplan
  report count subaks with [SCC = mcp]
end

to-report modal-start-month
  report modes [sd] of subaks
end

to-report num-with-modal-month
  let mm first modal-start-month
  report count subaks with [sd = mm]
end

;; convenience functions for UI
to set-cropplans-off
  set cropplan-a false
  set cropplan-b false
  set cropplan-c false
  set cropplan-d false
  set cropplan-e false
  set cropplan-f false
  set cropplan-g false
  set cropplan-h false
  set cropplan-i false
  set cropplan-j false
  set cropplan-k false
  set cropplan-l false
  set cropplan-m false
  set cropplan-n false
  set cropplan-o false
  set cropplan-p false
  set cropplan-q false
  set cropplan-r false
  set cropplan-s false
  set cropplan-t false
  set cropplan-u false
end

to set-cropplans-on
  set cropplan-a true
  set cropplan-b true
  set cropplan-c true
  set cropplan-d true
  set cropplan-e true
  set cropplan-f true
  set cropplan-g true
  set cropplan-h true
  set cropplan-i true
  set cropplan-j true
  set cropplan-k true
  set cropplan-l true
  set cropplan-m true
  set cropplan-n true
  set cropplan-o true
  set cropplan-p true
  set cropplan-q true
  set cropplan-r true
  set cropplan-s true
  set cropplan-t true
  set cropplan-u true
end

;; Turn off crop plans that use the high-yield rice variety (#3); leave on the others.
to traditional-cropplans
  set-cropplans-off
  set cropplan-g true
  set cropplan-j true
  set cropplan-k true
  set cropplan-l true
  set cropplan-m true
end

;;;;;;;;;;;;;;;;;;;;
;; General-purpose utilities


;; generate integers from 0 to n-1
to-report pos-ints [n]
  report pos-ints-aux n []
end

to-report pos-ints-aux [n lst]
  let ndec n - 1
  if-else (n <= 0)
    [report lst]
    [report pos-ints-aux ndec (fput ndec lst)] ; this will handle recursion to at least 50K
end

;; generate a list of values selected from vals in the order given by idxs
to-report reorder-by [idxs vals]
  report map [item ? vals] idxs
end
@#$#@#$#@
GRAPHICS-WINDOW
180
10
800
651
30
-1
10.0
1
8
1
1
1
0
0
0
1
-30
30
-31
29
0
0
1
months
30.0

BUTTON
3
10
66
43
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
3
47
66
80
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
0
233
175
278
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
10.0
0.0
10.0
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
10.0
0.0
1.0
true
false
"" ""
PENS
"totWS" 1.0 0 -13345367 true "" ""

SWITCH
2
283
146
316
viewdamsubaks
viewdamsubaks
1
1
-1000

CHOOSER
0
323
148
368
Color_subaks
Color_subaks
"Temple groups" "cropping plans" "crops" "pests"
1

SWITCH
2
418
178
451
show-subak-values
show-subak-values
1
1
-1000

TEXTBOX
5
375
155
417
If on, display identifiying info on whatever subak colors represent:
11
0.0
1

TEXTBOX
2
455
173
503
Display #s corresp to subak coloring (not yet implemented for all choices)
11
0.0
1

TEXTBOX
4
171
180
237
          Correspondences\npestdispersal-rate    d (Janssen 2006)\n     0.6                       0.18\n     1.0                       0.3\n     1.5                       0.45
8
0.0
1

TEXTBOX
257
653
734
671
Cropping plan colors: circle represents crop plan, square represents start month.
11
0.0
1

SWITCH
4
670
178
703
shuffle-cropplans?
shuffle-cropplans?
1
1
-1000

OUTPUT
1130
24
1366
369
9

SWITCH
1393
16
1513
49
cropplan-a
cropplan-a
1
1
-1000

SWITCH
1393
49
1513
82
cropplan-b
cropplan-b
1
1
-1000

SWITCH
1393
82
1513
115
cropplan-c
cropplan-c
1
1
-1000

SWITCH
1393
115
1513
148
cropplan-d
cropplan-d
1
1
-1000

SWITCH
1393
148
1513
181
cropplan-e
cropplan-e
1
1
-1000

SWITCH
1393
181
1513
214
cropplan-f
cropplan-f
1
1
-1000

SWITCH
1393
214
1513
247
cropplan-g
cropplan-g
0
1
-1000

SWITCH
1393
247
1513
280
cropplan-h
cropplan-h
1
1
-1000

SWITCH
1393
280
1513
313
cropplan-i
cropplan-i
1
1
-1000

SWITCH
1393
313
1513
346
cropplan-j
cropplan-j
0
1
-1000

SWITCH
1393
346
1513
379
cropplan-k
cropplan-k
0
1
-1000

SWITCH
1393
379
1513
412
cropplan-l
cropplan-l
0
1
-1000

SWITCH
1393
412
1513
445
cropplan-m
cropplan-m
0
1
-1000

SWITCH
1393
445
1513
478
cropplan-n
cropplan-n
1
1
-1000

SWITCH
1393
478
1513
511
cropplan-o
cropplan-o
1
1
-1000

SWITCH
1393
511
1513
544
cropplan-p
cropplan-p
1
1
-1000

SWITCH
1393
544
1513
577
cropplan-q
cropplan-q
1
1
-1000

SWITCH
1393
577
1513
610
cropplan-r
cropplan-r
1
1
-1000

SWITCH
1393
610
1513
643
cropplan-s
cropplan-s
1
1
-1000

SWITCH
1393
643
1513
676
cropplan-t
cropplan-t
1
1
-1000

SWITCH
1393
676
1513
709
cropplan-u
cropplan-u
1
1
-1000

MONITOR
1130
371
1224
416
modal cropplan
modal-cropplan
17
1
11

MONITOR
1130
416
1301
461
# subaks with modal cropplan
num-with-modal-cropplan
17
1
11

PLOT
1130
552
1349
699
crop plan distribution
NIL
NIL
0.0
21.0
0.0
175.0
false
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [SCC] of subaks"

MONITOR
1130
460
1257
505
modal start month
modal-start-month
17
1
11

MONITOR
1130
506
1300
551
# subaks with modal month
num-with-modal-month
17
1
11

BUTTON
1305
418
1385
451
cropplans on
set-cropplans-on
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
1305
450
1385
484
cropplans off
set-cropplans-off
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1225
370
1374
415
NIL
modal-cropplan-seq
17
1
11

SWITCH
3
744
180
777
imitate-when-fallow
imitate-when-fallow
0
1
-1000

TEXTBOX
5
782
311
848
Temporary (for comparison of versions of code): Run imidatebestneighbors with (new) and without (old) imitation when the imitating subak is in a fallow period.
11
0.0
1

SWITCH
-1
506
170
539
global-startmonth
global-startmonth
1
1
-1000

TEXTBOX
3
543
153
571
If true, all subaks use same random start month.
11
0.0
1

BUTTON
67
47
126
80
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1519
24
1706
43
[3 3 3 0 3 3 3 0 3 3 3 0]
11
0.0
1

TEXTBOX
1519
57
1706
76
[3 3 3 0 0 0 3 3 3 0 0 0]
11
0.0
1

TEXTBOX
1519
89
1706
108
[3 3 3 0 3 3 3 0 0 0 0 0]
11
0.0
1

TEXTBOX
1519
123
1706
142
[3 3 3 0 0 3 3 3 0 0 0 0]
11
0.0
1

TEXTBOX
1519
156
1706
175
[3 3 3 0 0 0 0 3 3 3 0 0]
11
0.0
1

TEXTBOX
1519
188
1706
207
[3 3 3 0 0 0 0 0 3 3 3 0]
11
0.0
1

TEXTBOX
1519
222
1706
241
[1 1 1 1 1 1 0 2 2 2 2 0]
11
0.0
1

TEXTBOX
1519
255
1706
274
[1 1 1 1 1 1 0 3 3 3 0 0]
11
0.0
1

TEXTBOX
1519
288
1706
307
[1 1 1 1 1 1 0 0 3 3 3 0]
11
0.0
1

TEXTBOX
1519
320
1706
339
[1 1 1 1 1 1 0 0 0 0 0 0]
11
0.0
1

TEXTBOX
1519
354
1706
373
[2 2 2 2 0 0 2 2 2 2 0 0]
11
0.0
1

TEXTBOX
1519
387
1706
406
[2 2 2 2 0 2 2 2 2 0 0 0]
11
0.0
1

TEXTBOX
1519
419
1706
438
[2 2 2 2 0 0 0 2 2 2 2 0]
11
0.0
1

TEXTBOX
1519
453
1706
472
[2 2 2 2 0 0 3 3 3 0 0 0]
11
0.0
1

TEXTBOX
1519
486
1706
505
[2 2 2 2 0 3 3 3 0 0 0 0]
11
0.0
1

TEXTBOX
1519
518
1706
537
[2 2 2 2 0 0 0 3 3 3 0 0]
11
0.0
1

TEXTBOX
1519
552
1706
571
[2 2 2 2 0 0 0 0 3 3 3 0]
11
0.0
1

TEXTBOX
1519
585
1706
604
[3 3 3 0 0 2 2 2 2 0 0 0]
11
0.0
1

TEXTBOX
1519
618
1706
637
[3 3 3 0 0 0 2 2 2 2 0 0]
11
0.0
1

TEXTBOX
1519
650
1706
669
[3 3 3 0 2 2 2 2 0 0 0 0]
11
0.0
1

TEXTBOX
1519
684
1706
703
[3 3 3 0 0 0 0 2 2 2 2 0]
11
0.0
1

TEXTBOX
5
706
310
736
It shouldn't matter whether the cropplan sequence is reordered, but in the past, bugs made it matter.
11
0.0
1

TEXTBOX
4
653
171
673
Testing/experiments:
11
0.0
1

TEXTBOX
257
669
638
687
Crop colors: green: fallow, cyan: rice 1, yellow: rice 2, white: rice 3.
11
0.0
1

TEXTBOX
1133
10
1299
29
crop plans in this run:
11
0.0
1

BUTTON
1306
484
1386
518
trad plans
traditional-cropplans
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
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
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="cropplan-bools">
      <value value="[true false false false false false false false false false false false false false false false false false false false false]"/>
      <value value="[false true false false false false false false false false false false false false false false false false false false false]"/>
      <value value="[false false true false false false false false false false false false false false false false false false false false false]"/>
      <value value="[false false false true false false false false false false false false false false false false false false false false false]"/>
      <value value="[false false false false true false false false false false false false false false false false false false false false false]"/>
      <value value="[false false false false false true false false false false false false false false false false false false false false false]"/>
      <value value="[false false false false false false true false false false false false false false false false false false false false false]"/>
      <value value="[false false false false false false false true false false false false false false false false false false false false false]"/>
      <value value="[false false false false false false false false true false false false false false false false false false false false false]"/>
      <value value="[false false false false false false false false false true false false false false false false false false false false false]"/>
      <value value="[false false false false false false false false false false true false false false false false false false false false false]"/>
      <value value="[false false false false false false false false false false false true false false false false false false false false false]"/>
      <value value="[false false false false false false false false false false false false true false false false false false false false false]"/>
      <value value="[false false false false false false false false false false false false false true false false false false false false false]"/>
      <value value="[false false false false false false false false false false false false false false true false false false false false false]"/>
      <value value="[false false false false false false false false false false false false false false false true false false false false false]"/>
      <value value="[false false false false false false false false false false false false false false false false true false false false false]"/>
      <value value="[false false false false false false false false false false false false false false false false false true false false false]"/>
      <value value="[false false false false false false false false false false false false false false false false false false true false false]"/>
      <value value="[false false false false false false false false false false false false false false false false false false false true false]"/>
      <value value="[false false false false false false false false false false false false false false false false false false false false true]"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-aonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-bonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-conly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-donly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-fonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-gonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-honly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-ionly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-jonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-konly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-lonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-monly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-nonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-oonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-ponly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-qonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-ronly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-sonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-tonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="cropplan-uonly" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="allCropplansNoShuffle" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="allCropplansWithShuffle" repetitions="500" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="240"/>
    <metric>compute-avg-harvest</metric>
    <metric>totpestloss</metric>
    <metric>totWS</metric>
    <metric>modal-cropplan</metric>
    <metric>num-with-modal-cropplan</metric>
    <metric>modal-cropplan-seq</metric>
    <metric>modal-start-month</metric>
    <metric>num-with-modal-month</metric>
    <enumeratedValueSet variable="cropplan-a">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="id_colors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;middle&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shuffle-cropplans?">
      <value value="true"/>
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
