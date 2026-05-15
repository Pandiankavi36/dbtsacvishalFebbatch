{{ config(
        materialized = 'view',
        database = 'demo_db',
        schema = 'staging'
)}}


with ranked_claims AS (
    select 
        claim_id, 
        employee_id, 
        claim_date, 
        expense_type,  
        claimed_amount, 
        currency, 
        approval_status,
        approver_id,
        row_number() over(partition by claim_id order by claim_date desc ) as rn
from raw.public.expense_claims
)
select  
        claim_id, 
        employee_id, 
        claim_date, 
        UPPER(expense_type) AS expense_type,  
        claimed_amount, 
        currency, 
        LOWER(approval_status) AS approval_status,
        approver_id
from ranked_claims
where rn =1