Notes on overall architecture and strategy (ArchitectureNotes1.md)
====

Lansing-Kremer model supposedly almost always achieves a pretty good
water coordination pattern, that more or less maximizes crop output
given water needs and pests.  There is a
copy-the-most-successful-neighbor cultural transmission strategy (cf.
J.M. Alexander) that's at the core of the model.  Use [Marco Jannsen's
NetLogo version of their
model](http://www.openabm.org/model/2221/version/2/view) as a starting
point.


0. Verify that in Jannsen's model, close to optimal patterns are in
fact achieved.


1. Add randomizing factor (parameterized) such that a subak doesn't
always copy the best neighboring subak.  This represents greed and other
messiness in within-Subak politics.  Perhaps this scheme can be biased
so that it favors what looks like short-term advantage.  e.g.  it also
tries for more water more of the time, or something like that.

 (Does this really make sense?)

 Experiment with this parameter and (try to) show that the system
breaks down with this condition: It doesn't achieve the relatively
optimal patterns.  It would be nice if the system is pretty sensitive to
such noise--i.e. it gets very bad pretty easily.  But we'll have to
experiment to see what will cause it to break down to what degree.

2. Add a separate cultural transmission channel for a "religious"
cultural variant that could either be Boolean or something more finer
grained, but nothing more complex than a real number.  This also follows
a copy-successful-neighbor pattern, where the success measure is the
same as for the water pattern copying, but where the choice to copy the
religious cultvar is independent of the choice to copy the water
coordination cultvar--i.e. there is a separate random factor.

 Note that the randomization of copying has to be there, and has to be
distinct for the two cultvar channels; otherwise pairs of
water/religious cultvar will simply be copied and preserved together.


3. The religious cultvar also has this effect: For some of its values,
the randomization of the copy-successful factor is damped down.  i.e.
for some values of the religious cultvar, the probability of not
copying the most successful neighbor is lower.  Maybe this goes for
both cultvar channels.


4. A separate simulation would, instead of having
single-dimensional cultvars in the second, religious channel, sends
that work off to popco, where there is a more complex cultural
transmission process.  In this case, it's only when there is a good
analogy between bels representing water management stuff and bels
representing religious stuff (analogies yet to be determined!) that the
greed/fussing/rivalries/etc. noise is damped down.

 So in the first simulation, try to write the religious cultvar
transmission code so that it's hidden behind functions that can
instead be made to call out to popco (by making popco a NetLogo
extension).  Not sure if this fully makes sense.
