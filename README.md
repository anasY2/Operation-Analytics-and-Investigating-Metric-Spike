# Operation Analytics and Investigating Metric Spike
## Introduction:<br>
In this project we have to perform two operations:<br>
- Operation Analytics
- Investigating Metric Spike

And provide a detailed report mentioning the answers to the related questions. <br>
## Software Used:
- pgAdmin 4
- Postgresql 15
## Operation Analytics
**Tasks:**
1. Number of Jobs reviewed: Calculate the number of jobs reviewed per hour per day for November 2020?
2. Throughput: . Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7-day rolling and why?
3. Percentage share of each language:  Calculate the percentage share of each language in the last 30 days?
4. Duplicate rows: How will you display duplicates from the table?

## Investigating Metric Spike
**Tasks:**
1. User Engagement: Calculate the weekly user engagement?
2. User Growth: Calculate the user growth for product?
3. Weekly Retention: Calculate the weekly retention of users-sign up cohort?
4. Weekly Engagement: Calculate the weekly engagement per device?
5. Email Engagement: Calculate the email engagement metrics?
<hr>

## Operation Analytics
### 1. Number of Jobs reviewed: Number  of jobs reviewed per hour per day.

**Distinct Jobs:**
``` sql
Select ds, Round(Count(Distinct job_id) :: Numeric / (Sum(timespent)),2) AS num_jobs
From public.job_data
Group By 1;
```
**Output:**
| "ds"         | "num_jobs" |
|--------------|------------|
| "2020-11-16" | 0.01       |
| "2020-11-17" | 0.01       |
| "2020-11-18" | 0.01       |
| "2020-11-19" | 0.02       |
| "2020-11-20" | 0.00       |
| "2020-11-21" | 0.00       |
| "2020-11-22" | 0.02       |
| "2020-11-23" | 0.01       |
| "2020-11-24" | 0.02       |
| "2020-11-25" | 0.02       |
| "2020-11-26" | 0.02       |
| "2020-11-27" | 0.01       |
| "2020-11-28" | 0.06       |
| "2020-11-29" | 0.05       |
| "2020-11-30" | 0.05       |

**Non-Distinct jobs:**
``` sql
Select ds, Round(Count(job_id) :: Numeric / (Sum(timespent)),2) AS num_jobs
From public.job_data
Group By 1;
```

**Output:**
| "ds"         | "num_jobs" |
|--------------|------------|
| "2020-11-29" | 0.05       |
| "2020-11-21" | 0.01       |
| "2020-11-20" | 0.01       |
| "2020-11-24" | 0.02       |
| "2020-11-16" | 0.01       |
| "2020-11-19" | 0.02       |
| "2020-11-28" | 0.06       |
| "2020-11-22" | 0.02       |
| "2020-11-18" | 0.01       |
| "2020-11-26" | 0.02       |
| "2020-11-23" | 0.01       |
| "2020-11-25" | 0.02       |
| "2020-11-27" | 0.01       |
| "2020-11-30" | 0.05       |
| "2020-11-17" | 0.01       |

### 2. Throughput: 7 day rolling average.
**Distinct Jobs:**
``` sql
with jobs as (Select ds,Count(Distinct job_id) as num_jobs
From public.job_data
Group By ds)

Select ds,num_jobs,Round(Avg(num_jobs)
Over(
	Order By ds
	Rows Between 6 Preceding And Current Row
),2) As "7-Day-Rolling-Average"
From jobs;
```
**Output:**
| "ds"         | "num_jobs" | "7-Day-Rolling-Average" |
|--------------|------------|-------------------------|
| "2020-11-16" | 1          | 1.00                    |
| "2020-11-17" | 1          | 1.00                    |
| "2020-11-18" | 1          | 1.00                    |
| "2020-11-19" | 3          | 1.50                    |
| "2020-11-20" | 1          | 1.40                    |
| "2020-11-21" | 2          | 1.50                    |
| "2020-11-22" | 2          | 1.57                    |
| "2020-11-23" | 1          | 1.57                    |
| "2020-11-24" | 1          | 1.57                    |
| "2020-11-25" | 4          | 2.00                    |
| "2020-11-26" | 1          | 1.71                    |
| "2020-11-27" | 2          | 1.86                    |
| "2020-11-28" | 2          | 1.86                    |
| "2020-11-29" | 1          | 1.71                    |
| "2020-11-30" | 2          | 1.86                    |

**Non-Distinct Jobs:**
``` sql
with jobs as (Select ds,Count(job_id) as num_jobs
From public.job_data
Group By ds)

Select ds,num_jobs,Round(Avg(num_jobs)
Over(
	Order By ds
	Rows Between 6 Preceding And Current Row
),2) As "7-Day-Rolling-Average"
From jobs;
```

**Output:**
| "ds"         | "num_jobs" | "7-Day-Rolling-Average" |
|--------------|------------|-------------------------|
| "2020-11-16" | 1          | 1.00                    |
| "2020-11-17" | 1          | 1.00                    |
| "2020-11-18" | 1          | 1.00                    |
| "2020-11-19" | 4          | 1.75                    |
| "2020-11-20" | 3          | 2.00                    |
| "2020-11-21" | 4          | 2.33                    |
| "2020-11-22" | 2          | 2.29                    |
| "2020-11-23" | 1          | 2.29                    |
| "2020-11-24" | 1          | 2.29                    |
| "2020-11-25" | 4          | 2.71                    |
| "2020-11-26" | 1          | 2.29                    |
| "2020-11-27" | 2          | 2.14                    |
| "2020-11-28" | 2          | 1.86                    |
| "2020-11-29" | 1          | 1.71                    |
| "2020-11-30" | 2          | 1.86                    |

### 3. Percentage share of each language:  Percentage share of each language.

``` sql
Select language,
Round((count(*)  / (Select Count(*) From public.job_data) ::Numeric) * 100,2) As perc_language
From public.job_data
Group By language;
```

**Output:**
| "language" | "perc_language" |
|------------|-----------------|
| "Arabic"   | 13.33           |
| "Persian"  | 20.00           |
| "English"  | 20.00           |
| "Hindi"    | 13.33           |
| "French"   | 16.67           |
| "Italian"  | 16.67           |

### 4. Duplicate rows: Display duplicate rows.
``` sql
Select *,count(*)
From public.job_data
Group by ds,job_id,actor_id,event,language,timespent,org
having count(*) > 1;
```
**Output:**
| "ds"         | "job_id" | "actor_id" | "event"    | "language" | "timespent" | "org" | "count" |
|--------------|----------|------------|------------|------------|-------------|-------|---------|
| "2020-11-20" | 13       | 1007       | "skip"     | "French"   | 90          | "A"   | 2       |
| "2020-11-21" | 14       | 1007       | "decision" | "Italian"  | 130         | "D"   | 2       |
<hr>

# Investigating Metric Spike
### 1. User Engagement: Weekly user engagement.
``` sql
Select Extract(Week From occured_at) as week, Count(Distinct user_id) as num_distinct_users
From events
Where event_type = 'engagement'
Group By Extract(Week From occured_at)
Order By week;
```

**Output:**
| "week" | "num_distinct_users" |
|--------|----------------------|
| 18     | 701                  |
| 19     | 1054                 |
| 20     | 1094                 |
| 21     | 1147                 |
| 22     | 1113                 |
| 23     | 1173                 |
| 24     | 1219                 |
| 25     | 1263                 |
| 26     | 1249                 |
| 27     | 1271                 |
| 28     | 1355                 |
| 29     | 1345                 |
| 30     | 1363                 |
| 31     | 1443                 |
| 32     | 1266                 |
| 33     | 1215                 |
| 34     | 1203                 |
| 35     | 1194                 |

### 2. User Growth: User growth for a product.
``` sql
with active_users as (Select Extract(Year From created_at) as year, Extract(Week From created_at) as week,Count(*) as num_users
From users
Where state = 'active'
Group By Extract(Year From created_at), Extract(Week From created_at)
Order By year, week)

Select year, week,num_users, Sum(num_users)
Over(
	Order By year, week
	Rows Between Unbounded Preceding And Current Row
)
From active_users;
```
**Output:**
| "year" | "week" | "num_users" | "total_current_users" |
|--------|--------|-------------|-----------------------|
| 2013   | 1      | 67          | 67                    |
| 2013   | 2      | 29          | 96                    |
| 2013   | 3      | 47          | 143                   |
| 2013   | 4      | 36          | 179                   |
| 2013   | 5      | 30          | 209                   |
| 2013   | 6      | 48          | 257                   |
| 2013   | 7      | 41          | 298                   |
| 2013   | 8      | 39          | 337                   |
| 2013   | 9      | 33          | 370                   |
| 2013   | 10     | 43          | 413                   |
| 2013   | 11     | 33          | 446                   |
| 2013   | 12     | 32          | 478                   |
| 2013   | 13     | 33          | 511                   |
| 2013   | 14     | 40          | 551                   |
| 2013   | 15     | 35          | 586                   |
| 2013   | 16     | 42          | 628                   |
| 2013   | 17     | 48          | 676                   |
| 2013   | 18     | 48          | 724                   |
| 2013   | 19     | 45          | 769                   |
| 2013   | 20     | 55          | 824                   |
| 2013   | 21     | 41          | 865                   |
| 2013   | 22     | 49          | 914                   |
| 2013   | 23     | 51          | 965                   |
| 2013   | 24     | 51          | 1016                  |
| 2013   | 25     | 46          | 1062                  |
| 2013   | 26     | 57          | 1119                  |
| 2013   | 27     | 57          | 1176                  |
| 2013   | 28     | 52          | 1228                  |
| 2013   | 29     | 71          | 1299                  |
| 2013   | 30     | 66          | 1365                  |
| 2013   | 31     | 69          | 1434                  |
| 2013   | 32     | 66          | 1500                  |
| 2013   | 33     | 73          | 1573                  |
| 2013   | 34     | 71          | 1644                  |
| 2013   | 35     | 79          | 1723                  |
| 2013   | 36     | 65          | 1788                  |
| 2013   | 37     | 71          | 1859                  |
| 2013   | 38     | 84          | 1943                  |
| 2013   | 39     | 92          | 2035                  |
| 2013   | 40     | 81          | 2116                  |
| 2013   | 41     | 88          | 2204                  |
| 2013   | 42     | 74          | 2278                  |
| 2013   | 43     | 97          | 2375                  |
| 2013   | 44     | 92          | 2467                  |
| 2013   | 45     | 97          | 2564                  |
| 2013   | 46     | 94          | 2658                  |
| 2013   | 47     | 82          | 2740                  |
| 2013   | 48     | 103         | 2843                  |
| 2013   | 49     | 96          | 2939                  |
| 2013   | 50     | 117         | 3056                  |
| 2013   | 51     | 123         | 3179                  |
| 2013   | 52     | 104         | 3283                  |
| 2014   | 1      | 91          | 3374                  |
| 2014   | 2      | 122         | 3496                  |
| 2014   | 3      | 112         | 3608                  |
| 2014   | 4      | 113         | 3721                  |
| 2014   | 5      | 130         | 3851                  |
| 2014   | 6      | 132         | 3983                  |
| 2014   | 7      | 135         | 4118                  |
| 2014   | 8      | 127         | 4245                  |
| 2014   | 9      | 127         | 4372                  |
| 2014   | 10     | 135         | 4507                  |
| 2014   | 11     | 152         | 4659                  |
| 2014   | 12     | 132         | 4791                  |
| 2014   | 13     | 151         | 4942                  |
| 2014   | 14     | 161         | 5103                  |
| 2014   | 15     | 166         | 5269                  |
| 2014   | 16     | 165         | 5434                  |
| 2014   | 17     | 176         | 5610                  |
| 2014   | 18     | 172         | 5782                  |
| 2014   | 19     | 160         | 5942                  |
| 2014   | 20     | 186         | 6128                  |
| 2014   | 21     | 177         | 6305                  |
| 2014   | 22     | 186         | 6491                  |
| 2014   | 23     | 197         | 6688                  |
| 2014   | 24     | 198         | 6886                  |
| 2014   | 25     | 222         | 7108                  |
| 2014   | 26     | 210         | 7318                  |
| 2014   | 27     | 199         | 7517                  |
| 2014   | 28     | 223         | 7740                  |
| 2014   | 29     | 215         | 7955                  |
| 2014   | 30     | 228         | 8183                  |
| 2014   | 31     | 234         | 8417                  |
| 2014   | 32     | 189         | 8606                  |
| 2014   | 33     | 250         | 8856                  |
| 2014   | 34     | 259         | 9115                  |
| 2014   | 35     | 266         | 9381                  |

### 3. Weekly Retention: Weekly retention of user-sign ins.

``` sql
SELECT Extract(Week From occured_at) AS week,
COUNT (Distinct CASE WHEN e. event_type = 'engagement' THEN e.user_id ELSE NULL END) AS engagement,
COUNT (Distinct CASE WHEN e. event_type = 'signup_flow' THEN e.user_id ELSE NULL END) AS signup 
FROM events As e 
GROUP BY 1
ORDER BY 1;
```
**Output:**
| "week" | "engagement" | "signup" |
|--------|--------------|----------|
| 18     | 701          | 171      |
| 19     | 1054         | 350      |
| 20     | 1094         | 362      |
| 21     | 1147         | 371      |
| 22     | 1113         | 366      |
| 23     | 1173         | 390      |
| 24     | 1219         | 413      |
| 25     | 1263         | 421      |
| 26     | 1249         | 404      |
| 27     | 1271         | 405      |
| 28     | 1355         | 424      |
| 29     | 1345         | 426      |
| 30     | 1363         | 458      |
| 31     | 1443         | 476      |
| 32     | 1266         | 406      |
| 33     | 1215         | 473      |
| 34     | 1203         | 468      |
| 35     | 1194         | 514      |

### 4. Weekly Engagement: Weekly engagement per device.

``` sql
Select Extract(Week From occured_at) as week, device, Count(Distinct user_id) as users
From public.events
Where event_type = 'engagement'
Group By 1,2
Order By week;
```

**Output:**
| "week" | "device"                 | "users" |
|--------|--------------------------|---------|
| 18     | "acer aspire desktop"    | 10      |
| 18     | "acer aspire notebook"   | 21      |
| 18     | "amazon fire phone"      | 4       |
| 18     | "asus chromebook"        | 23      |
| 18     | "dell inspiron desktop"  | 21      |
| 18     | "dell inspiron notebook" | 49      |
| 18     | "hp pavilion desktop"    | 15      |
| 18     | "htc one"                | 16      |
| 18     | "ipad air"               | 30      |
| 18     | "ipad mini"              | 21      |
| 18     | "iphone 4s"              | 21      |
| 18     | "iphone 5"               | 70      |
| 18     | "iphone 5s"              | 45      |
| 18     | "kindle fire"            | 6       |
| 18     | "lenovo thinkpad"        | 90      |
| 18     | "mac mini"               | 8       |
| 18     | "macbook air"            | 57      |
| 18     | "macbook pro"            | 154     |
| 18     | "nexus 10"               | 16      |
| 18     | "nexus 5"                | 43      |
| 18     | "nexus 7"                | 20      |
| 18     | "nokia lumia 635"        | 19      |
| 18     | "samsumg galaxy tablet"  | 8       |
| 18     | "samsung galaxy note"    | 7       |
| 18     | "samsung galaxy s4"      | 56      |
| 18     | "windows surface"        | 10      |
| 19     | "acer aspire desktop"    | 26      |
| 19     | "acer aspire notebook"   | 34      |
| 19     | "amazon fire phone"      | 9       |
| 19     | "asus chromebook"        | 42      |
| 19     | "dell inspiron desktop"  | 58      |
| 19     | "dell inspiron notebook" | 78      |

There were 468 rows in the output.

### 5. Email Engagement: Email enagagement metrics.

``` sql
with email_metrics as (Select  
	Sum(Case When action = 'email_open' Then 1 Else 0 End) AS open_emails,
	Sum(Case When action in ('sent_reengagement_email','sent_weekly_digest') Then 1 Else 0 End) AS sent_emails,
	Sum(Case When action = 'email_clickthrough' Then 1 Else 0 End) as click_emails
From email_events)

Select open_emails,click_emails,sent_emails,
	   Round((open_emails :: Numeric / sent_emails)*100,2) as email_opening_rate,
	   Round((click_emails :: Numeric / sent_emails)*100,2) as email_clicking_rate
From email_metrics;
```

**Output:**
| "open_emails" | "click_emails" | "sent_emails" | "email_opening_rate" | "email_clicking_rate" |
|---------------|----------------|---------------|----------------------|-----------------------|
| 20459         | 9010           | 60920         | 33.58                | 14.79                 |
