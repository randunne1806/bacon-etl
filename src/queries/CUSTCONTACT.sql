select H."H-JOB#",H."H-PART#",R."R-PO-DATE",H."H-CUST",R."R-SHIP-ID",S."SHIP-EMAIL" 
FROM HEADER H, RELEASE R, SHIPTO S
WHERE H."H-JOB#" = R."R-JOB#"
AND (((H."H-CUST-NBR" collate ads_default_ci) = (S."CUSTOMER-NBR"))
AND (R."R-SHIP-ID" = S."SHIP-ID"))
AND R."R-PO-DATE" > '12/31/2021'