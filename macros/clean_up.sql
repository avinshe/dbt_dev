{% macro clean_up(schema_name, no_days) %}

{%- call statement('dist_sch_name', fetch_result=True) -%}

    SELECT DISTINCT schema_name
    FROM {{schema_name}}.INFORMATION_SCHEMA.schemata
    WHERE schema_name ilike '%S%'
    AND to_date(created) < current_date() - {{no_days}}

{%- endcall -%}

{%- set dist_sch = load_result('dist_sch_name')['data'][0][1] -%}

{% for sch in dist_sch %}
{{sch}}
{% endfor %}

{% endmacro %}