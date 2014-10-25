Notes on experiments with Bali sim
====

Fixing the crop pattern `SCC` and the start month `sd` at the first
ones, SCC=0, sd=0, i.e. everyone does the same thing--but the same
thing that is what most subaks do in the normal config-- produces
higher yields, less waterstree (zero!), and less pestloss.
This is *not* a good model of what Lansing's talking about, in *this*
configuration.

If I change config to max pest growth and dispersal allowed by the UI,
and min water allowed by it, I still get a good outcome with no
waterstress, though the yield is a little bit less.

Need to experiment with other startmonths.  This behavior is a little
bit different, based on trying it with sd=5.  It looks like the
unconnected subaks always just stay at sd=0.

Pattern SSC=0 is the only one that allows three plantings per year.
It's a 3-month rice variety with a one month fallow after every harvest.
Other plans with the 3-month rice variety have longer fallow periods, and the
other varieties which are 4- and 6-month rice varieties--i.e. minimum
of 5 and 7 months with a fallow period--don't allow more than two
crops per year.

More interesting results can be found e.g. by excluding the first 6
(3-month variety only) patterns.  Then you really do end up with a
mixture.  The yield isn't anywhere near as high, but it does go up
before plateauing, the pestloss does plateau, and the waterstress does
go down to a low level.

--------------------------------

Single-crop runs do *not* seem to fix mainly on start month = 0.
(But need to check the beh space output data files.)

But in general when I run with multiple cropplans, it seems as if it
does fix on month = 0.  Maybe this is because *the last month is the
only one that's always fallow in every crop plan*.  So it's never bad to
start your plan on the first month, because then you'll share at least
one fallow month with any possible neighbor.

MAYBE I fixed this by allowing imitation when fallow, which was
previously prevented, which seems wrong.

--------------------------------
