BehSpacePlan2.md
====
## Notes on plans for Behavior Space Feb. 2015

--------------

### Values to track:

* `relig-type` mean and variance (at least).
* Harvest (`avgharvestha`).
* Maybe waterstress (`avgWS`) and pestloss (`avgpestloss`).
* Possibly modal cropplans and months.  Probably not.

--------------

### Options to vary across experiments:

##### Noise and religion options:

1. No noise.
2. Noise with no relig effect.
3. Noise with relig effect and relig tran.

##### Relig tran options:

1. Global tran only.  (poss with multiple probabilities)
2. Pestneighbor tran with global tran.
	1. low-probability global tran.
	2. higher-probability global trans?
3. Pestneighbor tran only?


##### Relig effect function

1. Big shelf: Step-like change from 0 to a 1 near 0.5. Could be a
   literal step function, or e.g.

	`relig-effect-center` = 10, `relig-effect-endpt` = 3.5.  

2. Smaller shelf, with steep but gradual curve starting at around 0.5,
   e.g.

	`relig-effect-center` = 3, `relig-effect-endpt` = 1.35.  
	`relig-effect-center` = 2.70, `relig-effect-endpt` = 1.20.

3. Less steep curve with small corner of a shelf in the upper right,
   e.g.

	`relig-effect-center` = 1.80, `relig-effect-endpt` = 0.30.  

4. Linear, effect = `relig-type`.  Do this literally, or use e.g.

	`relig-effect-center` = 0, `relig-effect-endpt` = -1.15

(For publishable/presentable results it may be preferable to use
literal step and linear functions.)

Summary:

`relig-effect-center` = 10, `relig-effect-endpt` = 3.5   ; big shelf  
`relig-effect-center` = 3, `relig-effect-endpt` = 1.35     ; small shelf  
`relig-effect-center` = 2.70, `relig-effect-endpt` = 1.20   ; small shelf  
`relig-effect-center` = 1.80, `relig-effect-endpt` = 0.30   ; corner  
`relig-effect-center` = 0, `relig-effect-endpt` = -1.15 ; linear  

Note both vars are monotonic in the same direction.

Each variable separately:

`relig-effect-center` = 0  
`relig-effect-center` = 1.80  
`relig-effect-center` = 2.70 or `relig-effect-center` = 3  
`relig-effect-center` = 10  

 `relig-effect-endpt` = -1.15  
 `relig-effect-endpt` = 0.30  
 `relig-effect-endpt` = 1.20 or `relig-effect-endpt` = 1.35  
 `relig-effect-endpt` = 3.5  

-----------

### Options to leave at single values throughout runs, initially

These *could* be varied.

##### Initial state

Initially using only option 1 below, which seems to allow for spread of
relig-type=1, and doesn't require assuming that a distinct process gave
rise to pre-existing clustering of relig-types.

1. Random relig values (**Use this one.**)
2. West watershed set to `relig-type` = 1.
3. East watershed set to `relig-type` = 1.
4. Various numbers of connected subnets set to `relig-type` =1.  
   Or possibly use mascetis for this purpose.  
   (Note that mascetis don't correspond perfectly to subnets:
   	* One masceti (#10) has subaks in both watersheds.
	* The big subnet in the southwest contains several mascetis
	  (10-14), including one that's not fully connected within the 
	  subnet, and including part of the dual-watershed masceti.
	* Smaller subnets are grouped into single mascetis, but that's OK.)

(There's also an option to repeat setting a watershed's or subnet's
`relig-type`s again, later, at specified ticks.)

##### Fixed choices (but see below):

* Use only trad cropplans
* `pestgrowth-rate` = 2.4, `pestdispersal-rate` = 1.5,
   `rainfall-scenario` = high.
* `relig-tran-stddev` = 0.02.
* `relig-influence` = 1.50.

##### Things to possibly vary, though:

1. relig-tran-stddev
2. `relig-influence` = 1.50.
3. Pest growth and dispersal, rainfall params.
