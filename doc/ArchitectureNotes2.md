Notes on architecture & strategy 2
====

#### 1. Simple two-channel model (NetLogo only)

The way the simple two-channel transmission model (all in NetLogo)
works is this:

When you evaluate your neighbors, copy *both* the best neighbor's
crop plan *and* its religious value.

Question: The religious value does not have an immediate effect.  It is,
rather, a damper on noise wrt *copying*.  That's how I've been thinking
about it.  So is it really beneficial to copy the religious value?  It
won't affect what you just copied on the cropplan channel.  Should that
be more persistent?  Maybe you only copy it every three years or
something?

An alternative would be to introduce the noise not in copying, but in
implementation.  i.e. the noise doesn't prevent you from choosing the
best neighbor.  It instead distorts whatever you choose.  Maybe it's a
prob of changing to a random cropplan.  (And then others might copy that
from you.)  In this case, I think that having the better religious
value *now* is good, because it prevents you from randomly choosing
another cropplan than the one you copied.  I like this.  It fits with
the greed, bhutakala, etc. hypotheses.

(btw if you're not careful noise could be an advantage.
Mutation is good, as long as variation is still heritable)

---------------

#### 2. Analogical two-channel model (Popco/NetLogo)

In this model, again, what you choose in the second channel should be
driven by harvest success.  So maybe the way to do it is that NetLogo
passes to Popco the identity of the best neighbor.  Then Popco
transfers a belief (or more) from the best neighbor in Popco to you in
Popco.

Then Popco sends back to NetLogo a value that represents the degree to
which your beliefs are analogically close to the way farming and social
relations work.  Something like that.
(It probably does make more sense to have NetLogo call out to Popco
than the other way around.  That's also what NetLogo wants to do,
since Extensions are the natural way to integrate the two systems.)

Maybe the way that Popco will work is that NetLogo sends to Popco
a list of communication pairs or something.  Maybe Popco updates
the talk-to-groups in each person in response to what's sent.
And then you run `once`.  Or maybe `speak/choose-listeners` calls out
to find out who to talk to.

And then after `once` is run (or inserted into it at the end), we
evaluate the closeness of analogies to farming needs, and send back the
code that was previously transmitted directly in the simple two-channel
model.

Note that the calling out to Popco can all be contained in the NetLogo
imitation routines, and in fact within that part of them that deals
with the second channel.

Question: What is neural net settling doing in this model?

.....

If my neighbor is doing well, that's because it has adopted a lot of
the right analogy.  (Maybe I need to allow this spread to take place
independently, randomly, at first.  Maybe I won't get homogeneity
immediately since I've got network structure in the transmission network.)
So if I draw propositions from it repeatedly, I'll (a) start to collect
the "good" propositions, and (b) tend to suppress the bad propositions.

Note that those with the right analogy will have more influence.  They
will be like pundits.  (Pundits embedded in a corner of the network
structure.)

----------------------------------------

How about this: The "noisy" choice is always to choose the 3-planting
choice.  (Q: With no particular month?)
