{% macro clean_up_run(db_name, no_days) %}
{%- set query_db %}
    SELECT database_name
    FROM information_schema.databases
    WHERE database_name NOT IN ('SAMPLE1')
{% endset -%}
{%- set dbs = run_query(query_db) %}
{%- if execute -%}
{% set db_list = dbs.columns[0].values() %}
{% else %}
{% set db_list = [] %}
{%- endif -%}
{%- for db in db_list %}
    {%- set query_sch %}
        SELECT DISTINCT schema_name
        FROM {{db}}.INFORMATION_SCHEMA.schemata
        WHERE schema_name ilike 'OMOP_%'
        AND to_date(created) < current_date() - 40
    {% endset -%}
    {%- set schmeas = run_query(query_sch) %}
    {%- if execute -%}
        {% set sch_list = schmeas.columns[0].values() %}
    {% else %}
        {% set sch_list = [] %}
    {%- endif -%}
    {%- for sch in sch_list %}
        {%- set drop_sch %}
            DROP SCHEMA {{db}}.{{sch}};
        {% endset -%}
    {%set results2 = run_query(drop_sch)%}
    {%- endfor %}
{%- endfor %}
{% endmacro %}