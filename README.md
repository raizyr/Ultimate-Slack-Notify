# Ultimate Slack Notify Step
Ultimate notifications for wercker build/deploy status to a [Slack](https://slack.com/) channel

[![wercker status](https://app.wercker.com/status/205507ebb902574b5776f5b34f7fe5ed/m "wercker status")](https://app.wercker.com/project/bykey/205507ebb902574b5776f5b34f7fe5ed)

## Options

### Required

* `token` - Your Slack integration token.
* `subdomain` - Your Slack subdomain.
* `channel` - Name of the Slack channel you want to send message for.

### Optional

* `username` - Bot name. (default `Wercker`)
* `icon_url` | `icon_emoji` - The icon to use for this bot.
* `on` - Possible values: `always` and `failed`, default `always`.


Example
--------
Add following variables as deploy target or application environment variables:
`SLACK_TOKEN`, `SLACK_CHANNEL` and `SLACK_SUBDOMAIN`

```yml
build:
    after-steps:
        - lotustm/slack-notify:
            token: $SLACK_TOKEN
            channel: $SLACK_CHANNEL
            subdomain: $SLACK_SUBDOMAIN
```