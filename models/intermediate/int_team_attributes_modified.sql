{%- set team_attributes_columns_by_type = {
    'date': ['date'],
    'text': ['buildUpPlaySpeedClass',
               'buildUpPlayDribblingClass',
               'buildUpPlayPassingClass',
               'buildUpPlayPositioningClass',
               'chanceCreationPassingClass',
               'chanceCreationCrossingClass',
               'chanceCreationShootingClass',
               'chanceCreationPositioningClass',
               'defencePressureClass',
               'defenceAggressionClass',
               'defenceTeamWidthClass',
               'defenceDefenderLineClass'],
    'integer': ['id',
                'team_fifa_api_id',
                'team_api_id',
                'buildUpPlaySpeed',
                'buildUpPlayDribbling',
                'buildUpPlayPassing',
                'chanceCreationPassing',
                'chanceCreationCrossing',
                'chanceCreationShooting',
                'defencePressure',
                'defenceAggression',
                'defenceTeamWidth']
} %}

{%- set team_attributes_columns = team_attributes_columns_by_type['date'] +
                                  team_attributes_columns_by_type['integer'] +
                                  team_attributes_columns_by_type['text']
%}

WITH team AS (
    SELECT
        id,
        team_api_id,
        team_fifa_api_id,
        team_long_name,
        team_short_name
    FROM {{ ref('stg_team') }}
)
,
team_joined_with_team_attributes AS (
    SELECT
        team.team_long_name,
        team.team_short_name,
        {%- for _column in team_attributes_columns %}
        team_attributes.{{ _column }}{{ ',' if not loop.last }}
        {%- endfor %}
    FROM {{ ref('stg_team_attributes') }} AS team_attributes
        INNER JOIN team ON team_attributes.team_api_id = team.team_api_id
)

SELECT * FROM team_joined_with_team_attributes
