# Huckleberry

A super simple, super barebones command-line client for
[Fin](https://getfin.com).

## Usage

Using Huckleberry is as simple as it gets. Take the script in
[`bin/huckleberry`](bin/huckleberry) and put it somewhere in your `PATH`.

Once you've done that, set `FIN_TOKEN` to your Fin token in your `.bashrc` (I
personally have a `~/.finrc` file that's sourced by `~/.bashrc` when launched).
You can get your Fin token by proxying requests while the Fin app is open
through something like [Charles](https://www.charlesproxy.com/).

Now just run `huckleberry` followed by your request to Fin. Finntastic! (please
excuse the bad pun)

```
Usage: huckleberry [request]

Examples:

  $ huckleberry 'How old is Barack Obama?'
  $ huckleberry 'How many miles is NYC from SF?'
  $ huckleberry 'What is the wait for two at Ippudo Westside?'
```

## API Docs

This contains (very) preliminary documentation for Fin's API, primarily for
personal reference.

You should use this user agent, but it's not required: `Fin/3.1.1 (iPhone; iOS
9.2.1; Scale/2.00)`

#### Create new message

    POST https://www.getfin.com/api/messages

Params:

| Name           | Purpose                        | Default       | Optional? |
| -------------- | ------------------------------ | ------------- | --------  |
| `abbreviated`  | Whether message was dictated   | N/A           | Optional  |
| `cu_id`        | Unknown                        | N/A           | Optional  |
| `lat`          | Latitude                       | N/A           | Optional  |
| `lon`          | Longitude                      | N/A           | Optional  |
| `local_time`   | Current time in ISO 8601       | N/A           | Optional  |
| `text`         | Text of the message to send    | N/A           | Required  |
| `thread_cu_id` | Unknown                        | N/A           | Optional  |
| `thread_id`    | ID of thread to add message to | `0` to create | Depends   |
| `token`        | Authentication token           | N/A           | Required  |

_Note: haven't entirely figured out voice messages yet. This is just for text
messages._
