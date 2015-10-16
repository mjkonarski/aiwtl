# Am I Working Too Long?

## What's that?
A simple script tool to calculate worked hours in Harvest. It shows how much time you spent working since given date and how well do you meet an Xhrs/working day target. It uses Harvest REST API.

## Requirements

AIWTL requires the following gems:
* `rest-client`
* `parseconfig`

## Usage

Create a configuration file `~/.aiwtl` and the following inside:

```
subdomain = YOUR_HARVEST_SUBDOMAIN
user = YOUR_HARVEST_USER
pass = YOUR_HARVEST_PASS
hours_per_working_day = TARGET_HOURS_PER_WORKING_DAY
start_date = DEFAULT_STARTING_DAY //optional
```

Then run `ruby aiwtl.rb YYYY-MM-DD` or `ruby aiwtl.rb` if you specifed `start_date` in config.

As a result you get statistics about your working time. E.g:

```
ruby aiwtl.rb 2015-10-10
.....
Yes, you're working too long. You've got spare 1:47 h until yesterday.
Working days until yesterday: 3.
Working hours until yesterday: 24.0.
You worked for 25:47 h until yesterday.
Today you worked for 8:25 h
```

