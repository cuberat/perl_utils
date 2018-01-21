# NAME

Owenslib::Prog::Utils - General programming utilities for Perl.

# SYNOPSIS

# DESCRIPTION

# VERSION

1.04

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

## Logging

### setup\_logging($opts, $log\_level\_str)

Set up logging with the log level set to
`$log_level_str`. `$opts` is an options hash. If the key `log`
is present, its value is treated as a log file to write to,
unless the value is `*STDOUT` or `*STDERR`, in which case those
log lines will be written to those file handles.

This method also sets up 8 functions in the caller's environment
for logging:  `out_log($fmt, @args)`, and
`out_log_$str($fmt, @args)`, where `$str` is each of the log levels listed
below. `$fmt` is the same as for `printf()`.

Log levels are (in ascending order of criticality):

- debug
- info
- notice
- warn
- err
- crit
- alert
- emerg

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

# AUTHOR

Don Owens <don@regexguy.com>
