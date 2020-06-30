Options:
  -?  --help               This message (use -? output for help on output type)
      --body-length-units  Speeds are in units of body lengths (default is mm)
      --from               Time from which to read data (in seconds, default 0)
      --graph              Bring up GUI to graph population data
      --header             Write tab-delimited description of each data column
  -I (--interactive)       Bring up GUI (same as --graph)
      --in                 Only use data points inside specified shape
      --ignore-outside-triggers   Ignore all data except near explicit triggers
  -m (--minimum-move-mm)   How far an object must move (in mm) to count
  -M (--minimum-move-body)   (same thing, except unit is object-lengths)
      --minimum-biased     If object travels this far, it's mostly forwards
      --map                Use GUI to display the data as a browsable map
  -n (--id)                Only use listed object IDs (use commas: -n 1,5,22)
  -N (--each-id)           Write one output file for each ID listed
      --no-output          Don't write any output
      --no-repeat          Remove any frames that appear to be repeated
      --out                Data must be outside specified shape.
  -o (--output)            Write specified output data (-? output for syntax)
  -O (--output-name)       Add an identifier to output
  -p (--pixelsize)         Size of one pixel, in mm
      --plugin             Use plugin; --plugin help gives generic help
      --prefix             Specify data file prefix explicitly
  -q (--quiet)             Don't print progress information to console
  -s (--speed-window)      Time window (in seconds) to average velocity
  -S (--segment)           Shape analysis of path: lines, arcs, etc.
      --shadowless         Only count objects after they move a body length
      --skip-zeros         Omit timepoints with zero objects found
      --spine-from-outline (Re)compute spine more robustly given outline
  -t (--minimum-time)      How long an object must last (in seconds) to count
  -T (--output-rate)       Time between output data points (in seconds)
      --to                 Time after which to ignore data (in seconds)
      --target             Place all output in specified directory (must exist)
      --trigger            Report a stimulus-triggered average to .trig file
      --trig-only          Only write triggered averages, not regular output
      --who                Print out object ID numbers that pass criteria
Format:
  directory must contain a MWT .summary file
  A .zip file containing the data can be specified instead of the directory.
    The corresponding directory will be created for output purposes.
  -m,M,p,s,t,--from,--to expect a floating-point value as an argument
  -O name turns output from prefix.dat to prefix.name.dat
    If only one -O is given, it will change the .pos file name also.
    If multiple -O's are given, only .dat files are changed, and there must be
      the same number of -o's and -O's (and will correspond in order)
  --trigger is followed by the duration of the averaging window (in seconds),
    a comma, and then comma-separated list containing either the time at which
    to trigger or the tap, puff, stim3, or stim4 keywords followed by a colon,
    the time before to take a measurement, a colon, and the time after to
    take a measurement.  (Numbers may be left blank; colons are required.)
    Multiple trigger statements are okay (each adds more columns to the file).
  -n or --id can be entered multiple times, and/or can contain multiple id
    numbers; all IDs are accumulated.  Numbers must be separated by commas
    with no spaces.  IDs that do not exist or fail criteria are excluded.
    The -N or --each-id variant appends a five-digit object ID number to
    the prefix, and creates one set of files for each object.
    -N all means output separately every object meeting the criteria.
    -n and -N are not compatible.  Use only one.
  --in and --out should be followed by either a center and radius (circle)
    as x,y,r, or two corners of a rectangle as x1,y1,x2,y2.
Examples:
  --trigger 1.0,5,tap:0.25:0.5,750 will average from 5-6 s after
    the start of recording, from 1.25 to 0.25 s before each tap, from 0.5 s
    to 1.5 s after each tap, and once more from 750-751 s.
  --trigger 0.2,tap::0.2 will average from 0.2 to 0.4 seconds after each tap
  --trigger 0.5,tap:0: will average from 0.5s before to 0 s before each tap
  --in 1,1,100,50 --out 25,25,5 would only take data from an elongated
    rectangle with a hole missing from its left side.