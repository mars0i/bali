Notes on Janssen's Lansing-Kremer model
=========

I'm using this to clarify or discuss certain points in Janssen's ODD pdf
and the NetLogo Info tab, or highlight especially interesting or
significant points.  See these two documents for other important
details.  (The two documents are similar but not identical.)

**"ha"** means "hectare".  A hectare is 100x100 square meters, i.e. 10K
square meters.  This is about 2.47 acres.

Subaks are **neighbors** if and only if pests can spread between them.
(This is my reading of the bottom of the first page of the ODD
document.)

**Timesteps** are months, so there are 12 timesteps per year.

Harvest **yield** is measured in amount per hectare.

A **cropping pattern** is a specification of which crop to plant in
which month.  There are 5 plants, including the null plant, "fallow", so
in theory there could be 5 x 12 = 60 cropping patterns, but the model
only allows 21 variations.  However, cropping patterns can be started in
any of the 12 months, so it appears that there are actually 12 x 20 =
240 options.

Each subak chooses a cropping pattern at the beginning of each year.
i.e. initially, cropping patterns and starting months are randomly
assigned to subaks.  (This is the only randomness in the simulation;
after that it's all deterministic.)

After the first, random assignment of cropping patterns, subaks copy the
pattern of the neighbor subak with the highest yield, if any neighbor
had higher yield than the subak doing the copying.  Note that this is an
"imitate the best" strategy on a network (cf.  Boyd & Richerson 1985,
2005, etc., J. McKenzie Alexander 2007).
