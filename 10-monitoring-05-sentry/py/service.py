import sentry_sdk
from sentry_sdk import set_tag

sentry_sdk.init(
    dsn="https://f0da5677f3cb4657b5f64c574d94edc9@o4505302825828352.ingest.sentry.io/4505302830284800",

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    traces_sample_rate=1.0
)

set_tag("netology", "10-monitoring-05-sentry")

division_by_zero = 1 / 0