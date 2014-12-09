ArchitectureNotes6.md
====
(Summarizing upshot of ArchitectureNotes*.md.)

----

key:

	SP: spiritual peasant propositions
	SB: spiritual brahmanic propositions
	WP: worldly peasant propositions
	WB: worldly brahmanic propositions

----

1. SP=>WP: High activation of SP (vs SB) should bias transmission toward WP (vs. WB).<br/></br>

2. WP=>SP: High activation of WP (vs SB) should bias transmission toward SP (vs. WB).<br/></br>

3. Success should bias transmission of whatever the successful individual believes (`trust`).<br/></br>

4. Noise-suppression in NetLogo should be linked to (e.g.) mean activn of SP in popco:<br/>
In a linked simulation, the spiritual float value for a subak should be a function of its mean
SP activn.<br/></br>

5. As a result, success (yield) in NetLogo will be correlated with mean
activn of SP<br/>(under conditions that allow the spiritual float to have an effect).<br/></br>

------

A system (?):

1. Only WP, not WB propns are present in popco.  This biases transmission of SP over SB.

2. When mean SP activn is high, spiritual float in NetLogo is high.

3. When there is a nonzero ignore-pestneighbor probability, the spiritual float for an
   individual makes the prob of ignoring pestneighbors lower.

4. This lowering due to the spiritual float will make sucess more likely.

5. Transmission is further biased by success.  i.e. there is a trust variable or other function
in popco that is a function of yield in NetLogo.

An initial step toward #5 is to simply cause trust in popco to be a
function of mean SP activation.  (This does not obviate the value of
doing a full linked simulation; see notes below.)  i.e. do a popco-only
simulation like this:

1. Only WP, not WB propns are present in popco.  This biases transmission of SP over SB.

2. When a sender's mean SP activn is high, listeners' trusts are high.

Possibly add stochasticity to step 2; see notes below.

------

Correction to above (and below).  Don't use the "trust" concept in
popco.  This is in listener.clj (in `update-propn-net-from-utterances`),
i.e. it's applied *after* the utterances are received.  So to compute
trust from the speaker's SP propositions in listener.clj, I'd have to
pass extra information across with the utterances, which currently
contain only a proposition id and a valence number.  Moreover, the point
of trust is to be listener-specific--whereas  success bias is
speaker-specific.  Finally, what trust does, currently, is not to
influence the probability of accepting the influence from the utterance,
but rather to calculate how much it influences the speaker (which,
currently, is done by multiplication by constant defined in
constants.clj (recall that the valence is always either 1 or -1)).

So the best thing to do would be to represent success bias via a
speaker-specific bias on the (previously just proposition-specific)
probability of transmission.  (Maybe call this influence
"trustworthiness".0



------

Notes:

One possibility is to think of WP (vs. WB) as linked to the degree to
which subaks copy or ignore pestneighbors' crop plans.  On this
proposal, the ignore-pestneighbors probability should perhaps be a
function of the mean activn of WP, i.e. it varies per person.  No,
that's what the SP is doing.  Rather, WP is simply the default state of
the peasants.  There should be no role in a linked simulation for WB.
Noisiness is simply the default state of humans.  Still, noisiness here
is departure from the WP, toward a more autocratic (WB-like) strategy.

Note it's not just that analogies bias transmission.  It's that they're
the source of noise suppression.

Here's one way of thinking about the causal process:

> There's an initial, weak analogy bias.  Then there is believing both
sides of the analogy.  Then there is *identification* of both sides of
the analogy.  Then as a result there is noise-suppression.  Then that
creates success, which generates success-bias, so the analogy spreads.

In the NetLogo-popco model, this suppression as a result of
identification is why I might want to make suppression simply a
function of the religious beliefs.  (Or maybe their analogical worldly
beliefs.)  Because it's the identification that gives the religious
beliefs their immediate effect.

----

In the current plan, NetLogo will send a value that makes trust higher
when the speaker is successful.  A way to simulate this in popco alone
is simply to make trust higher when the speaker's mean activation in the
spiritual-peasant direction is higher.  (Or don't do it with trust, and
instead make the prob of tran higher when spiritual-peasant mean activn
is higher.)

But that's a crude simulation, since in NetLogo, the benefit of noise
suppression is not constant, but is instead stochastic.  Whereas if I
make trust a function of mean SP activation, there's no stochasticity
about it.  Unless I add stochasticity in to trust.  I could do that, I
guess.  It could even be matched to ignore-pestneighbors probabilities
set in NetLogo.  (But if I'm doing that, then maybe I should also have some
stochastic dimension on the transmitter side in NetLogo.  Well I suppose
that's one benefit of linking the popco and NetLogo: you get the combined
interaction of the two kinds of processes.  I'm not going to build that
kind of transmission messiness into NetLogo, I don't think.

Still, this is a worthwhile experiment to perform.  It gets things ready
for a full connection, which still should be performed.
