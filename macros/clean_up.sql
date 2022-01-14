{% macro clean_up(db_name, no_days) %}

{%- call statement('dist_sch_name', fetch_result=True) -%}

    SELECT DISTINCT schema_name
    FROM {{db_name}}.INFORMATION_SCHEMA.schemata
    WHERE schema_name ilike '%S%'
    AND to_date(created) < current_date() - {{no_days}}

{%- endcall -%}

{%- set dist_sch = load_result('dist_sch_name')['data'] -%}

{% for sch in dist_sch %}
{% set sch_str = sch|string %}
DROP SCHEMA {{db_name}}.{{sch_str[2:-3]}};
{% endfor %}

{% endmacro %}