{% macro clean_up_run(db_name, no_days) %}

{% set query_sch %}

    SELECT DISTINCT schema_name
    FROM {{db_name}}.INFORMATION_SCHEMA.schemata
    WHERE schema_name ilike '%S%'
    AND to_date(created) < current_date() - {{no_days}}

{% endset %}
{%- set results = run_query(query_sch) %}
{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}
{{results_list}}
{% endmacro %}