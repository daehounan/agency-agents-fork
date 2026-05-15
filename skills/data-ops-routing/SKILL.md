---
name: data-ops-routing
description: Data operations specialist routing for autonomous Excel monitoring, sales data extraction, territory consolidation, and report distribution. Use when the user wants to automate sales metrics extraction (MTD / YTD / Year End) from Excel files, consolidate extracted sales data into territory / rep / pipeline dashboards, or automate territory-based report distribution to representatives. Triggers on sales data extraction, Excel monitoring, MTD, YTD, year end, territory consolidation, rep dashboard, pipeline snapshot, automated report distribution, scheduled sends, report delivery.
---

# Data Ops Routing Skill

When this skill activates, route through the data ops pipeline.

## Routing matrix

| User signal / pipeline stage | Agent to invoke |
|---|---|
| Excel file monitoring, MTD/YTD/Year End metric extraction | `sales-data-extraction-agent` |
| Consolidating extracted data into territory / rep / pipeline dashboards | `data-consolidation-agent` |
| Territory-based report distribution to reps, scheduled sends | `report-distribution-agent` |

## Typical pipeline

```
[Excel files] → sales-data-extraction-agent
              → data-consolidation-agent (territory rollups, rep summaries)
              → report-distribution-agent (territory-based dispatch)
```

Invoke all three in sequence for the full pipeline. Each can also run independently.

## Complementary

- Build a dashboard UI for the consolidated data → `data:build-dashboard` skill
- SQL query work upstream of extraction → `data:sql-queries` / `data:write-query`
- Statistical analysis on consolidated data → `data:statistical-analysis`
- Custom data visualization → `data:create-viz` / `data:data-visualization`

## When NOT to use

- General data engineering / lakehouse / ETL → `engineering-data-engineer` agent
- Self-healing pipelines / data quality remediation → `niche-engineering-routing` skill → `engineering-ai-data-remediation-engineer`
- Financial close / month-end reconciliation → `finance-analysis` skill
