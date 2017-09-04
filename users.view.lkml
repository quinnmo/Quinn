view: users {
  sql_table_name: demo_db.users ;;
  label: "Users"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {       #age intervals
    type:  tier
    tiers: [10, 20, 30, 40, 50, 60, 70, 80, 90]
    style:  integer
    sql:  ${age} ;;
    drill_fields: [id, age]
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: in_US {
    type:  yesno
    sql:  ${country} = 'USA' ;;
  }


  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }



  dimension: gender {
    case: {
      when: {
        sql: ${TABLE}.gender = "m" ;;
        label:  "Male"
      }
      else:  "Female"
    }
    }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: avg_user_age {
    type: average
    sql: ${age} ;;
    drill_fields: [detail*, avg_user_age]
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      orders.count,
      user_data.count
    ]
  }
}
