view: orders {
  sql_table_name: demo_db.orders ;;
  label: "Orders"

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

  dimension: total_amount_of_order {
    type:  number
    sql: (SELECT SUM(order_items.sale_price)
      FROM order_items
      WHERE order_items.order_id = orders.id) ;;
    drill_fields: [details*]
    value_format: "usd"
  }

  dimension: total_cost_of_order{
    type: number
    sql: (SELECT SUM(inventory_items.cost)
      FROM order_items
      LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
      WHERE order_items.order_id = orders.id) ;;
    value_format: "usd"
  }

  dimension: order_profit {
    type: number
    value_format: "$0.00"
    sql: ${total_amount_of_order} - ${total_cost_of_order} ;;
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

  measure: average_order_profit {
    type: average
    sql: ${order_profit} ;;
    drill_fields: [details*]
    value_format: "usd"
  }

  measure: total_profit {         ##if unknown field error make sure to join inventory_items
    type:  sum
    sql: ${order_profit} ;;
    drill_fields: [details*]
    value_format: "usd"
  }

  measure: total_revenue {
    type: sum
    sql: ${total_amount_of_order} ;;
  }

  measure: total_expenses {
    type: sum
    sql: ${total_cost_of_order} ;;
  }

# DRILL SET
  set: details {
    fields: [
      id,
      created_time]
      }
    }
