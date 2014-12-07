Options for config of "religious" cultural transmisison channel
====

Re who should communicate with whom, how often, how reliably, etc.

See also ArchitectureNotes*.md.

In the NetLogo-only models, I'm modeling the religious value as a
float, e.g. between 0 and 1.  This makes it easy to apply it as a
noise-suppressor.


## Mutation

I. An option is to include "mutation", i.e. random modification of the
religious float.  This is valuable because otherwise variation in the
available float values present in the population is quickly lost due to
copying, so that selection for higher values becomes difficult.

##### Options (examples):

1. Add a small random value, probably Normally distributed, to the
   existing value (e.g. during transmission).  This then is a
   transmission error.

2. Transmit or change to a completely random value, with the same
   distribution as during initialization.  This would represent
   influence from outside the system.

3. Periodically introduce extremal values.  This would probably have
   to be combined with #1.  This again would represent influence from
   outside the system.


## Transmission network

Network options might be configurable, at least in part, via the UI.

##### Options (examples):

1. Learn from best pestneighbor.  The problem with this is that you
   only have access to what's in your local subnet.  It might be OK if
   combined with mutation, though.  Seems unnatural, though.

2. Learn from best subak globally.  This can easily erode variation,
   and by chance can fix on a suboptimal value, so it must be combined
   with one of the mutation options.

3. Learn from those connected to the same dam, both upstream and
   downstream.  I think this is in the subak variable damneighbors.
   Note that there is much less isolation along this network.  There
   are two distinct watersheds that are not connected, but within each
   watershed, there are no isolated nets.

4. Some (configurable) mixture of the above options.  e.g. mostly with
   pestneighbors, but globally with a small probability.  Or best from
   some maximum number of the set in question.

Note that adding in gross mutation in the sense of #2 or #3 above is
very roughly like also learning from outside the system.


## Transmission interval

Cropplans are transmitted every month.  How often should religous
values be transmitted?  It's plausible that radical change would not
happen at a per-month rate, and that cropplan copying might be a
little more flexible.

However, if you don't allow radical change--e.g. if my new religious
value is some combination of my old with what's transmitted--i.e. I am
interested in copying, but I'm conservative--then per-month
transmission could be OK.  Maybe use an update algorithm like the one
I use in CultranDejanet??

(On the other hand note that when I combine Netlogo with popco, there
will be multiple proposition activations mapping one scalar degree of
religous values, so there should probably be multiple popco transmission
ticks per NetLogo religious transmission event.)

##### Options (examples):

1. Transmit every month.
2. Transmit every year.
3. Transmit every longer interval.
