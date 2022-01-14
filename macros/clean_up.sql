{% macro clean_up(schema_name, no_days) %}

SELECT DISTINCT schema_name
FROM {{schema_name}}.INFORMATION_SCHEMA.schemata
WHERE schema_name ilike '%S%'
AND to_date(created) < current_date() - {{no_days}}

{% endmacro %}