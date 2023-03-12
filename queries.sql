--OPERATION ANALYTICS
--Number of jobs reviewed per hour per day.

--Distinct jobs
Select ds, Round(Count(Distinct job_id) :: Numeric / (Sum(timespent)),2) AS num_jobs
From public.job_data
Group By 1;

--Non-distinct jobs
Select ds, Round(Count(job_id) :: Numeric / (Sum(timespent)),2) AS num_jobs
From public.job_data
Group By 1;


-- Throughput: 7 day rolling average.

--Distinct jobs
with jobs as (Select ds,Count(Distinct job_id) as num_jobs
From public.job_data
Group By ds)

Select ds,num_jobs,Round(Avg(num_jobs)
Over(
	Order By ds
	Rows Between 6 Preceding And Current Row
),2) As "7-Day-Rolling-Average"
From jobs;

--Non-distinct jobs
with jobs as (Select ds,Count(job_id) as num_jobs
From public.job_data
Group By ds)

Select ds,num_jobs,Round(Avg(num_jobs)
Over(
	Order By ds
	Rows Between 6 Preceding And Current Row
),2) As "7-Day-Rolling-Average"
From jobs;


--Percentage share of each language.
Select language,
Round((count(*)  / (Select Count(*) From public.job_data) ::Numeric) * 100,2) As perc_language
From public.job_data
Group By language;


--Duplicate rows.
Select *,count(*)
From public.job_data
Group by ds,job_id,actor_id,event,language,timespent,org
having count(*) > 1;


--INVESTIGATING METRIC SPIKE

--User Engagement.
Select Extract(Week From occured_at) as week, Count(Distinct user_id) as num_distinct_users
From events
Where event_type = 'engagement'
Group By Extract(Week From occured_at)
Order By week;

--User Growth.
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

--Weekly Retention.
SELECT Extract(Week From occured_at) AS week,
COUNT (Distinct CASE WHEN e. event_type = 'engagement' THEN e.user_id ELSE NULL END) AS engagement,
COUNT (Distinct CASE WHEN e. event_type = 'signup_flow' THEN e.user_id ELSE NULL END) AS signup 
FROM events As e 
GROUP BY 1
ORDER BY 1;

--Weekly Engagement.
Select Extract(Week From occured_at) as week, device, Count(Distinct user_id) as users
From public.events
Where event_type = 'engagement'
Group By 1,2
Order By week;

--Email Engagement.
with email_metrics as (Select  
	Sum(Case When action = 'email_open' Then 1 Else 0 End) AS open_emails,
	Sum(Case When action in ('sent_reengagement_email','sent_weekly_digest') Then 1 Else 0 End) AS sent_emails,
	Sum(Case When action = 'email_clickthrough' Then 1 Else 0 End) as click_emails
From email_events)

Select open_emails,click_emails,sent_emails,
	   Round((open_emails :: Numeric / sent_emails)*100,2) as email_opening_rate,
	   Round((click_emails :: Numeric / sent_emails)*100,2) as email_clicking_rate
From email_metrics;