# Huckleberry

Huckleberry is a barebones command-line client for [Fin](https://getfin.com).
Just run `huckleberry 'Do the things'` and Fin'll get 'em done (and, unlike
emailing your request in, you'll see requests made through Huckleberry in the
app).

## Usage

Using Huckleberry is as simple as it gets. Take the script in
[`bin/huckleberry`](bin/huckleberry) and put it somewhere in your `PATH`.

Once you've done that, set `FIN_TOKEN` to your Fin token in your `.bashrc` (I
personally have a `~/.finrc` file that's sourced by `~/.bashrc` when launched).
See the _[Getting your Fin Token](#getting-your-fin-token)_ section for
instructions on getting your token.

Now just run `huckleberry` followed by your request to Fin. Finntastic! (please
excuse the bad pun)

```
Usage: huckleberry [request]

Examples:

  $ huckleberry 'How old is Barack Obama?'
  $ huckleberry 'How many miles is NYC from SF?'
  $ huckleberry 'What is the wait for two at Ippudo Westside?'
```

### Getting your Fin Token

Instructions for getting your Fin token (this assumes iOS because Fin is only
available on iOS):

1. Download Charles Proxy and launch it (https://www.charlesproxy.com)
2. Go to `Proxy > SSL Proxying Settings` and then click "Add". Set both the host
   and port to `*`. Click "Add" and then "OK" to confirm and get out of this
   prompt.
3. Open http://www.charlesproxy.com/getssl/ on your phone and accept the
   certificate request. Install it.
4. Make sure your phone and your computer are on the same network (and that
   they're accessible to each other, this won't work at most hotels).
  1. On your phone, go to `Settings > Wi-Fi` and then click the `(i)` button
     next to your current Wi-Fi network
  2. Scroll to the bottom until you see "HTTP Proxy" and click "Manual"
  3. Set "Server" to your computer's local IP address (ex. 192.168.0.11). You
     can get this with `ifconfig` or by going to `Help > Local IP Address` in
     Charles.
  4. Set "Port" to `8888`
5. Open up the Fin app on your phone. You should see a confirmation prompt in
   Charles. Accept it.
6. Open up a few messages threads in the Fin app
7. You should see a bunch of HTTPS request to the API flood into Charles. Expand
   the ones for `https://www.getfin.com`, `api`, and `messages` until you see
   requests that say `view`. Click on a request for `view`.
8. In the top tab bar on the right, select the "Request" tab
9. In the bottom tab bar on the right, select the "Form" tab
10. You should see an entry for "token". Double click the token's value to be
    able to copy and paste it.

## API Docs

This contains (very) preliminary documentation for Fin's API, primarily for
personal reference.

The current user agent (as of 01.25.16) for the iPhone app is `Fin/3.1.1
(iPhone; iOS 9.2.1; Scale/2.00)`. Huckleberry uses the user agent `Huckleberry`.

#### Create new message

    POST https://www.getfin.com/api/messages

Params:

| Name           | Purpose                        | Default       | Optional? |
| -------------- | ------------------------------ | ------------- | --------  |
| `abbreviated`  | Whether message was dictated   | N/A           | Optional  |
| `cu_id`        | Client unique ID               | N/A           | Optional  |
| `lat`          | Latitude                       | N/A           | Optional  |
| `lon`          | Longitude                      | N/A           | Optional  |
| `local_time`   | Current time in ISO 8601       | N/A           | Optional  |
| `text`         | Text of the message to send    | N/A           | Required  |
| `thread_cu_id` | Client unique ID for thread    | N/A           | Optional  |
| `thread_id`    | ID of thread to add message to | `0` to create | Depends   |
| `token`        | Authentication token           | N/A           | Required  |

_Note: haven't entirely figured out voice messages yet. This is just for text
messages._

## License

Huckleberry is licensed under the MIT License (see [`LICENSE`](LICENSE) for the
full text).
