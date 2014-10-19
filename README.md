# Ultimate Slack Notify Step
Posts wercker build and deploy status to a [Slack](https://slack.com/) channel

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