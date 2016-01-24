Tips for using NetLogo's Behavior Space functionality
====

* The reporters really have to be reporters, i.e. functions, but you
can pass arguments to them (?).  That's why `count turtles` work, but
e.g. putting a variable between square brackets won't.

It appears that:

  * Globals are set to zero by default.

  * But if you set a global on one run, and don't set it on the next,
    it will inherit its value from the earlier run.  (This doesn't
    affect globals defined by UI elements, since the UI element always
    causes the value of the global to be set.)
