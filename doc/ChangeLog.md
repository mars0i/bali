Change log
====

#### From Janssen's original v.2 to my initial version Bali3a.nlogo:

* Bug fix, I think (need to check with Lansing and Janssen): In
*subaksubakdata.txt*, added subaksubak links from subaks 163 and 166 into
subak 164.  Subak (turtle) 164, which appears at the right end of a
cross in a group of subaks just lower right from the center of the
NetLogo world, had only one-way links. i.e. it had a subaksubak leading
from it to the subak to its left (subak/turtle 163), and a subaksubak
leading from it to the subak down and to the left (subak/turtle 166).
This subak was unique in having only one-way links.  All other subaks
either have no subaksubak links, or had subaksubaks running in both
directions to/from each subak to which they were lined.  I suspect that
this unique status of this subak, 164, was just an inadvertent result of
a typo.

* Bug fix: In `imitatebestneighbors`, old version, subaks would not
imitate during months when their crop was lying fallow.  Initially I
changed this by putting a switch in the UI that would allow turning this
behavior, which I believe is not intended, on and off.  Eventually I may
remove the switch and simply use only the new behavior that imitates
whether fallow or not.

* Bug fix (?): In `imitatebestneighbors`, old version, subaks with no
neighbors always reverted to crop plan 0, month 0.  This happened
because the loop through neighbors never found these subaks, and as a
result their `SCCc` and `sdc` variables were never set, but instead just
had the NetLogo default values of 0.  I think the intended behavior is
that these subaks just retain their original crop plan and month, which
is what happens now.

* Bug fix: In `setup`, in final outer `ask subaks` block, in last line
of code which adds to list in `damneighbors`, replaced `self` with
`myself`, which appears to be what was intended.  Original version just
collected repeated instances of the same subak in its own
`damneighbors`.  (This does not appear to be a change that affects
function.  I don't see `damneighbors` used anywhere.)

* Changed some of the limits in the plots in the UI.

* Added other reporting objects in UI:

    * Crop plan distribution histogram
    
    * Info on the modal crop plan and modal start month.

* Changed code for coloring of subaks to show cropplans and months.
Now the month color is displayed in the patch behind the subak, and
the subak color represents the cropplan.

* Added UI switch and code that can cause display of the subak number
and month number over each subak.

* Added UI switches that allow excluding individual cropplans, plus
buttons that allow including or excluding all crop plans.  (Excluding
all is a useful step if you want to include only a few crop
plans--i.e. then you can just enable a isolated plans.)

* Added code to `go` routine so that the `viewdamsubaks` switch would
also turn the `damsubak` and `subakdam` links on and off while the
model is running.

* Renamed variables in `growpest` to match ODD and/or Janssen 2006,
and simplified the code slightly without changing the mathematical
result (apart from *very* small floating point differences--at least
14 digits after the decimal).  Also reformatted the code a bit.

* Added comments, reformatted some lines, renamed some variables
globally.  I've tried to be conservative, and in most (all?) cases,
the old code is still there, but commented out, or I added a comment
describing the change.

* Commented out some code that couldn't possibly do anything.  (e.g.
in `setup` there were two `ask subaks` blocks that duplicated some of
the same variable-setting operations, so I left only the later version
uncommented.)

* Removed old sliders for number of subaks (`num-subaks`) and number *
of dams (`num-dams`), which weren't doing anything--their values were
fixed.

* Removed chooser `nrcropplans` that allowed switching between the first
six cropplans and all 21 of them.  This function is superceded by
switches to select croppolans individually.
