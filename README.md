# When Was I Here

Want to know how many Saturdays you've spent in office? Here's a script for that (if you've let Google spy on you for years).

- Get your Google Location History from [Takeout](https://takeout.google.com/settings/takeout). Keep the json file handy.
- `gem install geokit` for coordinate comparisons
- Use it like this:
```
./when_was_i_here -f 1523945373 --lat 12.9389 --long 77.6095 --weekday 6 'Location History.json'
```

### Complete Options
```
Usage: when_was_i_here [options]

Options:
    -f, --from [FROM]                From timestamp
    -t, --to [TO]                    To timestamp
    -w, --weekday [WEEKDAY]          Weekday
    -d, --distance [DISTANCE]        Distance in meters
        --lat [LATITUDE]             Latitude
        --long [LONGITUDE]           Longitude
```