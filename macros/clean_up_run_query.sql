{% macro clean_up_run(db_name, no_days) %}
{%- set query_sch %}
    SELECT DISTINCT schema_name
    FROM {{db_name}}.INFORMATION_SCHEMA.schemata
    WHERE schema_name ilike 'OMOP_%'
    AND to_date(created) < current_date() - 40
{% endset -%}
{%- set results = run_query(query_sch) %}
{%- if execute -%}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{%- endif -%}

{%- for sch in results_list %}
{%- set drop_sch %}
    DROP SCHEMA {{db_name}}.{{sch}};
{% endset -%}
{%set results2 = run_query(drop_sch)%}
{%- endfor %}
{% endmacro %}