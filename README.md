# Huckleberry

CLI client for Fin (https://getfin.com)

## API

You should use this user agent, but it's not required: `Fin/3.1.1 (iPhone; iOS
9.2.1; Scale/2.00)`

#### Create new message

    POST https://www.getfin.com/api/messages

Params:

| Name           | Purpose                        | Default       | Optional |
|----------------+--------------------------------+---------------+----------|
| `abbreviated`  | Unknown                        | `0`           | True     |
| `cu_id`        | Unknown                        | N/A           | True     |
| `lat`          | Latitude                       | N/A           | True     |
| `lon`          | Longitude                      | N/A           | True     |
| `local_time`   | Current time in ISO 8601       | N/A           | True     |
| `text`         | Text of the message to send    | N/A           | False    |
| `thread_cu_id` | Unknown                        | N/A           | True     |
| `thread_id`    | ID of thread to add message to | `0` to create | Depends  |
| `token`        | Authentication token           | N/A           | True     |
