# master 
...

# Version 0.8.8

Release date: 2012-07-01

### Added

* ```stamp``` now returns its result.
* ```:capture => true``` option passed to ```stamper``` will not print the output of block captured.

### Changed

* Replaced remaining 'puts' with 'print'.

### Fixed

* ```Cutter::Stamper``` now uses ```Time.now.to_i``` instead of ```Time.now.strftime```, which is locale-dependent [John Cupitt]
* Fixed defining/undefining of ```stamp``` and ```stamp!``` methods.

# Before 0.8.8

Long-long history here undocumented...
