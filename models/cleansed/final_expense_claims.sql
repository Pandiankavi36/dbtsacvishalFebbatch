/*with base AS (
    select * from demo_db.staging.stg_expenses
),*/
 

WITH base AS (
    SELECT * FROM {{ ref('stg_expenses') }}
),
dq_check as(
    select *,
    case when claimed_amount > 10000 and expense_type in ('TRAVEL','HOTEL') THEN 'VIOLATION'
        ELSE  'OK'
    END  AS policy_violation_flag
    from base
)
SELECT
    claim_id,
    employee_id,
    claim_date,
    expense_type,
    claimed_amount,
    currency,
    approval_status,
    approver_id,
    policy_violation_flag
FROM dq_check