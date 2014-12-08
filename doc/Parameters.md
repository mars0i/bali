notes on parameters
====

---

See README.md in the root dir of this repository for citation
information.

---

Janssen (2006) p. 180 says that the 1993 Lansing-Kremer model used
these parameters:

	pest growth rates: 2, 2.2, 2.4

	pest disperal rates: 0.18-0.45, with 0.3 used in some of
	Janssen's experiments.

Similar claims are made on pp. 173, 177, 178.

Janssen also claims that pest growth rate 2.14 is a cutoff; below this
value pests don't grow exponentially; above it they do.

The pest "dispersal rate" in Janssen 2006 seems to be the parameter *d*
in equations (1) on p. 173 and (2a,b) on p. 177.  p. 173 says that this
is per-month dispersal rate.  In Janssen's v2 NetLogo model Bali3.nlogo,
the value corresponding to *d* is:

`pestdisperal-rate * dt / dxx`

where `dxx` is fixed at 100, and `dt` is fixed at 30, representing 30
days (per comment in source code).  Matching up the article's and
NetLogo models' uses, that means that

*d* = `pestdispersal-rate * dt / dxx` = `pestdispersal-rate * 0.3`

or

`pestdispersal-rate` = *d* / 0.3

So When Janssen 2006 says that dispersal rates range from 0.18 to 0.45,
that means that `pestdispersal-rate` should range from 0.18/0.3 to
0.45/0.3, i.e. from 0.6 to 1.5, with the *d*=0.3 value highlighted in
the text equivalent to `pestdispersal-rate`=1.0.  This is in fact
exactly the way that Janssen set up the `pestdispersal-rate` slider in
the NetLogo model.

-------

A good set of parameters for demonstrating the effect of religious
values in the NetLogo-only model as of 12/8/2014 (in which religious
damping of noise is done by multiplication):

	pestgrowth-rate: 2.4 (the max)
	pestdispersal-rate: 1.5 (the max)
	rainfall-scenario: middle
	prob-ignore-neighboring-plans: 0 initially, then 0.5
	spiritual-tran-stddev 0.02
	all cropplans available

This works--you can see the effect of changing
`prob-ignore-neighboring-plans` from 0 to 0.5, and you can see the
effect in the latter case of turning on
`spiritual-influence?`--despite the prescence of the 3-planting
high-yield cropplan.
