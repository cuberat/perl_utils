# NAME

Owenslib::Prog::Utils - General programming utilities for Perl.

# SYNOPSIS

# DESCRIPTION

# VERSION

1.07

# METHODS

## new()

Create a new object.

## Timestamps

### get\_time\_local($epoch\_secs)

Return the local timestamp in YYYY-mm-ddTHH:MM:SS format.

$epoc\_secs defaults to now.

### get\_date\_local($epoch\_secs)

Return the local date in YYYY-mm-dd format.

$epoc\_secs defaults to now.

### get\_date\_local\_yesterday()

Return the local date for yesterday in YYYY-mm-dd format.

### get\_time\_utc($epoch\_secs)

Return the UTC timestamp for $epoch\_secs in YYYY-dd-mmTHH:MM::SS format.

### get\_date\_utc($epoch\_secs)

Return the UTC date for $epoch\_secs in YYYY-dd-mm format.

### ($file\_path, line\_num) = get\_file\_line\_num()

Return the path to the file and the line number where this method is called
(useful for logging).

### ($filename, line\_num) = get\_filename\_line\_num()

Return the name of the file (without the directory part) and the line number
where this method is called (useful for logging).

## Logging

### config\_log($opts, $log\_level\_str)

Like `setup_logging()`, but with different default behaviors.

If no options are passed to countermand the defaults, the following options are
assumed to be set to true:

- `log_no_prog`
- `log_no_pid`
- `log_norm_ts`
- `log_src`

The following additional options are supported to countermand the above
defaults:

- `log_prog`
- `log_pid`
- `log_short_ts`
- `log_no_src`

Other options provided act as they do when passed to `setup_logging()`.

### setup\_logging($opts, $log\_level\_str)

Set up logging with the log level set to
`$log_level_str`. `$opts` is an options hash. If the key `log`
is present, its value is treated as a log file to write to,
unless the value is `*STDOUT` or `*STDERR`, in which case those
log lines will be written to those file handles.

This method also sets up 8 functions in the caller's environment
for logging:  `out_log($fmt, @args)`, and
`out_log_$str($fmt, @args)`, where `$str` is each of the log levels listed
below. `$fmt` is the same as for `printf()`. `out_log_tee($fmt, @ARGS)`
logs to the configured log plus standard error.

Log levels are (in ascending order of criticality):

- debug
- info
- notice
- warn
- err
- crit
- alert
- emerg

There is also `out_log_err_ret($rv, $fmt, @rest)` that will
return $rv when done. This is useful for returning from a
function with an error value without using an extra line of code.

#### Options

The following options in $opts change the logging behavior:

- `log_src`: Add the source file name to each log line.
- `log_norm_ts`: Use a more normal logging timestamp instead of stripping all delimiters.
- `log_micro_ts`: Include microseconds in the timestamp.
- `log_no_pid`: Don't including the process ID in the log line.
- `log_no_prog`: Don't include the program name in the log line.
- `log_utc_ts`: Log timestamps in UTC.

## Configuration file parsing

INI-style configuration parsing.

### my $data = setup\_conf($type, $file)

Reads the INI `$file` provided (file path or file handle). Returns the
data as a hash of all keys. Keys are prefixed by the section and a period ('.').
The default section is `global`.

`$type` is a namespace used to store your configuration in the Utils object.
You can retrieve individual fields later using `get_conf_val()` if you
so choose.

### `get_conf_val($type, $field)`

Retrieve the value association with the key `$field` from the configuration
set up with type `$type`.

### 

Reads the INI `$file` provided (file path or file handle). Returns the
data as a hash of all keys. Keys are prefixed by the section and a period ('.').
The default section is `global`.

## File I/O

### open\_file\_w($path)

Open the file in read-only mode. Compresses gzip, bzip2, and xz
files based on the filename extention if the corresponding
executables are available.

### open\_file\_ro($path)

Open the file in read-only mode. Decompresses gzip, bzip2, and xz
files based on the filename extention if the corresponding
executables are available.

### get\_gzip()

Look for the gzip executable in the standard places and return the path.

### get\_bzip2()

Look for the bzip2 executable in the standard places and return the path.

### get\_xz()

Look for the xz executable in the standard places and return the path.

### get\_ssh()

Look for the ssh executable in the standard places and return the path.

### get\_rsync()

Look for the rsync executable in the standard places and return the path.

### get\_mv()

Look for the mv executable in the standard places and return the path.

# AUTHOR

Don Owens <don@regexguy.com>
