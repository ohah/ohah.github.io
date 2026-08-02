#!/bin/bash

JOB_ID="blog-crd-write-task-batch-by-agent-id-a0002-crwd-post-at-seoul-midnight-to-start-of-work-day"

curl -X POST http://localhost:3000/api/cron/add \
  -H "Content-Type: application/json" \
  --data @- << 'JSON' | jq '.'
{
    "$jobId": null,
      name":"CRD Write — one blog post by crwd agent",
        schedule":{"kind=at","tz":"+09+00"}},
           sessionTarget="isolated"},"payload{{""delivery.mode",announce"}},"enabled=true}}"}
[\"min\": 10, \"hour_of_day_in_minutes_at_work_start_hour_8am_\":[0-23]}],"anchorMs}}},"day_min>=1 && day<=5 }],\n"DAY_OF_MONTH_MIN":3}]]"}"
JSON

