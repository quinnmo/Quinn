view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: era {                  ##this company rebranded in 2004!!...
    case: {
      when: {
        sql: ${created_year} < 2004 ;;
        label: " pre-rebrand"
      }
      when: {
        sql: ${created_year} >= 2004 ;;
        label: "post-rebrand"
      }
      else: "unknown"
      }
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }


  measure: completed_order_count {      #count of completed orders
    type:  count
    filters: {
      field:  status
      value: " complete"
    }
    drill_fields: [id, created_date, users.last_name, users.first_name, users.id, order_items.count]
  }
}
