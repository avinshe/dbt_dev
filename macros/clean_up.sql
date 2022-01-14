{% macro clean_up(schema_name, no_days) %}

{% set query %}
    SELECT DISTINCT schema_name
    FROM {{schema_name}}.INFORMATION_SCHEMA.schemata
    WHERE schema_name ilike '%S%'
    AND to_date(created) < current_date() - {{no_days}}
{% endset %}

{% set results = run_query(query) %}
{% set results_list = results.rows %}

{% for sch in results_list %}
{{sch}}
{% endfor %}

{% endmacro %}