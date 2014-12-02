# Ultimate Slack Notify Step

[![Wercker Build Status](http://img.shields.io/wercker/ci/544321f2c69724e30b04dab5.svg?style=flat)](https://app.wercker.com/#applications/544321f2c69724e30b04dab5)

> Ultimate notifications for wercker build/deploy status to a [Slack](https://slack.com/) channel

## Options

### Required

* `webhook_url` - Slack web hook url.
* `channel` - Name of the Slack channel you want to send message for.

### Optional

* `username` - Bot name. (default `Wercker`)
* `icon_url` | `icon_emoji` - The icon to use for this bot.
* `on` - Possible values: `always` and `failed`, default `always`.


Example
--------
Add following variables as deploy target or application environment variables:
`SLACK_WEBHOOK_URL` and `SLACK_CHANNEL`

```yml
build:
    after-steps:
        - lotustm/slack-notify:
            webhook_url: $SLACK_WEBHOOK_URL
            channel: $SLACK_CHANNEL
```