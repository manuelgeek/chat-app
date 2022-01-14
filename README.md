# ChatApp

ChatApp is a Stream Based API service used to create Chat Applications

## Installation

Make sure you have [Erlang](https://www.erlang.org/), [Elixir](https://elixir-lang.org/) and [PostgreSQL](https://www.postgresql.org/). The current versions of Erlang and Elixir are defined in [.tool-versions](/.tool-versions).

Change into the `chat_app/` directory and run the following commands:

### Setup 
`cp config/dev.smple.exs config/dev.exs`

### Install Dependencies and run

```shell
mix deps.get
# sets up db and seeds sample data
mix ecto.reset
mix run --no-halt
```

Access on

`http://localhost:4000`


### API doc
https://documenter.getpostman.com/view/3385291/UVXjJvdH

### Usage
Login on `/login` or register with  `/register` then use the `auth_token` value as a `authorization` header with subsequent  API calls.

Web socket subscribes to POST:  `http://localhost:4000/ws/chat`
```json
{ "message" : "your message here" }
```

### Tests

Check `config/test.exs` for Test ENV config. To run test, run;

```mix test```

## What I could have done better
Given more time, I would have;
- Added more test coverage
- Added CI deployment script
- Figure out adding route scope macro for plug routes
- Check deeply into cowboy web sockets
