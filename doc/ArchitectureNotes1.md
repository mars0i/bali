Notes on overall architecture & strategy 1
====

Lansing-Kremer model supposedly almost always achieves a pretty good
water coordination pattern, that more or less maximizes crop output
given water needs and pests.  There is a
copy-the-most-successful-neighbor cultural transmission strategy (cf.
J.M. Alexander) that's at the core of the model.  Use [Marco Jannsen's
NetLogo version of their
model](http://www.openabm.org/model/2221/version/2/view) as a starting
point.

## Pure NetLogo model

### Verify that in Jannsen's model, close to optimal patterns are achieved.


### Add randomizing factor to copying:

Add randomizing factor to communication (parameterized) such that a
subak doesn't always copy the best neighboring subak.  This represents
greed and other messiness in within-Subak politics.  Perhaps this scheme
can be biased so that it favors what looks like short-term advantage.
e.g.  it also tries for more water more of the time, or something like
that.

(Does this really make sense?)

Experiment with this parameter and (try to) show that the system
breaks down with this condition: It doesn't achieve the relatively
optimal patterns.  It would be nice if the system is pretty sensitive to
such noise--i.e. it gets very bad pretty easily.  But we'll have to
experiment to see what will cause it to break down to what degree.

Maybe the noise factor should be, instead of randomness in whether
copying occurs, copying from non-neighbors.  i.e. let greediness of a
subak be modeled as copying from those farther way, who maybe are
doing even *better*.

### Add "religious" cultvar channel:

Add a separate cultural transmission channel for a "religious"
cultural variant that could either be Boolean or something more finer
grained, but nothing more complex than a real number.  This also follows
a copy-successful-neighbor pattern, where the success measure is the
same as for the water pattern copying, but where the choice to copy the
religious cultvar is independent of the choice to copy the water
coordination cultvar--i.e. there is a separate random factor.

Note that the randomization of copying has to be there, and has to be
distinct for the two cultvar channels; otherwise pairs of
water/religious cultvar will simply be copied and preserved together.

For the sake of efficiency when this model is extended with popco (see
below), within a timestep, copying of water-schedule cultvars by all
subaks should happen in one step, and the copying of religious cultvars
by all subaks should happen in a separate step.

### Damping by religious cultvars:

The religious cultvar also has this effect: For some of its values,
the randomization of the copy-successful factor is damped down.  i.e.
for some values of the religious cultvar, the probability of not
copying the most successful neighbor is lower.  Maybe this goes for
both cultvar channels.


## Model with analogies

### General notes:

A separate simulation would, instead of having single-dimensional
cultvars in the second, religious channel, sends that work off to popco,
where there is a more complex cultural transmission process.  In this
case, it's only when there is a good analogy between bels representing
water management stuff and bels representing religious stuff (analogies
yet to be determined!) that the greed/fussing/rivalries/etc. noise is
damped down.

So in the first simulation, try to write the religious cultvar
transmission code so that it's hidden behind functions that can
instead be made to call out to popco (by making popco a NetLogo
extension).  Not sure if this fully makes sense.

It might be done like this:

In each timestep, rather than having all subaks look at neighbors to
choose what religious cultvar to copy, call out to Clojure, where there
will be popco versions of each subak, with "beliefs".  Run a normal
popco communication tick.  The Clojure side then returns to the NetLogo
side a noise-damping value, which is then used in the next round in the
decision about which neighbor to copy.  This value will be a function of
the degree of analogousness of religious propositions to propositions
about irrigation or subak management or something like that.  (Lotta
work to do in teasing out what the propositions should be.)

Note that for the sake of efficiency, this means that within a timestep,
copying of water-schedule cultvars by all subaks should happen in one
step, and the call out to popco should be one step for all subaks.
So this architecture should be built into the code of the original
pure-NetLogo model.

i.e. rather than associating communication-noise probabilities with
specific scalar religious cultvars, we compute these probabilities
(how?) from the analogy relations.  And the religious communication is
no longer of single scalar cultvars, but is of a whole bunch of
possible cultvars.  And we're farming out that process to popco2 in
Clojure.

Maybe the popco model can work something like the popco crime models:
Everyone has certain non-religous propositions, and only religious
propositions are communicated.  The religious propositions reinforce
some non-religious propositions but not others, depending on the
analogies.  And it's the activation values of one or more of the
non-religious propositions that determines the damping/noise value
that's sent back to NetLogo.

However, to make this work, the NetLogo side has to send something to
popco that affects transmission.  Because we want to reinforce
transmission of those religious beliefs that are reinforcing success on
the irrigation side.  Maybe send something from NetLogo to popco such
that it's more probable to receive religious cultvars from neighbors who
are more successful with farming.  i.e. we will not have constant
transmission probabilities in popco.  This could be done with what's
currently the `+trust+` constant in `popco.core.constants` (i.e. make it
a regular variable rather than a constant), or by modifying the function
`popco.communic.speak/worth-saying-ids` so that in its line `:when (< randnum
activn)`, the `activn` or `randnum` value is scaled as a function of the
success information that's being sent over from the NetLogo side.
Something like that.

### Effect of subaks on analogies:

What would be nice would be to run the analogy simulation in popco by
itself, and show that you don't get a focus on the analogies that
interact with irrigation and all that.  Maybe you get a spread.  But
that when you add the reinforcement from the subak system, you get a
narrowing or bias of analogy outcomes.  i.e. both sides reinforce each
other.

### Information about calling Clojure from Java:

[http://stackoverflow.com/questions/2181774/calling-clojure-from-java](http://stackoverflow.com/questions/2181774/calling-clojure-from-java).
The Clojure code would be called from a NetLogo extension.  My
[uneof](https://github.com/mars0i/uneof) NetLogo extension provides a
simple starting point.)
